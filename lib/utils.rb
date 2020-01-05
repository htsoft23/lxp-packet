# frozen_string_literal: true

module Utils
  module_function

  def int(bytes, order = :lsb)
    bytes = bytes.reverse if order == :msb

    bytes.each_with_index.map do |b, idx|
      b << (idx * 8)
    end.inject(:|)
  end

  def int_complement(bytes, order = :lsb)
    r = int(bytes, order)
    r -= 0x10000 if r & 0x8000 == 0x8000
    r
  end
end
