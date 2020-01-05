# frozen_string_literal: true

require 'utils'

require_relative 'device_functions'
require_relative 'tcp_functions'

class LXP
  class Packet
    # Given an input string, work out which type of LXP::Packet it should be,
    # and call .parse on the appropriate class.
    class Parser
      attr_reader :ascii, :bdata

      def self.parse(ascii)
        new(ascii).parse
      end

      def initialize(ascii)
        @ascii = ascii
        @bdata = ascii.unpack('C*')
      end

      def parse
        case bdata[7] # tcp_function
        when TcpFunctions::HEARTBEAT then nil # ignored
        when TcpFunctions::TRANSLATED_DATA then parse_translated_data
        else
          raise "unhandled tcp_function #{bdata[7]}"
        end
      end

      def parse_translated_data
        kls = case bdata[21] # device_function
              when DeviceFunctions::READ_HOLD then ReadHold
              when DeviceFunctions::WRITE_SINGLE then WriteSingle
              when DeviceFunctions::READ_INPUT then parse_input
              else
                raise "unhandled device_function #{bdata[21]}"
              end

        kls.parse(ascii)
      end

      # Input packets are 1-of-3; work out which it is from the register
      def parse_input
        case Utils.int(bdata[32, 2]) # register
        when 0  then ReadInput1
        when 40 then ReadInput2
        when 80 then ReadInput3
        end
      end
    end
  end
end
