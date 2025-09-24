
module Shareable
  extend ActiveSupport::Concern

  def build_share_links(session)
    msg = "I just slept #{(session.duration_sec.to_f/3600).round(1)} hours using GoodNightApp 😴🌙"
    url = "https://goodnight.example.com/users/#{session.user_id}/sessions/#{session.id}"
    {
      facebook: "https://www.facebook.com/sharer/sharer.php?u=#{CGI.escape(url)}",
      whatsapp: "https://wa.me/?text=#{CGI.escape(msg + ' ' + url)}",
      instagram: "https://www.instagram.com/?url=#{CGI.escape(url)}"
    }
  end
end
