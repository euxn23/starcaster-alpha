class Tweet < ActiveRecord::Base
  has_one :favorite
  has_one :timeline

  has_many :media
  has_many :urls

  delegate :user, to: :favorite

  def user_image_bigger
    self.user_image.sub(/\.(jpeg|jpg|gif|png|bmp)/, '_bigger\&')
  end
end
