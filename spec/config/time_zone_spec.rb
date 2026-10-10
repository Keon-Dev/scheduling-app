require "rails_helper"

RSpec.describe "時刻の設定" do
  it "アプリが扱う時刻は日本時間" do
    expect(Time.zone.name).to eq "Tokyo"
  end

  it "DB へは UTC で保存する設定になっている" do
    expect(ActiveRecord.default_timezone).to eq :utc
  end

  it "日本時間の朝9時は、DB の中では UTC の0時で入り、読み出すと日本時間に戻る" do
    slot = create(:slot,
                  start_at: Time.zone.local(2026, 10, 1, 9, 0),
                  end_at: Time.zone.local(2026, 10, 1, 10, 0))

    stored = Slot.where(id: slot.id).pick(Arel.sql("to_char(start_at, 'YYYY-MM-DD HH24:MI')"))

    expect(stored).to eq "2026-10-01 00:00"
    expect(slot.reload.start_at.zone).to eq "JST"
  end
end
