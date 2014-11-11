require 'test_helper'

def test_invalid(timestamp, diff, message)
  new_reservation = Reservation.create(start_time: timestamp,
                                       end_time: timestamp + diff,
                                       table: 1)
  assert new_reservation.invalid?, message
end

class ReservationTest < ActiveSupport::TestCase
  test 'reservation valid' do
    timestamp = DateTime.new(2014, 11, 7, 6, 0, 0)
    new_reservation = Reservation.create(start_time: timestamp,
                                         end_time: timestamp + 2.hours,
                                         table: 1)
    assert new_reservation.valid?
  end

  test 'reservation invalid: double reservation' do
    test_invalid(DateTime.new(2014, 11, 7, 17, 30, 0), 2.hours,
                 'Timestamp left overlap')
    test_invalid(DateTime.new(2014, 11, 7, 19, 0, 0), 1.hours,
                 'Timestamp middle overlap')
    test_invalid(DateTime.new(2014, 11, 7, 20, 0, 0), 2.hours,
                 'Timestamp right overlap')
    test_invalid(DateTime.new(2014, 11, 7, 17, 30, 0), 1.hours,
                 'Timestamp right boundary')
    test_invalid(DateTime.new(2014, 11, 7, 20, 30, 0), 1.hours,
                 'Timestamp left boundary')
    test_invalid(DateTime.new(2014, 11, 7, 18, 30, 0), 2.hours,
                 'Timestamp like record in database')
  end
end
