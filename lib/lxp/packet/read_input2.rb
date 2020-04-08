# frozen_string_literal: true

require_relative 'read_input'

class LXP
  class Packet
    class ReadInput2 < ReadInput
      # Decode the data and return a hash of values in this input packet
      def to_h
        {
          e_pv_all: Utils.int(@data[15, 4]) / 10.0, # kWh
          e_inv_all: Utils.int(@data[27, 4]) / 10.0, # kWh
          e_rec_all: Utils.int(@data[31, 4]) / 10.0, # kWh
          e_chg_all: Utils.int(@data[35, 4]) / 10.0, # kWh
          e_dischg_all: Utils.int(@data[39, 4]) / 10.0, # kWh
          e_eps_all: Utils.int(@data[43, 4]) / 10.0, # kWh
          e_to_grid_all: Utils.int(@data[47, 4]) / 10.0, # kWh
          e_to_user_all: Utils.int(@data[51, 4]) / 10.0, # kWh

          # 55 .. 62?
          #   fault code? 4 bytes?
          #   warning code? 4 bytes?

          t_inner: Utils.int(@data[63, 2]),
          t_rad_1: Utils.int(@data[65, 2]),
          t_rad_2: Utils.int(@data[67, 2]),
          t_bat: Utils.int(@data[69, 2])
        }
      end
    end
  end
end
