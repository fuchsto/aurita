
require('aurita/model')

Aurita::Main.import_model :category

module Aurita
module Main

  class Content_Category < Aurita::Model

    table :content_category, :public
    primary_key :content_id
    primary_key :category_id

    def self.after_create(instance)
      Category.touch(instance.category_id)
    end
    def self.after_delete(args)
      Category.touch(args[:category_id])
    end
    def self.after_update(instance)
      Category.touch(instance.category_id)
    end

  end

end
end

