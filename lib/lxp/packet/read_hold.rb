# frozen_string_literal: true

require_relative 'base'

class LXP
  class Packet
    class ReadHold < Base
      def initialize
        super

        self.tcp_function = TcpFunctions::TRANSLATED_DATA
        self.device_function = DeviceFunctions::READ_HOLD

        self.data_length = 18

        # in ReadHold packets, the value is the number of registers
        # we want to read. Default to 1.
        self.value = 1
      end

      # Return the first value in a ReadHold packet. This is normally used
      # when the packet only has one value.
      #
      # #values returns an Array. This converts it to an int.
      #
      def value(offset = 0)
        Utils.int(values[offset, 2])
      end

      # Subscript notation is used when the ReadHold packet has multiple
      # registers in it. This is indicated by value_length > 2.
      #
      # In this case, #register tells us the first register in the values, then
      # each 2 bytes are subsequent registers.
      #
      def [](reg_num)
        offset = (reg_num - register) * 2

        return if offset.negative? || offset > data_length

        value(offset)
      end

      # Return a Hash of all register->values in the ReadHold packet.
      def to_h
        r = register

        values.each_slice(2).each_with_index.map do |v, idx|
          [r + idx, Utils.int(v)]
        end.to_h
      end
    end
  end
end
