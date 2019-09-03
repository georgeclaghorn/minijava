module MiniJava
  class HashWithNormalizedKeys
    def initialize(&normalizer)
      @hash, @normalizer = {}, normalizer
    end

    def [](key)
      @hash[normalize(key)]
    end

    def []=(key, value)
      @hash[normalize(key)] = value
    end

    def include?(key)
      @hash.include?(normalize(key))
    end

    private
      def normalize(key)
        @normalizer.call(key)
      end
  end
end
