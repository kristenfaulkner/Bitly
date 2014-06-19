require 'securerandom'

class ShortenedUrl < ActiveRecord::Base
  validates :long_url, uniqueness: true
  
  belongs_to(
    :submitter,
    :class_name  => "User",
    :foreign_key => :submitter_id,
    :primary_key => :id
  )
  
  has_many(
    :visits, 
    :class_name => "Visit",
    :foreign_key => :short_url_id,
    :primary_key => :id
  )
  
  has_many(
    :visitors, ->{ distinct },
    :source => :user,
    :through => :visits
  )
  
  def num_clicks
    visits.count
  end
  
  def num_uniques
    visitors.count
  end
  
  def self.create_for_user_and_long_url!(user, long_url)
    ShortenedUrl.create!(
      long_url:  long_url, 
      short_url: random_code, 
      submitter_id: user.id
    )
  end
  
  def self.random_code
    code = SecureRandom.base64
    while self.exists?(:short_url => code)
      code = SecureRandom.base64
    end
    code
  end
end