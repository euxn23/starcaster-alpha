class User < ActiveRecord::Base
  devise :omniauthable
  has_many :favoritec
  has_many :timeline


  def image_bigger
    self.image.sub(/\.(jpeg|jpg|gif|png|bmp)/, '_bigger\&')
  end
end
