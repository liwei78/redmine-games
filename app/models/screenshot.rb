class Screenshot < ActiveRecord::Base
  set_table_name "games_screenshots"
  belongs_to :app
  has_attached_file :file,
    :styles => { :original => "470>", :small => "120>" },
    :url => "/:class/:attachment/:id/:style_:basename.:extension",
    :path => ":rails_root/public/:class/:attachment/:id/:style_:basename.:extension"

  attr_accessor :photo_remote_url
  before_validation :download_remote_image, :if => :image_url_provided?
  validates_presence_of :photo_remote_url, :if => :image_url_provided?, :message => '远程图片地址不能为空'

  private

  def image_url_provided?
    !self.photo_remote_url.blank?
  end

  def download_remote_image
    self.file = do_download_remote_image
  end

  def do_download_remote_image
    io = open(URI.parse(photo_remote_url))
    def io.original_filename; base_uri.path.split('/').last; end
    io.original_filename.blank? ? nil : io
  rescue # catch url errors with validations instead of exceptions (Errno::ENOENT, OpenURI::HTTPError, etc...)
  end
end
