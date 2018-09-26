# module for adding a class variable creation counter
module InstanceCounter
  def self.included(base)
    base.extend ClassMethods
    base.include InstanceMethods
  end
  # module that returns the number of instances of this class
  module ClassMethods
    attr_reader :instances

    private

    def register_instance
      @instances ||= 0
      @instances += 1
    end
  end
  # module that increments the count of the number of instances of the class
  module InstanceMethods
    protected

    def register_instance
      self.class.send(:register_instance)
    end
  end
end
