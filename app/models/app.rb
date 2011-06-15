class App < ActiveRecord::Base

  set_table_name "games_apps"

  has_many :app_platforms
  has_many :platforms, :through => :app_platforms

  has_attached_file :icon,
    :styles => {:original => "120x120", :thumb => "57x57"},
    :url => "/:class/:attachment/:id/:style_:basename.:extension",
    :path => ":rails_root/public/:class/:attachment/:id/:style_:basename.:extension",
    :default_url => "/images/sample_icon.jpg"

  has_many :screenshots

  validates_presence_of :title
#  validates_presence_of :desc
  validates_presence_of :im

  def self.recommends(n=6)
    find(
      :all,
      :conditions => ["top = ?", true],
      :limit => n,
      :order => "updated_at desc")
  end

  def self.last_updated(n=12)
    find(
      :all,
      :conditions => ["top = ?", false],
      :limit => n,
      :order => "updated_at desc")
  end

  def in_platform?(pid)
    AppPlatform.find_by_app_id_and_platform_id(self.id, pid)
  end

  def platform_store_url(pid)
    record = AppPlatform.find_by_app_id_and_platform_id(self.id, pid)
    record.store_url if record
  end

  def update_platforms(platforms)
    snatch = false
    app_id = ""
    AppPlatform.destroy_all(:app_id => self.id) unless self.app_platforms.blank?
    for item in platforms.map{|p| p[1]}
      next if item["id"].nil?
      AppPlatform.create(
        :app_id => self.id,
        :platform_id => item["id"],
        :store_url => item["store_url"]
        )
      if item["snatch"] == "true"
        snatch = true
        app_id = item["store_url"]
      end
    end
    return snatch, app_id
  end

  attr_accessor :photo_remote_url
  before_validation :download_remote_image, :if => :image_url_provided?
  validates_presence_of :photo_remote_url, :if => :image_url_provided?, :message => '远程图片地址不能为空'

  private

  def image_url_provided?
    !self.photo_remote_url.blank?
  end

  def download_remote_image
    self.icon = do_download_remote_image
  end

  def do_download_remote_image
    io = open(URI.parse(photo_remote_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end

end
