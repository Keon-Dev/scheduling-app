require "rails_helper"

RSpec.describe UserIdentity, type: :model do
  let(:user) { create(:user) }

  def row(**overrides)
    attributes_for(:user_identity, user_id: user.id, **overrides)
  end

  describe "データベースの制約" do
    it "同じ外部アカウントが、別々の2人のユーザーに繋がることを弾く" do
      other = create(:user)
      rows = [ row(uid: "u1"), row(uid: "u1", user_id: other.id) ]
      expect { UserIdentity.insert_all!(rows) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    [ :google, :discord ].each do |provider|
      it "同じユーザーが #{provider} を2つ接続することを弾く（workspace_id が空同士でも）" do
        rows = [ row(provider: provider, uid: "a1"), row(provider: provider, uid: "a2") ]
        expect { UserIdentity.insert_all!(rows) }.to raise_error(ActiveRecord::RecordNotUnique)
      end
    end

    it "同じユーザーが Slack を、別々のワークスペースで2つ接続することは許可" do
      rows = [
        row(provider: :slack, uid: "s1", workspace_id: "T1"),
        row(provider: :slack, uid: "s2", workspace_id: "T2")
      ]
      expect { UserIdentity.insert_all!(rows) }.not_to raise_error
    end

    it "同じユーザーが、同じワークスペースで Slack を2つ接続することを弾く" do
      rows = [
        row(provider: :slack, uid: "s1", workspace_id: "T1"),
        row(provider: :slack, uid: "s2", workspace_id: "T1")
      ]
      expect { UserIdentity.insert_all!(rows) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "user_identities.provider が空だと弾く" do
      expect { UserIdentity.insert_all!([ row(provider: nil) ]) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "user_identities.uid が空だと弾く" do
      expect { UserIdentity.insert_all!([ row(uid: nil) ]) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "存在しない users.id を指す接続を弾く" do
      expect { UserIdentity.insert_all!([ row(user_id: 0) ]) }.to raise_error(ActiveRecord::InvalidForeignKey)
    end

    it "users を消すと、そのユーザーの接続も一緒に消える" do
      UserIdentity.insert_all!([ row ])
      expect { User.where(id: user.id).delete_all }.to change { UserIdentity.count }.from(1).to(0)
    end
  end
end
