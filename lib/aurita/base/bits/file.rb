
class File

  def self.delete_if_exists(path)
    FileUtils.remove(path) if File.exists?(path)
  end

end

