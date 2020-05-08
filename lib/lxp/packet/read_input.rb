# frozen_string_literal: true

require_relative 'base'

class LXP
  class Packet
    # Input packets are a stream of values related to energy flows (inputs?)
    class ReadInput < Base
      def initialize
        super

        self.tcp_function = TcpFunctions::TRANSLATED_DATA
        self.device_function = DeviceFunctions::READ_INPUT

        self.data_length = 18
      end

      def self.parse(ascii)
        i = super

        if i.packet_length != 111 || i.data_length != 97
          raise 'unexpected packet length'
        end

        i
      end
    end
  end
end
