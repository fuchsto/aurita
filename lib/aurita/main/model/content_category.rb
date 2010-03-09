
require('aurita/model')

Aurita::Main.import_model :user_category

module Aurita
module Main

  class Content_Category < Aurita::Model

    table :content_category, :public
    primary_key :content_id
    primary_key :category_id


    # Set categories for given Content instance. 
    # Example: 
    #
    #   article = Article.load(:article_id => 23)
    #   Content_Category.update_for(article, 1,2,3)
    #
    # Also see Content.set_categories
    def self.create_for(content, *category_ids)
      return unless category_ids
      category_ids.flatten!
      category_ids.each { |cid| 
        create(:content_id => content.content_id, 
               :category_id => cid)
      }
    end

    # Set categories for given Content instance and 
    # flush existing category mappings for this content. 
    # Example: 
    #
    #   article = Article.load(:article_id => 23)
    #   p article.category_ids # --> [ 5, 9 ]
    #
    #   Content_Category.update_for(article, 1,2,3)
    #   p article.category_ids # --> [ 1, 2, 3 ]
    #
    # Also see Content.set_categories
    def self.update_for(content, *category_ids)
      category_ids.flatten!
      delete { |cc|
        cc.where(Content_Category.content_id == content.content_id)
      }
      create_for(content, category_ids)
    end

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

  class Content

    # Map this content to an additional category. 
    # Example: 
    #
    #   article  = Article.load(:article_id => 42)
    #   p article.category_ids # --> [ 5, 9 ]
    #
    #   category = Category.load(45))
    #   article.add_category(category)
    # Or 
    #   article.add_category(45)
    #
    #   p article.category_ids # --> [ 5, 9, 45 ]
    #
    def add_category(category)
      cat_id = category
      cat_id = category.category_id if category.kind_of?(Aurita::Model) 
      mapping = Content_Category.create(:content_id  => content_id, 
                                        :category_id => cat_id)

      if mapping then
        @category_ids ||= []
        @category_ids << mapping.category_id 
      end
      mapping
    end

    # Set categories for this Content instance, replacing its
    # current category mapping. 
    # Example: 
    #
    #   article = Article.load(:article_id => 42)
    #   p article.category_ids # --> [ 5, 9 ]
    #
    #   article.set_categories(1,2,3)
    #   p article.category_ids # --> [ 1, 2, 3 ]
    #
    def set_categories(*category_ids)
      @category_ids = category_ids
      Content_Category.update_for(self, category_ids)
    end

    # Returns array of Category instances mapped to this content, or 
    # category with id 1 (no category). 
    def categories
      return @categories if @categories

      @categories = Category.select { |cc| 
        cc.join(Content_Category).using(:category_id) { |c| 
          c.where(c.content_id == content_id) 
        } 
      }.to_a
      @categories = [ Category.load(:category_id => 1) ] unless @categories
      @categories
    end

    # Returns first category of this Content instance, or 
    # category with id 1 (no category). 
    def category
      @category ||= Category.select { |cc| 
        cc.join(Content_Category).using(:category_id) { |c| 
          c.where(c.content_id == content_id) 
          c.limit(1)
        } 
      }.first
      @category ||= Category.load(:category_id => 1) unless @category
      return @category
    end

    # Returns category ids mapped to this Content instance via Content_Category 
    # as Array. 
    def category_ids
      return @category_ids if @category_ids 

      @category_ids = Content_Category.select_values(:category_id) { |cc| 
        cc.where(cc.content_id == content_id) 
      }.to_a.flatten.map { |cid| cid.to_i }
      @category_ids = [1] unless @category_ids
      @category_ids
    end

    # Returns first category id mapped to this Content instance. 
    def category_id
      return category.category_id if category
      1
    end
  end

end
end

