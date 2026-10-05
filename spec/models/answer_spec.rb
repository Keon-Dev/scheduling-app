require "rails_helper"

RSpec.describe Answer, type: :model do
  it { is_expected.to belong_to(:participant) }
  it { is_expected.to belong_to(:slot) }

  describe "DB制約" do
    it "同じ参加者は、同じ候補に二重に○を付けられない" do
      answer = create(:answer)
      expect { create(:answer, participant: answer.participant, slot: answer.slot) }
        .to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "別の参加者なら、同じ候補に○を付けられる" do
      answer = create(:answer)
      expect { create(:answer, slot: answer.slot) }.not_to raise_error
    end

    it "参加者を消すと、その回答も消える" do
      answer = create(:answer)
      answer.participant.delete
      expect(Answer.exists?(answer.id)).to be false
    end

    it "候補を消すと、その候補への回答も消える" do
      answer = create(:answer)
      answer.slot.delete
      expect(Answer.exists?(answer.id)).to be false
    end
  end
end
