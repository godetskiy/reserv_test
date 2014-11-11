class Reservation < ActiveRecord::Base
  validates_presence_of :start_time, :end_time, :table

  validate :double_reservation?, on: [:create, :update]

  scope :overlap, lambda { |new_reservation|
    where(table: new_reservation.table)
      .where.not(id: new_reservation.id)
      .where('(start_time <= ?) AND (? <= end_time)',
             new_reservation.end_time,
             new_reservation.start_time)
  }

  private

  def double_reservation?
    res = Reservation.overlap(self).empty?
    errors.add(:date,
               'Sorry, this table is already reserved at this time') unless res
  end
end
