# module for checking the correctness of the input
module Validation
  def self.included(base)
    base.extend ClassMethods
    base.send :include, InstanceMethods
  end

  module ClassMethods
    attr_reader :validations

    def validate(name, type, *opts)
      @validations ||= []
      @validations << { name: name, type: type, opts: opts }
    end
  end

  module InstanceMethods
    def validate!
      self.class.validations.each do |validation|
        send (validation[:type]).to_s, validation[:name], validation[:opts]
      end
      true
    end

    def valid?
      validate!
    rescue
      false
    end

    private

    def presence(name, *_opts)
      raise ArgumentError, "#{name} равно nil, или пустой строке" if send(name.to_s).to_s.empty?
    end

    def type(name, type)
      raise ArgumentError, "Класс #{name} не совпадает" unless send(name.to_s).is_a?(type)
    end

    def format(name, format)
      raise ArgumentError, "#{name} не соответствует #{format}" unless name.to_s =~ format
    end
  end
end
