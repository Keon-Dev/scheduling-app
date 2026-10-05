require "rails_helper"

RSpec.describe Event, type: :model do
  describe "データベースの制約" do
    it "同じ events.public_token を2行入れると弾く" do
      rows = [ attributes_for(:event, public_token: "t1"), attributes_for(:event, public_token: "t1") ]
      expect { Event.insert_all!(rows) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "events.public_token が空だと弾く" do
      expect { Event.insert_all!([ attributes_for(:event, public_token: nil) ]) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "events.title が空だと弾く" do
      expect { Event.insert_all!([ attributes_for(:event, title: nil) ]) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "events.granularity を省くと、date（日付のみ）になる" do
      Event.insert_all!([ attributes_for(:event).except(:granularity) ])
      expect(Event.last).to be_date
    end

    it "events.editable_by_anyone を省くと、true になる" do
      Event.insert_all!([ attributes_for(:event).except(:editable_by_anyone) ])
      expect(Event.last.editable_by_anyone).to be true
    end

    it "存在しない users.id を作成者にした events を弾く" do
      expect { Event.insert_all!([ attributes_for(:event, owner_user_id: 0) ]) }.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it "作成者が users から消えても events は残り、作成者が空になる" do
      user = create(:user)
      Event.insert_all!([ attributes_for(:event, public_token: "t1", owner_user_id: user.id) ])
      User.where(id: user.id).delete_all
      expect(Event.find_by!(public_token: "t1").owner_user_id).to be_nil
    end

    it "存在しない slots.id を確定した候補にした events を弾く" do
      expect { Event.insert_all!([ attributes_for(:event, confirmed_slot_id: 0) ]) }.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it "確定した候補が slots から消えると、events は未確定に戻る" do
      event = create(:event)
      slot = create(:slot, event: event)
      Event.where(id: event.id).update_all(confirmed_slot_id: slot.id)
      Slot.where(id: slot.id).delete_all
      expect(event.reload.confirmed_slot_id).to be_nil
    end
  end

  describe "検証" do
    it "events.public_token は作成時に自動で付く" do
      expect(Event.create!(title: "新歓").public_token).to be_present
    end

    describe "確定した候補" do
      let(:event) { create(:event) }

      it "このイベントの候補なら通る" do
        event.confirmed_slot = create(:slot, event: event)
        expect(event).to be_valid
      end

      it "別のイベントの候補は弾く" do
        event.confirmed_slot = create(:slot)
        expect(event).not_to be_valid
      end
    end

    describe "作成者と editable_by_anyone の組み合わせ" do
      it "作成者がいないのに editable_by_anyone が false は弾く" do
        expect(build(:event, owner_user: nil, editable_by_anyone: false)).not_to be_valid
      end

      it "作成者がいれば editable_by_anyone が false でも通る" do
        expect(build(:event, owner_user: create(:user), editable_by_anyone: false)).to be_valid
      end

      it "作成者がいなくても editable_by_anyone が true なら通る" do
        expect(build(:event, owner_user: nil, editable_by_anyone: true)).to be_valid
      end
    end

    describe "開始日時" do
      let(:event) { create(:event) }
      let(:slot) { create(:slot, event: event, start_at: Time.zone.local(2026, 6, 25)) }

      before { event.confirmed_slot = slot }

      it "選ばれた候補と同じ日（日本時間）なら通る" do
        event.confirmed_start_at = Time.zone.local(2026, 6, 25, 19, 0)
        expect(event).to be_valid
      end

      it "日本時間の0時台でも、同じ日なら通る（UTC では前日になる時刻）" do
        event.confirmed_start_at = Time.zone.local(2026, 6, 25, 0, 30)
        expect(event).to be_valid
      end

      it "別の日なら弾く" do
        event.confirmed_start_at = Time.zone.local(2026, 6, 26, 19, 0)
        expect(event).not_to be_valid
      end
    end
  end
end
