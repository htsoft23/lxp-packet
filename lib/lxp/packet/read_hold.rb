# frozen_string_literal: true

require_relative 'base'
require_relative 'device_functions'

class LXP
  class Packet
    class ReadHold < Base
      def initialize
        super

        self.device_function = DeviceFunctions::READ_HOLD

        self.data_length = 18
        # start by assuming this packet will be sent to the inverter.
        # we need to put a 1 in the value to get the inverter to
        # populate the reply.
        self.value = 1
      end

      # ReadHold packets should always (I think) have two byte values.
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
