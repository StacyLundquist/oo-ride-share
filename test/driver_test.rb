require_relative 'test_helper'

describe "Driver class" do
  before do "Passenger"
  @passenger = RideShare::Passenger.new(
      id: 9,
      name: "Merl Glover III",
      phone_number: "1-602-620-2330 x3723",
      trips: []
  )
  @driver = RideShare::Driver.new(
      id: 54,
      name: "Test Driver",
      vin: "12345678901234567",
      status: :AVAILABLE
  )
  @trip1 = RideShare::Trip.new(
      id: 8,
      passenger: @passenger,
      start_time: Time.parse("2018-11-04 12:00:00 -0800"),
      end_time: Time.parse("2018-11-04 12:00:30 -0800"),
      cost: 23.45,
      rating: 5,
      driver: @driver
  )
  @trip2 = RideShare::Trip.new(
      id: 8,
      passenger: @passenger,
      start_time: Time.parse("2018-11-04 12:00:00 -0800"),
      end_time: Time.parse("2018-11-04 12:00:45 -0800"),
      cost: 27.45,
      rating: 5,
      driver: @driver
  )
  @trip3 = RideShare::Trip.new(
      id: 8,
      passenger_id: 1,
      start_time: Time.parse("2018-11-04 12:00:00 -0800"),
      end_time: nil,
      cost: nil,
      rating: nil,
      driver: @driver
  )
  end
  describe "Driver instantiation" do

    it "is an instance of Driver" do
      expect(@driver).must_be_kind_of RideShare::Driver
    end

    it "throws an argument error with a bad ID" do
      expect { RideShare::Driver.new(id: 0, name: "George", vin: "33133313331333133") }.must_raise ArgumentError
    end

    it "throws an argument error with a bad VIN value" do
      expect { RideShare::Driver.new(id: 100, name: "George", vin: "") }.must_raise ArgumentError
      expect { RideShare::Driver.new(id: 100, name: "George", vin: "33133313331333133extranums") }.must_raise ArgumentError
    end

    it "has a default status of :AVAILABLE" do
      expect(RideShare::Driver.new(id: 100, name: "George", vin: "12345678901234567").status).must_equal :AVAILABLE
    end

    it "sets driven trips to an empty array if not provided" do
      expect(@driver.trips).must_be_kind_of Array
      expect(@driver.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :vin, :status, :trips].each do |prop|
        expect(@driver).must_respond_to prop
      end

      expect(@driver.id).must_be_kind_of Integer
      expect(@driver.name).must_be_kind_of String
      expect(@driver.vin).must_be_kind_of String
      expect(@driver.status).must_be_kind_of Symbol
    end
  end

  describe "add_trip method" do
    before do
      @trip = RideShare::Trip.new(
        id: 8,
        driver: @driver,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2018, 8, 9),
        rating: 5
      )
    end

    it "adds the trip" do
      expect(@driver.trips).wont_include @trip
      previous = @driver.trips.length

      @driver.add_trip(@trip)

      expect(@driver.trips).must_include @trip
      expect(@driver.trips.length).must_equal previous + 1
    end
  end

  describe "average_rating method" do
    before do
      @driver.add_trip(@trip1)
    end

    it "Ignores an in progress trip" do
      @driver.add_trip(@trip3)
      expect(@driver.average_rating).must_be_close_to 5
    end

    it "returns a float" do
      expect(@driver.average_rating).must_be_kind_of Float
    end

    it "returns a float within range of 1.0 to 5.0" do
      average = @driver.average_rating
      expect(average).must_be :>=, 1.0
      expect(average).must_be :<=, 5.0
    end

    it "returns zero if no driven trips" do
      driver = RideShare::Driver.new(
        id: 54,
        name: "Rogers Bartell IV",
        vin: "1C9EVBRM0YBC564DZ"
      )
      expect(driver.average_rating).must_equal 0
    end

    it "correctly calculates the average rating" do
      @driver.add_trip(@trip2)

      expect(@driver.average_rating).must_be_close_to (5.0 + 5.0) / 2.0, 0.01
    end

  end

  describe "total_revenue" do

    it 'returns 0 for no trips taken' do
      expect(@driver.total_revenue).must_equal 0
    end

    it 'returns the sum of one trip' do
      @driver.add_trip(@trip1)

      expect(@driver.total_revenue).must_be_close_to 17.44
    end

    it 'returns the sum of many trips' do
      @driver.add_trip(@trip1)
      @driver.add_trip(@trip2)
      expect(@driver.total_revenue).must_be_close_to 38.08
    end

    it "Ignores an in progress trip" do
      @driver.add_trip(@trip3)
      expect(@driver.total_revenue).must_equal 0
    end
  end
end
