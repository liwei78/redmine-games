require 'open-uri'

class AppSnatcher
  # @@base_url = "http://itunes.apple.com/cn/app/id"
  # http://itunes.apple.com/cn/app/id477078317
  # @@base_url = "http://phobos.apple.com/WebObjects/MZStore.woa/wa/viewSoftware?id="

  def self.base_url
    @@base_url
  end
  # http://itunes.apple.com/cn/app/id411411466
  # AppSnatcher.snatch_detail(a, "411411466")
  # AppSnatcher.snatch_detail(a, "368940123")
  def self.snatch_detail(app, app_id="")
    raise "app_id can not be blank !" if app_id.blank?
    
    target_url = "http://itunes.apple.com/#{app.country}/app/id#{app_id}"
    agent = Mechanize.new
    agent.user_agent_alias = "Mac Safari"
    page = agent.get(target_url)
    
    desc = (page/"div.product-review > p").inner_html
    app.desc = desc
    
    remote_icon = (page/"div#left-stack > div")[0].at('img')["src"]
    app.photo_remote_url = remote_icon
  
    # 2012-1-13 liwei fix screenshots
    pics_div = (page/"div.iphone-screen-shots > div > div.lockup")
    unless pics_div.blank?
      app.screenshots.destroy_all
      for pic in pics_div
        # alts = pic.at('img')["alt"].split(' ') if pic.at('img')["alt"]
        Screenshot.create(:photo_remote_url => pic.at('img')["src"], :app_id => app.id) # if (alts and alts.include?("Screenshot"))
      end
    end
    
    app.save
  end

  
end
