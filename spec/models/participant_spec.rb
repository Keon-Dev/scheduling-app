require "rails_helper"

RSpec.describe Participant, type: :model do
  it { is_expected.to belong_to(:event) }
  it { is_expected.to belong_to(:user).optional }
  it { is_expected.to have_many(:answers) }

  describe "DB制約" do
    it "name は必須" do
      expect { create(:participant, name: nil) }
        .to raise_error(ActiveRecord::NotNullViolation)
    end

    it "同じユーザーは同じイベントに二重に参加できない" do
      participant = create(:participant, user: create(:user))
      expect { create(:participant, event: participant.event, user: participant.user) }
        .to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "別のイベントなら、同じユーザーが参加できる" do
      participant = create(:participant, user: create(:user))
      expect { create(:participant, user: participant.user) }.not_to raise_error
    end

    it "ログインしていない参加者は、同じイベントに何人でもいられる" do
      event = create(:event)
      expect { create_list(:participant, 2, event: event, user: nil) }.not_to raise_error
    end

    it "イベントを消すと、参加者も消える" do
      participant = create(:participant)
      participant.event.delete
      expect(Participant.exists?(participant.id)).to be false
    end

    it "ユーザーが退会しても、参加者は残り、user_id だけ空になる" do
      participant = create(:participant, user: create(:user))
      participant.user.delete
      expect(participant.reload.user_id).to be_nil
    end
  end
end
