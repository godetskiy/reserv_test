json.array!(@reservations) do |reservation|
  json.extract! reservation, :id, :start_time, :end_time, :table
  json.url reservation_url(reservation, format: :json)
end
