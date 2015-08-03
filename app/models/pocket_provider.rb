# == Schema Information
#
# Table name: providers
#
#  id                :integer          not null, primary key
#  beeminder_user_id :string           not null
#  name              :string           not null
#  uid               :string           default(""), not null
#  info              :json             default({}), not null
#  credentials       :json             default({}), not null
#  extra             :json             default({}), not null
#  created_at        :datetime
#  updated_at        :datetime
#

class PocketProvider < Provider
  validate :valid_access_token

  def self.sti_name
    "pocket".freeze
  end

  def oauthable?
    true
  end

  def deltable?
    false
  end

  def client
    Pocket.client access_token: access_token
  end

  def articles
    client.retrieve(contentType: "article").fetch("list").values
  end

  def calculate_score(_options = {})
    # couldn't find documentation for pocket's article time_added field
    # it seems to be stored as utc epoch

    now_as_epoch = Time.current.utc.to_i
    value = articles.map do |article|
      now_as_epoch - article["time_added"].to_i
    end.sum / 1.day.to_i

    {
      Time.current.utc => value
    }
  end
end
