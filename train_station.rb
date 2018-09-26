require_relative 'validation'
# class for controlling trains at the station
class TrainStation
  include InstanceCounter
  include Validate
  attr_reader :station_name, :trains
  @@station_name = []

  def initialize(station_name)
    @station_name = station_name
    @trains = []
    validate!
    @@station_name << self
    register_instance
  end

  def add_train(train)
    trains << train
    puts "На станцию #{station_name} прибыл поезд #{train.number}"
  end

  def send_train(train)
    trains.delete(train)
    train.station = 0
    puts "Со станции #{station_name}
     отправился поезд под номером: #{train.number}"
  end

  def show_trains(type = nil)
    if type
      puts "Поезда на станции #{station_name} типа #{type}: "
      trains.each { |train| puts train.number if train.type == type }
    else
      puts "Поезда на станции #{station_name}: "
      trains.each { |train| puts train.number }
    end
  end

  def self.all_station
    @@station_name
  end

  def each_train
    @trains.each { |train| yield train }
  end

  protected

  def validate!
    raise 'Название станции должно быть больше 3 символов' if station_name.length < 3
    raise 'Станция с таким именем уже существует!' if station_name == @@station_name
  end
end
