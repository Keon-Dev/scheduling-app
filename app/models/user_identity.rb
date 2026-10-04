class UserIdentity < ApplicationRecord
  belongs_to :user

  enum :provider, { discord: 0, google: 1, slack: 2 }
end
