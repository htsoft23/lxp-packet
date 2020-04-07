# frozen_string_literal: true

require_relative 'base'

class LXP
  class Packet
    class WriteSingle < Base
      def initialize
        super

        self.tcp_function = TcpFunctions::TRANSLATED_DATA
        self.device_function = DeviceFunctions::WRITE_SINGLE
        self.data_length = 18
      end

      def discharge_rate=(value)
        self.register = Registers::DISCHG_POWER_PERCENT_CMD
        self.value = value
      end

      def discharge_cut_off=(value)
        self.register = Registers::DISCHG_CUT_OFF_SOC_EOD
        self.value = value
      end

      # WriteSingle packets should always (I think) have two byte values.
      #
      # Raise if not, as that is not expected?
      #
      def value
        raise 'value_length not 2?' unless value_length == 2

        Utils.int(values[0, 2])
      end
    end
  end
end
