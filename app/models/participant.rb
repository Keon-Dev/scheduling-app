class Participant < ApplicationRecord
  belongs_to :event
  # optional: trueは、親データ（user）がnilでも保存を許可するということ
  belongs_to :user, optional: true
  has_many :answers
end
