# frozen_string_literal: true

require_relative 'read_input'

class LXP
  class Packet
    class ReadInput1 < ReadInput
      # Decode the data and return a hash of values in this input packet
      def to_h
        {
          status: @data[15],

          v_bat: Utils.int(@data[23, 2]) / 10.0, # V
          soc: @data[25], # %

          # 26..28 ?

          p_pv: Utils.int(@data[29, 2]), # W
          p_charge: Utils.int(@data[35, 2]), # W
          p_discharge: Utils.int(@data[37, 2]), # W
          v_acr: Utils.int(@data[39, 2]) / 10.0, # V
          f_ac: Utils.int(@data[45, 2]) / 100.0, # Hz

          p_inv: Utils.int(@data[47, 2]), # W
          p_rec: Utils.int(@data[49, 2]), # W

          # 51..54 ?

          v_eps: Utils.int(@data[55, 2]) / 10.0, # V
          f_eps: Utils.int(@data[61, 2]) / 100.0, # Hz

          # peps and seps in 63..66?

          p_to_grid: Utils.int(@data[67, 2]), # W
          p_to_user: Utils.int(@data[69, 2]), # W

          e_pv_day: Utils.int(@data[71, 2]) / 10.0, # kWh
          # 73..76 ?
          e_inv_day: Utils.int(@data[77, 2]) / 10.0, # kWh
          e_rec_day: Utils.int(@data[79, 2]) / 10.0, # kWh
          e_chg_day: Utils.int(@data[81, 2]) / 10.0, # kWh
          e_dischg_day: Utils.int(@data[83, 2]) / 10.0, # kWh
          e_eps_day: Utils.int(@data[85, 2]) / 10.0, # kWh
          e_to_grid_day: Utils.int(@data[87, 2]) / 10.0, # kWh
          e_to_user_day: Utils.int(@data[89, 2]) / 10.0, # kWh

          v_bus_1: Utils.int(@data[91, 2]) / 10.0, # V
          v_bus_2: Utils.int(@data[93, 2]) / 10.0 # V
        }
      end
    end
  end
end
