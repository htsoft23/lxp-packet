# frozen_string_literal: true

class LXP
  class Packet
    module DeviceFunctions
      READ_HOLD    = 3
      READ_INPUT   = 4
      WRITE_SINGLE = 6
      WRITE_MULTI  = 16

      # not handled yet
      READ_HOLD_ERROR    = 131
      READ_INPUT_ERROR   = 132
      WRITE_SINGLE_ERROR = 134
      WRITE_MULTI_ERROR  = 144
    end
  end
end
