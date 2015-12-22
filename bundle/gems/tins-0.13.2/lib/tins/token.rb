module Tins
  class Token < String
    DEFAULT_ALPHABET = ((?0..?9).to_a + (?a..?z).to_a + (?A..?Z).to_a).freeze

    #def initialize(bits: 128, length: nil, alphabet: DEFAULT_ALPHABET)
    def initialize(options = {})
      bits     = options[:bits] || 128
      length   = options[:length]
      alphabet = options[:alphabet] || DEFAULT_ALPHABET
      alphabet.size > 1 or raise ArgumentError, 'need at least 2 symbols in alphabet'
      if length
        length > 0 or raise ArgumentError, 'length has to be positive'
      else
        bits > 0 or raise ArgumentError, 'bits has to be positive'
        length = (Math.log(1 << bits) / Math.log(alphabet.size)).ceil
      end
      self.bits = (Math.log(alphabet.size ** length) / Math.log(2)).floor
      token = ''
      length.times { token << alphabet[rand(alphabet.size)] }
      super token
    end

    attr_accessor :bits
  end
end
