# class of a passenger car, the parent car is a Carriage
class PassengerCarriage < Carriage
  def initialize(num, seats)
    @num = num.to_i
    @seats = seats.to_i
    validate!
    @occupied_seats = 0
  end

  def occupy_seat
    raise 'Все места заняты' if @occupied_seats == @seats

    @occupied_seats += 1
  end

  def free_seats
    @seats - @occupied_seats
  end

  def to_s
    "Номер #{num} тип #{self.class},
     занято - #{@occupied_seats}, свободных - #{free_seats}"
  end

  protected

  def validate!
    raise 'Количество мест не должно быть 0' if @seats < 1
  end
end
