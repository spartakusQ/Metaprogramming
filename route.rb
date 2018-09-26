# class for route control stations
class Route
  include Validate
  attr_reader :stations, :from, :to

  def initialize(from, to)
    @stations = [from, to]
    validate!
  end

  def add_station(station)
    stations.insert(-2, station)
    puts "К маршруту #{stations.first.station_name}
     - #{stations.last.station_name} добавлена станция #{station.station_name}"
  end

  def remove_station(station)
    if [stations.first, stations.last].include?(station)
      puts 'Первую и последнюю станции маршрута удалять нельзя!'
    else
      stations.delete(station)
      puts "Из маршрутного листа #{stations.first.station_name}
       - #{stations.last.station_name} удалена станция #{station.station_name}"
    end
  end

  def show_stations
    puts "В маршрутный лист #{stations.first.station_name}
     - #{stations.last.station_name} входят станции с именами: "
    stations.each { |station| puts " #{station.station_name}" }
  end

  protected

  def validate!
    raise 'Станция не была выбрана.' unless @stations.first && @stations.last
  end
end
