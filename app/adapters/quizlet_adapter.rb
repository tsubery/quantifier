require "quizlet/client"
class QuizletAdapter < BaseAdapter
  class << self
    def required_keys
      %i(token uid)
    end

    def auth_type
      :oauth
    end

    def website_link
      "https://quizlet.com"
    end

    def title
      "Quizlet"
    end
  end

  def client
    Quizlet::Client.new access_token: access_token
  end

  def statistics
    client.get("users/#{uid}", {}).fetch("statistics")
  end

  def session_count
    statistics.fetch("study_session_count")
  end

  def answer_count
    statistics.fetch("total_answer_count")
  end
end
