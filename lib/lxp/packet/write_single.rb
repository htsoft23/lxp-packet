# frozen_string_literal: true

require_relative 'base'

class LXP
  class Packet
    class WriteSingle < Base
      def initialize
        super

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
      # Base#value will return an int for protocol 1, or an Array
      # for protocol 2. If we can, convert that Array to an int.
      #
      def value
        raise 'value_length not 2?' unless value_length == 2

        r = super
        r.is_a?(Array) ? Utils.int(r, 2) : r
      end
    end
  end
end
