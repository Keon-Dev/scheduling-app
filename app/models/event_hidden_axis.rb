class EventHiddenAxis < ApplicationRecord
  belongs_to :event

  enum :axis_kind, { date: 0, time_band: 1 }
end
