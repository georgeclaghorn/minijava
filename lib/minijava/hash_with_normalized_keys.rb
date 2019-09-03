module MiniJava
  class HashWithNormalizedKeys
    def initialize(&normalizer)
      @hash, @normalizer = {}, normalizer
    end

    def [](key)
      @hash[normalize(key)]
    end

    def []=(key, value)
      store key, value
    end

    def store(key, value)
      @hash[normalize(key)] = value
      self
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
