require 'open-uri'

class Url < ActiveRecord::Base
  belongs_to :tweet

  before_create :fetch_title

  def fetch_title
    html = open(self.url, allow_redirections: :all)
    self.title = Nokogiri::HTML(html).title
  end
end
