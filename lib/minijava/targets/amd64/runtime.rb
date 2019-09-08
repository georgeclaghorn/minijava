require "mustache"

module MiniJava
  module AMD64
    class Runtime < Mustache
      self.template_file = File.expand_path("./runtime.mustache", __dir__)
    end
  end
end
