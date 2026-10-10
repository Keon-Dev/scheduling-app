class Event < ApplicationRecord
  has_secure_token :public_token

  has_many :slots
  belongs_to :owner_user, class_name: "User", optional: true
  belongs_to :confirmed_slot, class_name: "Slot", optional: true

  enum :granularity, { date: 0, time: 1 }

  validate :confirmed_slot_must_belong_to_event
  validate :editable_by_anyone_requires_owner
  validate :confirmed_start_at_must_match_slot_date

  private

  # 意図6 第二層：他のイベントの候補を、確定した候補にできない
  def confirmed_slot_must_belong_to_event
    return if confirmed_slot.nil?

    errors.add(:confirmed_slot, "はこのイベントの候補ではありません") unless confirmed_slot.event_id == id
  end

  # 意図12：作成者がいないイベントを、作成者のみ編集可にはできない
  def editable_by_anyone_requires_owner
    return if owner_user_id.present? || editable_by_anyone == true

    errors.add(:editable_by_anyone, "は作成者がいないイベントでは false にできません")
  end

  # 意図16：開始日時の日付（日本時間）は、選ばれた候補の日付と一致する
  def confirmed_start_at_must_match_slot_date
    return if confirmed_start_at.nil? || confirmed_slot.nil?

    event_date = confirmed_start_at.in_time_zone("Tokyo").to_date
    slot_date = confirmed_slot.start_at.in_time_zone("Tokyo").to_date
    errors.add(:confirmed_start_at, "は選ばれた候補と同じ日でなければなりません") if event_date != slot_date
  end
end
