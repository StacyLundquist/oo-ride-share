require_relative 'test_helper'

describe "Passenger class" do

  describe "Passenger instantiation" do
    before do
      @passenger = RideShare::Passenger.new(id: 1, name: "Smithy", phone_number: "353-533-5334")
    end

    it "is an instance of Passenger" do
      expect(@passenger).must_be_kind_of RideShare::Passenger
    end

    it "throws an argument error with a bad ID value" do
      expect do
        RideShare::Passenger.new(id: 0, name: "Smithy")
      end.must_raise ArgumentError
    end

    it "sets trips to an empty array if not provided" do
      expect(@passenger.trips).must_be_kind_of Array
      expect(@passenger.trips.length).must_equal 0
    end

    it "is set up for specific attributes and data types" do
      [:id, :name, :phone_number, :trips].each do |prop|
        expect(@passenger).must_respond_to prop
      end

      expect(@passenger.id).must_be_kind_of Integer
      expect(@passenger.name).must_be_kind_of String
      expect(@passenger.phone_number).must_be_kind_of String
      expect(@passenger.trips).must_be_kind_of Array
    end
  end


  describe "trips property" do
    before do
      # TODO: you'll need to add a driver at some point here.
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        rating: 5,
        driver: RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE
        )
      )

      @passenger.add_trip(trip)
    end

    it "each item in array is a Trip instance" do
      @passenger.trips.each do |trip|
        expect(trip).must_be_kind_of RideShare::Trip
      end
    end

    it "all Trips must have the same passenger's passenger id" do
      @passenger.trips.each do |trip|
        expect(trip.passenger.id).must_equal 9
      end
    end
  end

  describe "net_expenditures" do

    # You add tests for the net_expenditures method
    it "return the total amount of money the passenger has spent" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 23.45,
        rating: 5,
        driver: RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE
      )
      )
      trip2 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 27.45,
        rating: 5,
        driver: RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE
        )
      )
      trip3 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.new(2016, 8, 8),
        end_time: Time.new(2016, 8, 9),
        cost: 13.45,
        rating: 5,
        driver: RideShare::Driver.new(
          id: 54,
          name: "Test Driver",
          vin: "12345678901234567",
          status: :AVAILABLE
        )
      )
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      @passenger.add_trip(trip3)

      expect(@passenger.net_expenditures).must_equal 64.35
    end

  end
  describe "total time spent" do
    before do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      trip1 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2018-11-04 12:00:00 -0800"),
        end_time: Time.parse("2018-11-04 12:00:30 -0800"),
        cost: 23.45,
        rating: 5,
        driver: RideShare::Driver.new(
          id: 54,
          name: "Stacy",
          vin: "12345678901234567",
          status: :AVAILABLE
        )
      )
      trip2 = RideShare::Trip.new(
        id: 8,
        passenger: @passenger,
        start_time: Time.parse("2018-11-04 12:00:00 -0800"),
        end_time: Time.parse("2018-11-04 12:00:45 -0800"),
        cost: 27.45,
        rating: 5,
        driver: RideShare::Driver.new(
          id: 54,
          name: "Ida",
          vin: "12345678901234567",
          status: :AVAILABLE
        )
      )
      # trip3 = RideShare::Trip.new(
      #   id: 8,
      #   passenger: @passenger,
      #   start_time: Time.new(2016, 8, 8),
      #   end_time: Time.new(2016, 8, 9),
      #   cost: 13.45,
      #   rating: 5
      # )
      @passenger.add_trip(trip1)
      @passenger.add_trip(trip2)
      # @passenger.add_trip(trip3)
    end

    it "total amount of time the passenger has spent on their trips" do


      expect(@passenger.total_time_spent).must_equal 75
    end

    it "must be a float" do
      expect(@passenger.total_time_spent).must_be_instance_of Float
    end
    it "Passenger has 0 trips" do
      @passenger = RideShare::Passenger.new(
        id: 9,
        name: "Merl Glover III",
        phone_number: "1-602-620-2330 x3723",
        trips: []
      )
      expect(@passenger.total_time_spent).must_equal 0
    end
  end
end
