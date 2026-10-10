require "rails_helper"

RSpec.describe Slot, type: :model do
  let(:event) { create(:event) }

  def row(**overrides)
    attributes_for(:slot, event_id: event.id, **overrides)
  end

  describe "データベースの制約" do
    it "同じイベントに、同じ開始時刻の候補を2つ入れると弾く" do
      start_at = Time.zone.local(2026, 6, 25)
      rows = Array.new(2) { row(start_at: start_at) }
      expect { Slot.insert_all!(rows) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "別のイベントなら、同じ開始時刻の候補を入れられる" do
      start_at = Time.zone.local(2026, 6, 25)
      rows = [ row(start_at: start_at), row(start_at: start_at, event_id: create(:event).id) ]
      expect { Slot.insert_all!(rows) }.not_to raise_error
    end

    it "slots.start_at が空だと弾く" do
      expect { Slot.insert_all!([ row(start_at: nil, end_at: Time.zone.local(2026, 6, 26)) ]) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "slots.end_at が空だと弾く" do
      expect { Slot.insert_all!([ row(end_at: nil) ]) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "存在しない events.id を指す候補を弾く" do
      expect { Slot.insert_all!([ row(event_id: 0) ]) }.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it "events を消すと、そのイベントの候補も一緒に消える" do
      Slot.insert_all!([ row ])
      expect { Event.where(id: event.id).delete_all }.to change { Slot.count }.from(1).to(0)
    end
  end
end
