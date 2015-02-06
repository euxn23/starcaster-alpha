class Timeline < ActiveRecord::Base
  belongs_to :user
  has_one :tweet
end
