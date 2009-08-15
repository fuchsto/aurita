
module Aurita

  module File_Helpers

    # Converts array(s) to platform independent file system path. 
    # Examples: 
    #
    #    fs_path(:foo, :bar, :batz) 
    # or
    #    fs_path(:foo, [:bar, :batz])
    # or
    #    fs_path([:foo, :bar, :batz])
    #
    # --> 'foo/bar/batz'  (on *nix)
    # --> 'foo\bar\batz'  (on win)
    #
    def fs_path(*args)
        File.join(args.flatten.map { |f| f.to_s })
    end

    # Returns true if file defined via path array exists, 
    # false otherwise. 
    def fs_exists(*path)
      File.exists?(fs_path(*path))
    end
    alias fs_exists? fs_exists

    # Expects hash with entries :from and :to, defining file source 
    # and destination paths as array. 
    #
    # Example: 
    #
    #   fs_copy(:from => [ :tmp, :cache ], 
    #           :to => [ :var, :www, :public ])
    #
    # This command is logged via Aurita.log { ... }
    def fs_copy(paths={})
      Aurita.log { "copy from #{fs_path(paths[:from])} to #{fs_path(paths[:to])}" }
      FileUtils.copy(fs_path(paths[:from]), 
                     fs_path(paths[:to]))
    end
    alias fs_cp fs_copy

    # Like fs_copy, but only log this operation, do not actually perform it on file system. 
    def fs_test_copy(paths={})
      Aurita.log { "copy from #{fs_path(paths[:from])} to #{fs_path(paths[:to])}" }
    end

    # Expects hash with entries :from and :to, defining file source 
    # and destination paths as array. 
    #
    # Example: 
    #
    #   fs_move(:from => [ :tmp, :cache ], 
    #           :to => [ :var, :www, :public ])
    #
    # This command is logged via Aurita.log { ... }
    def fs_move(paths={})
      FileUtils.move(fs_path(paths[:from]), 
                     fs_path(paths[:to]))
    end
    alias fs_mv fs_move

    # Creates directory in file system if not present already, 
    # returns false otherwise. 
    def fs_mkdir_if_missing(*path)
      if File.exists?(fs_path(*path)) then
        return false
      else 
        return FileUtils.mkdir(fs_path(*path)) 
      end
    end

    # Creates directory in file system. 
    # This command is logged via Aurita.log { ... }
    def fs_mkdir(*path)
      Aurita.log { "mkdir #{fs_path(path)}" }
      FileUtils.mkdir(fs_path(*path))
    end
    # Like fs_mkdir, but only log this operation, do not actually perform it on file system. 
    def fs_test_mkdir(*path)
      Aurita.log { "mkdir #{fs_path(path)}" }
    end

    # Returns filesize (in byte) of file given in path. 
    def fs_filesize(*path)
      File.size(fs_path(*path))
    end
    alias fs_size fs_filesize

    # Write object to file.  
    #
    #   content = 'Write this to a file'
    #   fs_write(:path, :to, :file) { content}
    #
    # This command is logged via Aurita.log { ... }
    def fs_write(*path, &block)
      Aurita.log { "Write to file #{fs_path(path)} (#{yield.to_s[0..72].gsub("\n", ' ')} ...)" } 
      File.open(fs_path(path), "w").write(yield)
    end

    # Like fs_write, but only log this operation, do not actually perform it on file system. 
    def fs_test_write(*path, &block)
      Aurita.log { "Write to file #{fs_path(path)} (#{yield.to_s[0..72].gsub("\n", ' ')} ...)" } 
    end

    def fs_delete(*path)
      FileUtils.rm(fs_path(*path))
    end

    def fs_delete_if_exists(*path)
      FileUtils.rm(fs_path(*path)) if fs_exists(*path)
    end

    def fs_delete_dir(*path)
      FileUtils.rm_rf(fs_path(*path))
    end
    
    def fs_delete_dir_if_exists(*path)
      FileUtils.rm_rf(fs_path(*path)) if fs_exists(*path)
    end

  end

end
