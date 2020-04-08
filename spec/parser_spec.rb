# frozen_string_literal: true

RSpec.describe LXP::Packet::Parser do
  let(:parser) { LXP::Packet::Parser.new(input.pack('C*')) }
  let(:packet) { parser.parse }

  subject { packet }

  context 'ReadHold multi data (registers 0-22)' do
    let(:input) { [161, 26, 2, 0, 77, 0, 1, 194, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 63, 0, 1, 3, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 0, 0, 46, 134, 138, 1, 0, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 66, 65, 65, 65, 1, 10, 10, 1, 0, 0, 20, 4, 7, 16, 14, 49, 1, 0, 1, 0, 0, 0, 0, 0, 4, 0, 0, 0, 84, 243, 176, 4, 40, 224] }

    it { is_expected.to be_a LXP::Packet::ReadHold }

    it 'has the correct attributes' do
      expect(packet).to have_attributes register: 0,
                                        values: [134, 138, 1, 0, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 66, 65, 65, 65, 1, 10, 10, 1, 0, 0, 20, 4, 7, 16, 14, 49, 1, 0, 1, 0, 0, 0, 0, 0, 4, 0, 0, 0, 84, 243, 176, 4],
                                        to_h: { 0 => 35_462, 1 => 1, 2 => 22_616, 3 => 22_616, 4 => 22_616, 5 => 22_616, 6 => 22_616, 7 => 16_706, 8 => 16_705, 9 => 2561, 10 => 266, 11 => 0, 12 => 1044, 13 => 4103, 14 => 12_558, 15 => 1, 16 => 1, 17 => 0, 18 => 0, 19 => 4, 20 => 0, 21 => 62_292, 22 => 1200 },
                                        protocol: 2,
                                        packet_length: 77, data_length: 63,
                                        tcp_function: LXP::Packet::TcpFunctions::TRANSLATED_DATA,
                                        device_function: LXP::Packet::DeviceFunctions::READ_HOLD,
                                        inverter_serial: 'XXXXXXXXXX',
                                        datalog_serial: 'cccccccccc',
                                        bytes: input
      expect(packet[22]).to eq 1200

      # test out of bounds subscripts return nil
      expect(packet[23]).to be_nil
    end
  end

  context 'ReadHold multi data (registers 80-113)' do
    let(:input) { [161, 26, 2, 0, 99, 0, 1, 194, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 85, 0, 1, 3, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 80, 0, 68, 0, 0, 0, 0, 100, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 230, 0, 50, 0, 111, 9, 252, 8, 20, 0, 5, 0, 0, 0, 0, 0, 0, 0, 48, 2, 144, 1, 66, 0, 66, 0, 0, 0, 0, 0, 10, 0, 56, 255, 38, 2, 0, 0, 144, 1, 2, 0, 0, 0, 0, 0, 0, 0, 193, 242] }

    it { is_expected.to be_a LXP::Packet::ReadHold }

    it 'has the correct attributes' do
      expect(packet).to have_attributes register: 80,
                                        values: [0, 0, 0, 0, 100, 0, 20, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 230, 0, 50, 0, 111, 9, 252, 8, 20, 0, 5, 0, 0, 0, 0, 0, 0, 0, 48, 2, 144, 1, 66, 0, 66, 0, 0, 0, 0, 0, 10, 0, 56, 255, 38, 2, 0, 0, 144, 1, 2, 0, 0, 0, 0, 0, 0, 0],
                                        to_h: { 80 => 0, 81 => 0, 82 => 100, 83 => 20, 84 => 0, 85 => 0, 86 => 0, 87 => 0, 88 => 0, 89 => 0, 90 => 230, 91 => 50, 92 => 2415, 93 => 2300, 94 => 20, 95 => 5, 96 => 0, 97 => 0, 98 => 0, 99 => 560, 100 => 400, 101 => 66, 102 => 66, 103 => 0, 104 => 0, 105 => 10, 106 => 65_336, 107 => 550, 108 => 0, 109 => 400, 110 => 2, 111 => 0, 112 => 0, 113 => 0 },
                                        protocol: 2,
                                        packet_length: 99, data_length: 85,
                                        tcp_function: LXP::Packet::TcpFunctions::TRANSLATED_DATA,
                                        device_function: LXP::Packet::DeviceFunctions::READ_HOLD,
                                        inverter_serial: 'XXXXXXXXXX',
                                        datalog_serial: 'cccccccccc',
                                        bytes: input
      expect(packet[80]).to eq 0
      expect(packet[94]).to eq 20
      expect(packet[113]).to eq 0

      # test out of bounds subscripts return nil
      expect(packet[114]).to be_nil
      expect(packet[79]).to be_nil
    end
  end

  context 'ReadInput1 data' do
    let(:input) { [161, 26, 2, 0, 111, 0, 1, 194, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 97, 0, 1, 4, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 0, 0, 80, 16, 0, 0, 0, 0, 0, 0, 0, 241, 1, 95, 0, 0, 47, 0, 0, 0, 0, 0, 0, 0, 0, 121, 2, 172, 9, 1, 0, 0, 0, 146, 19, 57, 2, 0, 0, 227, 0, 232, 3, 172, 9, 0, 11, 80, 112, 146, 19, 0, 0, 0, 0, 0, 0, 0, 0, 221, 0, 0, 0, 0, 0, 42, 0, 73, 0, 86, 0, 52, 0, 0, 0, 36, 0, 2, 0, 172, 14, 181, 11, 127, 131] }

    it { is_expected.to be_a LXP::Packet::ReadInput1 }

    it 'has the correct attributes' do
      expect(packet).to have_attributes register: 0,
                                        values: [16, 0, 0, 0, 0, 0, 0, 0, 241, 1, 95, 0, 0, 47, 0, 0, 0, 0, 0, 0, 0, 0, 121, 2, 172, 9, 1, 0, 0, 0, 146, 19, 57, 2, 0, 0, 227, 0, 232, 3, 172, 9, 0, 11, 80, 112, 146, 19, 0, 0, 0, 0, 0, 0, 0, 0, 221, 0, 0, 0, 0, 0, 42, 0, 73, 0, 86, 0, 52, 0, 0, 0, 36, 0, 2, 0, 172, 14, 181, 11],
                                        protocol: 2,
                                        packet_length: 111, data_length: 97,
                                        tcp_function: LXP::Packet::TcpFunctions::TRANSLATED_DATA,
                                        device_function: LXP::Packet::DeviceFunctions::READ_INPUT,
                                        inverter_serial: 'XXXXXXXXXX',
                                        datalog_serial: 'cccccccccc',
                                        bytes: input
    end

    describe '#to_h' do
      subject { packet.to_h }
      it { is_expected.to eq status: 16, v_bat: 49.7, soc: 95, p_pv: 0, p_charge: 0, p_discharge: 633, v_acr: 247.6, f_ac: 50.1, p_inv: 569, p_rec: 0, v_eps: 247.6, f_eps: 50.1, p_to_grid: 0, p_to_user: 0, e_pv_day: 22.1, e_inv_day: 4.2, e_rec_day: 7.3, e_chg_day: 8.6, e_dischg_day: 5.2, e_eps_day: 0.0, e_to_grid_day: 3.6, e_to_user_day: 0.2, v_bus_1: 375.6, v_bus_2: 299.7 }
    end
  end

  context 'ReadInput2 data' do
    let(:input) { [161, 26, 2, 0, 111, 0, 1, 194, 99, 99, 99, 99, 99, 99, 99, 99, 99, 99, 97, 0, 1, 4, 88, 88, 88, 88, 88, 88, 88, 88, 88, 88, 40, 0, 80, 83, 69, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 179, 38, 0, 0, 43, 45, 0, 0, 105, 51, 0, 0, 44, 47, 0, 0, 0, 0, 0, 0, 95, 5, 0, 0, 63, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 48, 0, 36, 0, 37, 0, 0, 0, 0, 0, 35, 136, 224, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 188, 199] }

    it { is_expected.to be_a LXP::Packet::ReadInput2 }

    it 'has the correct attributes' do
      expect(packet).to have_attributes register: 40,
                                        values: [83, 69, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 179, 38, 0, 0, 43, 45, 0, 0, 105, 51, 0, 0, 44, 47, 0, 0, 0, 0, 0, 0, 95, 5, 0, 0, 63, 46, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 48, 0, 36, 0, 37, 0, 0, 0, 0, 0, 35, 136, 224, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
                                        protocol: 2,
                                        packet_length: 111, data_length: 97,
                                        tcp_function: LXP::Packet::TcpFunctions::TRANSLATED_DATA,
                                        device_function: LXP::Packet::DeviceFunctions::READ_INPUT,
                                        inverter_serial: 'XXXXXXXXXX',
                                        datalog_serial: 'cccccccccc',
                                        bytes: input
    end

    describe '#to_h' do
      subject { packet.to_h }
      it { is_expected.to eq e_chg_all: 1316.1, e_dischg_all: 1207.6, e_eps_all: 0.0, e_inv_all: 990.7, e_pv_all: 1774.7, e_rec_all: 1156.3, e_to_grid_all: 137.5, e_to_user_all: 1183.9, t_bat: 0, t_inner: 48, t_rad_1: 36, t_rad_2: 37 }
    end
  end
end
