# frozen_string_literal: true

RSpec.describe LXP::Packet::ReadHold do
  let(:packet) { LXP::Packet::ReadHold.new }

  before do
    packet.inverter_serial = '1234567890'
    packet.datalog_serial = '0987654321'
    packet.register = 21
  end

  it 'has the correct attributes' do
    expect(packet).to have_attributes register: 21, values: [1, 0], value: 1,
                                      to_h: { 21 => 1 },
                                      protocol: 1,
                                      packet_length: 32, data_length: 18,
                                      tcp_function: LXP::Packet::TcpFunctions::TRANSLATED_DATA,
                                      device_function: LXP::Packet::DeviceFunctions::READ_HOLD,
                                      inverter_serial: '1234567890',
                                      datalog_serial: '0987654321',
                                      bytes: [161, 26, 1, 0, 32, 0, 1, 194, 48, 57, 56, 55, 54, 53, 52, 51, 50, 49, 18, 0, 0, 3, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 21, 0, 1, 0, 241, 72]
    expect(packet[21]).to eq 1
  end

  it 'creates the correct binary' do
    expect(packet.to_bin).to eq [161, 26, 1, 0, 32, 0, 1, 194, 48, 57, 56, 55, 54, 53, 52, 51, 50, 49, 18, 0, 0, 3, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 21, 0, 1, 0, 241, 72].pack('C*')
  end

  it 'works with protocol 2' do
    packet.protocol = 2
    expect(packet).to have_attributes protocol: 2,
                                      bytes: [161, 26, 2, 0, 32, 0, 1, 194, 48, 57, 56, 55, 54, 53, 52, 51, 50, 49, 18, 0, 0, 3, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 21, 0, 1, 0, 241, 72]
  end
end
