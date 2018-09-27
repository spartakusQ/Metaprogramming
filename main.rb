require_relative 'train'
require_relative 'route'
require_relative 'train_station'
require_relative 'carriage'
require_relative 'cargo_train'
require_relative 'cargo_carriage'
require_relative 'passenger_train'
require_relative 'passenger_carriage'
require_relative 'validation'

# class for program management
class Main
  attr_accessor :station, :trains, :train, :route, :stations,
                :number, :name, :carriage, :type, :carriages, :num

  include Validation

  def initialize
    @stations = []
    @trains = []
    @routes = []
    @carriages = []
  end

  def menu
    puts %(
      Выберете нужное вам меню:
      1.Создание станции.
      2.Создание поезда.
      3.Создание маршрута и управление станциями.
      4.Назначение маршрута поезду.
      5.Добавление выгоны к поезду.
      6.Отцепить вагоны от поезда.
      7.Перемещать поезд по маршруту вперёд и назад.
      8.Просматривать список станций и список поездов на станции.
      9.Просмотр данных о поезде.
      0.Выход из меню.
      )
    puts 'Введите номер команды: '
    input = gets.to_i
    case input
    when 1
      create_station
    when 2
      create_train
    when 3
      create_route
    when 4
      route_train
    when 5
      add_carriage
    when 6
      unhook_carriage
    when 7
      move_train
    when 8
      station_menu
    when 9
      train_info
    when 0
      puts 'Счастливого пути!'
      exit
    end
  end

  private

  def create_station
    puts 'Введите название станции которую хотите создать: '
    name = gets.chomp.capitalize
    @station = TrainStation.new(name)
    @stations << station
    puts "Станция #{name}  создана"
    menu
  end

  def create_train
    puts 'Поезд с каким номером хотите создать?'
    puts '1 - пассажирский; 2 - грузовой'
    input = gets.chomp.to_i
    case input
    when 1
      puts 'Для создания пассажирского поезда, введите номер поезда '
      number = gets.chomp
      @train = PassengerTrain.new(number)
      @trains << train
      puts "Поезд номер #{number}  пассажирского типа создан"
      menu
    when 2
      puts 'Для создания грузового поезда, введите номер поезда'
      number = gets.chomp
      @train = CargoTrain.new(number)
      @trains << train
      puts "Поезд номер #{number} грузового типа создан"
      menu
    end
    rescue RuntimeError => e
    puts e.message
    menu
  end

  def station_list
    stations.each { |station| puts station.station_name } || 'Станций не существует'
  end

  def create_route
    station_list
    puts 'Выберете начальную станцию маршрута из списка:'
    input = gets.chomp.capitalize
    index = @stations.find_index { |station| station.station_name == input }
    first = @stations[index]
    puts 'Выберите конечную станцию маршрута из списка:'
    input = gets.chomp.capitalize
    index = @stations.find_index { |station| station.station_name == input }
    last = @stations[index]
    @route = Route.new(first, last)
    @routes << @route
    puts "Маршрут #{route.stations} создан"
    menu
  rescue RuntimeError, TypeError => e
    puts e.message
    retry
  end

  def invalid_number
    puts 'Некорректный номер'
  end

  def invalid_name
    puts 'Неккоретное имя'
  end

  def selected_train
    number = gets.chomp
    index = @trains.find_index { |train| train.number == number }
    index.nil? ? invalid_number && menu : @train = @trains[index]
  end

  def route_train
    if trains.empty?
      puts 'Сначала необходимо создать поезд'
    elsif stations.empty?
      puts 'Сначала необходимо создать станцию'
    else
      puts 'Какой поезд? (введите номер)'
      number = gets.chomp
      train = trains.detect { |train| train.number == number }
      if train
        puts 'На какую станцию? (название)'
        name = gets.chomp
        station = stations.detect { |station| station.station_name == name }
        puts 'Такой станции нет' if station.nil?
      else
        puts 'Поезда с таким номером нет'
      end
    end
    menu
  end

  def menu_carriage
    puts 'Выберите какой вагон вы хотите прицепить?'
    puts '1 - пассажирский'
    puts '2 - грузовой'
    input = gets.chomp.to_i

    case input
    when 1
      puts 'Для создания пассажирского вагона введите номер вагона'
      num = gets.chomp
      puts 'Для создания пассажирского вагона введите количество мест'
      seats = gets.chomp
      @carriage = PassengerCarriage.new(num, seats)
    when 2
      puts 'Для создания пассажирского вагона введите номер вагона'
      num = gets.chomp
      puts 'Для создания грузового вагона введите объем'
      capacity = gets.chomp
      @carriage = CargoCarriage.new(num, capacity)
    else puts 'Вы ввели неправильный тип вагона'
         menu
    end
  end

  def add_carriage
    menu_carriage
    puts 'Выберите поезд(по номеру) к которому хотите прицепить вагон:'
    selected_train.add_carriage(carriage)
    puts "К #{@train.number} прицеплен вагон #{carriage.class}
     кол-во вагонов - #{@train.carriages.size}"
    menu
  rescue RuntimeError, TypeError => e
    puts e.message
    retry
  end

  def unhook_carriage
    puts 'Выберите поезд(по номеру) от которого хотите отцепить вагон:'
    selected_train.remove_carriage
    puts "От поезда #{@train.number} отцеплен вагон типа #{@carriage.type}"
    puts "Кол-во вагонов - #{@train.carriages.size}"
    menu
  end

  def move_train
    puts 'Выберите в каком направлении хотите отправить поезд:'
    puts '1 - вперёд; 2 - назад'
    input = gets.chomp.to_i
    case input
    when 1
      puts 'Введите номер поезда, который хотите отправить вперед'
      selected_train.move_next
      puts "Поезд #{train.number}
       прибыл на станцию #{@train.current_station.name}"
      menu
    when 2
      puts 'Введите номер поезда, который хотите отправить назад'
      selected_train.move_previous
      puts "Поезд #{train.number}
       прибыл на станцию #{@train.current_station.name}"
      menu
    end
  end
end
