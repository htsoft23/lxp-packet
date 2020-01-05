# frozen_string_literal: true

require 'utils'
require_relative 'read_input'

class LXP
  class Packet
    class ReadInput2 < ReadInput
      # Decode the data and return a hash of values in this input packet
      def to_h
        {
          e_pv_all: Utils.int(@data[15, 4], :lsb) / 10.0, # kWh
          e_inv_all: Utils.int(@data[27, 4], :lsb) / 10.0, # kWh
          e_rec_all: Utils.int(@data[31, 4], :lsb) / 10.0, # kWh
          e_chg_all: Utils.int(@data[35, 4], :lsb) / 10.0, # kWh
          e_dischg_all: Utils.int(@data[39, 4], :lsb) / 10.0, # kWh
          e_eps_all: Utils.int(@data[43, 4], :lsb) / 10.0, # kWh
          e_to_grid_all: Utils.int(@data[47, 4], :lsb) / 10.0, # kWh
          e_to_user_all: Utils.int(@data[51, 4], :lsb) / 10.0, # kWh

          t_inner: Utils.int(@data[62, 2], :msb),
          t_rad_1: Utils.int(@data[64, 2], :msb),
          t_rad_2: Utils.int(@data[66, 2], :msb)
        }
      end
    end
  end
end
