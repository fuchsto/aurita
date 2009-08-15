
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
      cat_id = category.category_id if category.is_a?(Aurita::Model) 
      Content_Category.create(:content_id => content_id, 
                              :category_id => cat_id)
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
      Content_Category.update_for(self, category_ids)
    end
  end

end
end

