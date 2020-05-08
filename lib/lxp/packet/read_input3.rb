# frozen_string_literal: true

require_relative 'read_input'

class LXP
  class Packet
    class ReadInput3 < ReadInput
      def initialize
        super

        self.register = 80
        self.value = 40
      end

      # Decode the data and return a hash of values in this input packet
      def to_h
        {
          # 0 = static 1
          # 1 = R_INPUT
          # 2..12 = serial
          # 13/14 = length

          # 15..16? .. (observed: 10)

          max_chg_curr: Utils.int(@data[17, 2]) / 100.0, # A
          max_dischg_curr: Utils.int(@data[19, 2]) / 100.0, # A
          charge_volt_ref: Utils.int(@data[21, 2]) / 10.0, # V
          dischg_cut_volt: Utils.int(@data[23, 2]) / 10.0, # V

          # are these actually 2 bytes as well?
          # never seen data in them so its hard to tell.
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
          bat_status_inv: @data[45],

          bat_count: Utils.int(@data[47, 2])
        }
      end
    end
  end
end
