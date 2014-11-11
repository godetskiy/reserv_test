require 'rails_helper'

RSpec.describe Reservation, :type => :model do
  def test_invalid(timestamp, diff)
    new_reservation = Reservation.create(start_time: timestamp,
                                         end_time: timestamp + diff,
                                         table: 1)
    expect(new_reservation).not_to be_valid
  end

  it 'should be valid' do
    timestamp = DateTime.new(2014, 11, 7, 6, 0, 0)
    new_reservation = Reservation.create(start_time: timestamp,
                                         end_time: timestamp + 2.hours,
                                         table: 1)
    expect(new_reservation).to be_valid
  end

  it 'should not overlapping in left part' do
    test_invalid(DateTime.new(2014, 11, 7, 17, 30, 0), 2.hours)
  end

  it 'should not be in reserved time range' do
    test_invalid(DateTime.new(2014, 11, 7, 19, 0, 0), 1.hours)
  end

  it 'should not overlapping in right part' do
    test_invalid(DateTime.new(2014, 11, 7, 20, 0, 0), 2.hours)
  end

  it 'should overlaps in right boundary' do
    test_invalid(DateTime.new(2014, 11, 7, 17, 30, 0), 1.hours)
  end

  it 'should not overlaps in left boundary' do
    test_invalid(DateTime.new(2014, 11, 7, 20, 30, 0), 1.hours)
  end

  it 'should not overlaps exactly' do
    test_invalid(DateTime.new(2014, 11, 7, 18, 30, 0), 2.hours)
  end
end
