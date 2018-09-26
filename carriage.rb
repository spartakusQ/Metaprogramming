# base class Carriage for train
class Carriage
  include CompanyName
  attr_reader :type, :num

  def initialize(type, num)
    @type = type
    @num = num
  end
end
