# frozen_string_literal: true

class LXP
  module Utils
    module_function

    def int(bytes)
      bytes.each_with_index.map do |b, idx|
        b << (idx * 8)
      end.inject(:|)
    end

    def int_complement(bytes)
      r = int(bytes)
      r -= 0x10000 if r & 0x8000 == 0x8000
      r
    end
  end
end
