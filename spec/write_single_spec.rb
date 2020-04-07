# frozen_string_literal: true

RSpec.describe LXP::Packet::WriteSingle do
  let(:packet) { LXP::Packet::WriteSingle.new }

  before do
    packet.inverter_serial = '1234567890'
    packet.datalog_serial = '0987654321'
    packet.register = 21
    packet.value = 8000
  end

  it 'has the correct attributes' do
    expect(packet).to have_attributes register: 21, values: [64, 31], value: 8000,
                                      protocol: 1,
                                      packet_length: 32, data_length: 18,
                                      tcp_function: LXP::Packet::TcpFunctions::TRANSLATED_DATA,
                                      device_function: LXP::Packet::DeviceFunctions::WRITE_SINGLE,
                                      inverter_serial: '1234567890',
                                      datalog_serial: '0987654321',
                                      bytes: [161, 26, 1, 0, 32, 0, 1, 194, 48, 57, 56, 55, 54, 53, 52, 51, 50, 49, 18, 0, 0, 6, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 21, 0, 64, 31, 69, 211]
  end

  it 'creates the correct binary' do
    expect(packet.to_bin).to eq [161, 26, 1, 0, 32, 0, 1, 194, 48, 57, 56, 55, 54, 53, 52, 51, 50, 49, 18, 0, 0, 6, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 21, 0, 64, 31, 69, 211].pack('C*')
  end

  it 'works with protocol 2' do
    packet.protocol = 2
    expect(packet).to have_attributes protocol: 2,
                                      bytes: [161, 26, 2, 0, 32, 0, 1, 194, 48, 57, 56, 55, 54, 53, 52, 51, 50, 49, 18, 0, 0, 6, 49, 50, 51, 52, 53, 54, 55, 56, 57, 48, 21, 0, 64, 31, 69, 211]
  end
end
