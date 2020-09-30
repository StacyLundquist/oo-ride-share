require 'csv'
require 'time'

require_relative 'csv_record'

module RideShare
  class Trip < CsvRecord
    attr_reader :id, :passenger, :passenger_id, :start_time, :end_time, :cost, :rating, :driver, :driver_id

    def initialize(
        id:,
        passenger: nil,
        passenger_id: nil,
        start_time:,
        end_time:,
        cost: nil,
        rating:,
        driver: nil,
        driver_id: nil
    )
      super(id)

      if passenger
        @passenger = passenger
        @passenger_id = passenger.id

      elsif passenger_id
        @passenger_id = passenger_id

      else
        raise ArgumentError, 'Passenger or passenger_id is required'
      end

      @start_time = start_time
      @end_time = end_time
      raise ArgumentError, 'Start time must be before end time.' if @end_time < @start_time

      @cost = cost
      @rating = rating

      if @rating > 5 || @rating < 1
        raise ArgumentError.new("Invalid rating #{@rating}")
      end

      if driver
        @driver = driver
        @driver_id = driver.id
      elsif driver_id
        @driver_id = driver_id
      else
        raise ArgumentError.new("Driver information needed.")
      end


    end

    def inspect
      # Prevent infinite loop when puts-ing a Trip
      # trip contains a passenger contains a trip contains a passenger...
      "#<#{self.class.name}:0x#{self.object_id.to_s(16)} " +
          "id=#{id.inspect} " +
          "passenger_id=#{passenger&.id.inspect} " +
          "start_time=#{start_time} " +
          "end_time=#{end_time} " +
          "cost=#{cost} " +
          "rating=#{rating}>"
    end

    def connect(passenger)
      @passenger = passenger
      passenger.add_trip
    end

    def duration

      total = (@end_time - @start_time)
      #TimeDifference.between(@start_time, @end_time).in_seconds

      return total
    end

    private

    def self.from_csv(record)
      return self.new(
          id: record[:id],
          passenger_id: record[:passenger_id],
          start_time: Time.parse(record[:start_time]),
          end_time: Time.parse(record[:end_time]),
          cost: record[:cost],
          rating: record[:rating]
      )
    end
  end
end

