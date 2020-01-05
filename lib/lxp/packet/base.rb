# frozen_string_literal: true

require_relative 'device_functions'

class LXP
  class Packet
    class Base
      # 20 bytes
      attr_accessor :header

      # usually 16 bytes?
      attr_accessor :data

      # 2 bytes
      attr_accessor :chksum

      def initialize
        @header = [0] * 20
        @data = [0] * 16
        @chksum = [0, 0]

        # prefix
        @header[0] = 161
        @header[1] = 26

        self.protocol = 1

        # length after first 6 bytes maybe?
        self.packet_length = 32

        @header[6] = 1 # unsure

        @header[7] = 194 # translated data, TBD
      end

      def bytes
        update_checksum
        header + data + chksum
      end

      def to_bin
        bytes.pack('C*')
      end

      def self.parse(ascii)
        # array of integers
        bdata = ascii.unpack('C*')

        raise 'invalid packet' if bdata[0] != 161 || bdata[1] != 26

        i = new

        # header is always 20 bytes
        i.header[0, 20] = bdata[0, 20]

        # data can vary from 17 bytes upwards
        i.data = bdata[20, i.data_length - 2] # -2, don't copy checksum
        raise 'bad data length' unless i.data.length != i.data_length

        # calculate checksum and compare to input
        i.update_checksum
        raise 'invalid checksum' if i.chksum != bdata[-2..-1]

        i
      end

      def protocol
        @header[2] | @header[3] >> 8
      end

      def protocol=(protocol)
        @header[2] = protocol & 0xff
        @header[3] = (protocol >> 8) & 0xff
      end

      def packet_length
        @header[4] | @header[5] >> 8
      end

      def packet_length=(packet_length)
        @header[4] = packet_length & 0xff
        @header[5] = (packet_length >> 8) & 0xff
      end

      # Passed as a string
      def datalog_serial=(datalog_serial)
        @header[8, 10] = datalog_serial.bytes
      end

      def data_length
        @header[18] | @header[19] >> 8
      end

      def data_length=(data_length)
        @header[18] = data_length & 0xff
        @header[19] = (data_length >> 8) & 0xff
      end

      def device_function
        @data[1]
      end

      def device_function=(device_function)
        @data[1] = device_function
      end

      # Passed as a string
      def inverter_serial=(inverter_serial)
        @data[2, 10] = inverter_serial.bytes
      end

      def register
        @data[12] | @data[13] >> 8
      end

      def register=(register)
        @data[12] = register & 0xff
        @data[13] = (register >> 8) & 0xff
      end

      def value_length_byte?
        @value_length_byte ||=
          protocol == 2 &&
          device_function != DeviceFunctions::WRITE_SINGLE
      end

      def value_length
        if value_length_byte?
          @data[14]
        else
          2
        end
      end

      # protocol 1 has value at 14 and 15
      # protocol 2 has length at 14, then that many bytes of values
      #
      # So this can return an int or an array.
      #
      def value
        if value_length_byte?
          @data[15, value_length]
        else
          @data[14] | @data[15] >> 8
        end
      end

      # this only makes sense for protocol 1 at the moment.
      # for 2 we'd need to append to an array, and not sure that
      # is even used (sending an array of values to inverter)
      # (maybe with W_MULTI?)
      def value=(value)
        raise 'cannot set value with protocol 2 yet' if protocol == 2

        @data[14] = value & 0xff
        @data[15] = (value >> 8) & 0xff
      end

      def update_checksum
        chksum = crc16_modbus(data)
        @chksum[0] = chksum & 0xff
        @chksum[1] = (chksum >> 8) & 0xff
      end

      private

      def crc16_modbus(arr)
        arr.length.times.inject(0xffff) do |r, n|
          r ^= arr[n]
          8.times do
            t = r >> 1
            r = (r & 1).positive? ? 40_961 ^ t : t
          end
          r
        end
      end
    end
  end
end
