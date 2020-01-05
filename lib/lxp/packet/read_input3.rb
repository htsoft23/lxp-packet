# frozen_string_literal: true

require 'utils'
require_relative 'read_input'

class LXP
  class Packet
    class ReadInput3 < ReadInput
      # Decode the data and return a hash of values in this input packet
      def to_h
        {
          max_chg_curr: Utils.int(@data[17, 2], :lsb) / 100.0, # A
          max_dischg_curr: Utils.int(@data[19, 2], :lsb) / 100.0, # A
          charge_volt_ref: Utils.int(@data[21, 2], :lsb) / 10.0, # V
          dischg_cut_volt: Utils.int(@data[23, 2], :lsb) / 10.0, # V

          bat_status_0: @data[25],
          bat_status_1: @data[27],
          bat_status_2: @data[29],
          bat_status_3: @data[31],
          bat_status_4: @data[33],
          bat_status_5: @data[35],
          bat_status_6: @data[37],
          bat_status_7: @data[39],
          bat_status_8: @data[41],
          bat_status_9: @data[43],
          bat_status_inv: @data[45]
        }
      end
    end
  end
end
