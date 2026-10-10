require "rails_helper"

RSpec.describe User, type: :model do
  describe "データベースの制約" do
    it "同じ users.email を2行入れると、データベースが弾く" do
      row = attributes_for(:user)
      expect { User.insert_all!([ row, row ]) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "users.email が空だと、データベースが弾く" do
      expect { User.insert_all!([ attributes_for(:user, email: nil) ]) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "users.name が空だと、データベースが弾く" do
      expect { User.insert_all!([ attributes_for(:user, name: nil) ]) }.to raise_error(ActiveRecord::NotNullViolation)
    end

    it "同じ users.stripe_customer_id を2行入れると、データベースが弾く" do
      rows = Array.new(2) { attributes_for(:user, stripe_customer_id: "cus_1") }
      expect { User.insert_all!(rows) }.to raise_error(ActiveRecord::RecordNotUnique)
    end

    it "users.stripe_customer_id が空の行は、何行でも入る" do
      rows = Array.new(2) { attributes_for(:user) }
      expect { User.insert_all!(rows) }.not_to raise_error
    end
  end
end
