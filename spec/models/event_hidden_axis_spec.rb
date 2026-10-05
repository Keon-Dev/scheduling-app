require "rails_helper"

RSpec.describe EventHiddenAxis, type: :model do
  it { is_expected.to belong_to(:event) }
  it { is_expected.to define_enum_for(:axis_kind).with_values(date: 0, time_band: 1) }

  describe "DB制約" do
    it "axis_kind は必須" do
      expect { create(:event_hidden_axis, axis_kind: nil) }
        .to raise_error(ActiveRecord::NotNullViolation)
    end

    it "同じイベントの同じ日付は二重に隠せない" do
      hidden = create(:event_hidden_axis)
      expect { create(:event_hidden_axis, event: hidden.event, hidden_date: hidden.hidden_date) }
        .to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "別のイベントなら同じ日付を隠せる" do
      hidden = create(:event_hidden_axis)
      expect { create(:event_hidden_axis, hidden_date: hidden.hidden_date) }
        .not_to raise_error
    end

    it "同じイベントの同じ時間帯は二重に隠せない" do
      hidden = create(:event_hidden_axis, :time_band)
      expect {
        create(:event_hidden_axis, :time_band, event: hidden.event,
               hidden_start_time: hidden.hidden_start_time,
               hidden_end_time: hidden.hidden_end_time)
      }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "開始が同じでも終了が違えば、別の時間帯として隠せる" do
      hidden = create(:event_hidden_axis, :time_band)
      expect {
        create(:event_hidden_axis, :time_band, event: hidden.event,
               hidden_start_time: hidden.hidden_start_time,
               hidden_end_time: "23:45")
      }.not_to raise_error
    end

    it "イベントを消すと、非表示の記録も消える" do
      hidden = create(:event_hidden_axis)
      hidden.event.delete
      expect(EventHiddenAxis.exists?(hidden.id)).to be false
    end
  end
end
