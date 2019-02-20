module RInjector
  module Container
    def initialize
      @types = {}
      build
    end

    def register(name, type)
      @types[name] = type
    end

    def resolve(name)
      type = @types[name]
      create(type, dependencies(type))
    end

    def dependencies(type)
      deps = type
        .instance_method(:initialize)
        .parameters
        .map { |ptype, pname| [pname, resolve(pname)]  }

      Hash[deps]
    end

    def create(type, deps)
      deps.empty? ? type.new : type.new(deps)
    end
  end
end
