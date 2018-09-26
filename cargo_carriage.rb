# family class to Carriage
class CargoCarriage < Carriage
  def initialize(num, capacity)
    @num = num.to_i
    @capacity = capacity.to_f
    validate!
    @free_capacity = @capacity
  end

  def load(capacity)
    raise 'Объем вагона не может быть меньше 0' if @free_capacity - capacity < 0

    @free_capacity -= capacity
  end

  def occupy_capacity
    @capacity - @free_capacity
  end

  def to_s
    "Номер вагона - #{num} тип - #{self.class},
    занятый объём - #{occupy_capacity}, cвободный объем - #{@free_capacity}"
  end

  protected

  def validate!
    raise 'Объем вагона не может быть 0 ' if @capacity.zero?
  end
end
