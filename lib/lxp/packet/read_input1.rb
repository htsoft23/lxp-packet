# frozen_string_literal: true

require_relative 'read_input'

class LXP
  class Packet
    class ReadInput1 < ReadInput
      # Decode the data and return a hash of values in this input packet
      def to_h
        {
          # 0 = static 1
          # 1 = R_INPUT
          # 2..12 = serial
          # 13/14 = length

          status: Utils.int(@data[15, 2]),

          # 17-22 all observed zeroes (v_pv, v_pv_2, v_pv_3 ?)

          v_bat: Utils.int(@data[23, 2]) / 10.0, # V
          soc: @data[25], # %
          # 26 used for anything?

          # observed [0, 47] => 12032 or 0x2F00
          _unknown_i1_28: @data[28],
          _unknown_i1_27_28: Utils.int(@data[27, 2]),

          p_pv: Utils.int(@data[29, 2]) +
            Utils.int(@data[31, 2]) +
            Utils.int(@data[33, 2]), # W
          p_pv_1: Utils.int(@data[29, 2]), # W
          p_pv_2: Utils.int(@data[31, 2]), # W
          p_pv_3: Utils.int(@data[33, 2]), # W
          p_charge: Utils.int(@data[35, 2]), # W
          p_discharge: Utils.int(@data[37, 2]), # W
          v_ac_r: Utils.int(@data[39, 2]) / 10.0, # V
          v_ac_s: Utils.int(@data[41, 2]) / 10.0, # V
          v_ac_t: Utils.int(@data[43, 2]) / 10.0, # V
          f_ac: Utils.int(@data[45, 2]) / 100.0, # Hz

          p_inv: Utils.int(@data[47, 2]), # W
          p_rec: Utils.int(@data[49, 2]), # W

          _unknown_i1_51_52: Utils.int(@data[51, 2]),

          pf: Utils.int(@data[53, 2]) / 1000.0, # Hz

          v_eps_r: Utils.int(@data[55, 2]) / 10.0, # V
          v_eps_s: Utils.int(@data[57, 2]) / 10.0, # V
          v_eps_t: Utils.int(@data[59, 2]) / 10.0, # V
          f_eps: Utils.int(@data[61, 2]) / 100.0, # Hz

          # peps and seps in 63..66?

          p_to_grid: Utils.int(@data[67, 2]), # W
          p_to_user: Utils.int(@data[69, 2]), # W

          e_pv_day: (Utils.int(@data[71, 2]) +
                     Utils.int(@data[73, 2]) + Utils.int(@data[75, 2])) / 10.0, # kWh
          e_pv_1_day: Utils.int(@data[71, 2]) / 10.0, # kWh
          e_pv_2_day: Utils.int(@data[73, 2]) / 10.0, # kWh
          e_pv_3_day: Utils.int(@data[75, 2]) / 10.0, # kWh
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
