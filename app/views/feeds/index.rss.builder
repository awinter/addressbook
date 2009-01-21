xml.instruct! :xml, :version => "1.0" 
xml.rss :version => "2.0" do
  xml.channel do
    xml.title "Address Change Notification System"
    xml.description "Lists the recent address changes"
    xml.link feed_url
    
    for change in @changes
      xml.item do
        xml.title "#{change.address.user.full_name} has moved to #{change.address.full_address}"
        xml.pubDate change.created_at.to_s(:rfc822)
      end
    end
  end
end