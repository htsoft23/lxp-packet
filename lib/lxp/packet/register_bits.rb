# frozen_string_literal: true

class LXP
  class Packet
    module RegisterBits
      ###
      ### Register 21, Most Significant Byte
      ###
      FEED_IN_GRID            = 1 << 15
      DCI_ENABLE              = 1 << 14
      GFCI_ENABLE             = 1 << 13
      R21_UNKNOWN_BIT_12      = 1 << 12
      CHARGE_PRIORITY         = 1 << 11
      FORCED_DISCHARGE_ENABLE = 1 << 10
      NORMAL_OR_STANDBY       = 1 << 9
      SEAMLESS_EPS_SWITCHING  = 1 << 8

      ### Register 21, Least Significant Byte
      AC_CHARGE_ENABLE       = 1 << 7
      GRID_ON_POWER_SS       = 1 << 6
      NEUTRAL_DETECT_ENABLE  = 1 << 5
      ANTI_ISLAND_ENABLE     = 1 << 4
      R21_UNKNOWN_BIT_3      = 1 << 3
      DRMS_ENABLE            = 1 << 2
      OVF_LOAD_DERATE_ENABLE = 1 << 1
      POWER_BACKUP_ENABLE    = 1 << 0

      # Not a recommendation, just what my defaults appeared to be when
      # setting up the unit for the first time, so probably sane..?
      R21_DEFAULTS = FEED_IN_GRID |
                     DCI_ENABLE | GFCI_ENABLE |
                     R21_UNKNOWN_BIT_12 |
                     NORMAL_OR_STANDBY | SEAMLESS_EPS_SWITCHING |
                     GRID_ON_POWER_SS | ANTI_ISLAND_ENABLE |
                     DRMS_ENABLE

      ###
      ### Register 105, Least Significant Byte
      ###
      MICRO_GRID_ENABLE       = 1 << 2
      FAST_ZERO_EXPORT_ENABLE = 1 << 1
    end
  end
end
