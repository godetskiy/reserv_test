class Reservation < ActiveRecord::Base
  validates_presence_of :start_time, :end_time, :table

  validate :double_reservation?, on: [:create, :update]

  def overlaps?(reserv)
    (start_time - reserv.end_time) * (reserv.start_time - end_time) >= 0
  end

  private

  def double_reservation?
    Reservation.where(table: self.table).where.not(id: self.id).each do |reserv|
      if reserv.overlaps?(self)
        errors.add(:date, 'Sorry, this table is already reserved at this time')
      end
    end
  end
end
