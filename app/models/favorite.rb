class Favorite < ActiveRecord::Base
  belongs_to :user
  belongs_to :tweet

  delegate to: :tweet
end
