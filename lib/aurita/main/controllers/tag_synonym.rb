
require('aurita/controller')

module Aurita
module Main

  class Tag_Synonym_Controller < App_Controller

    guard_interface(:perform_add, :perform_delete) { |c|
      Aurita.user.is_admin?
    }

		def toolbar_buttons
      edit_synonyms = HTML.a(:class => :icon, :onclick => js.Aurita.load(:action => 'Tag_Synonym/show/')) { 
        HTML.img(:src => '/aurita/images/icons/tags.gif') + tl(:edit_tags) 
      }
		end

    def perform_add
      Tag_Synonym.create(:tag => param(:tag), :synonym => param(:synonym))

      # Add transitivity: 
      Tag_Synonym.all_with(Tag_Synonym.synonym == param(:tag)).each { |ts|
        Tag_Synonym.create(:tag => param(:synonym), :synonym => ts.tag)
        # Add transitive bijectivity: 
        Tag_Synonym.create(:synonym => param(:synonym), :tag => ts.tag)
      }

      # Add bijectivity: 
      Tag_Synonym.create(:synonym => param(:tag), :tag => param(:synonym))

      # Register synonym if not known tag: 
      if !Tag_Relevance.find(1).with(Tag_Relevance.tag == param(:synonym)).entity then
        Tag_Relevance.create(:tag => param(:synonym), :hits => 0)
      end

      redirect_to(:action => :show, :tag => param(:tag), :target => :tag_form)
    end
    def perform_delete
      Tag_Synonym.delete { |s| s.where((s.tag == param(:tag)) & (s.synonym == param(:synonym))) }

      # Delete transitivity: 
      Tag_Synonym.all_with(Tag_Synonym.synonym == param(:tag)).each { |ts|
        Tag_Synonym.delete { |s| s.where((s.tag == param(:synonym)) & (s.synonym == ts.tag)) }
        # Delete transitive bijectivity: 
        Tag_Synonym.delete { |s| s.where((s.synonym == param(:synonym)) & (s.tag == ts.tag)) }
      }

      # Delete bijectivity: 
      Tag_Synonym.delete { |s| s.where((s.synonym == param(:tag)) & (s.tag == param(:synonym))) }

      redirect_to(:action => :show, :tag => param(:tag), :target => :tag_form)
      exec_js("Element.hide('synonym_#{param(:tag)}_#{param(:synonym)}');")
    end

    def list
      syns = Tag_Synonym.all_with(Tag_Synonym.tag == param(:tag)).entities
      HTML.div.form_box(:style => 'padding-top: 4px; padding-bottom: 0px; ') { 
        HTML.h2(:style => 'padding: 0px; ') { param(:tag).to_s } +
        HTML.ul { 
          syns.map { |s|
            HTML.li(:id => "synonym_#{s.tag}_#{s.synonym}") { 
              link_to(:target     => :dispatcher, 
                      :controller => 'Tag_Synonym', 
                      :action     => :perform_delete, 
                      :tag        => s.tag, 
                      :synonym => s.synonym) { 'X ' } + s.synonym }
          }
        }
      }
    end

    def list_all
      syns = Tag_Synonym.all.order_by(:tag).entities
      Page.new(:header => tl(:synonyms)) { 
        HTML.h2(:style => 'padding: 0px; ') { param(:tag).to_s } +
        HTML.ul { 
          syns.map { |s|
            HTML.li(:id => "synonym_#{s.tag}_#{s.synonym}") { 
              HTML.div(:style => 'width: 20px; float: left; ') { 
                link_to(:target => :dispatcher, :controller => 'Tag_Synonym', :action => :perform_delete, :tag => s.tag, :synonym => s.synonym) { 'X ' } 
              } + 
              HTML.div(:style => 'width: 140px; float: left; ') { 
                link_to(:action => :edit, :tag => s.tag) { 
                  s.tag 
                }
              }+
              HTML.div(:style => 'width: 140px; float: left; ') { s.synonym } + 
              HTML.div(:style => 'clear: both;')
            }
          }
        }
      }
    end

  	def show
		  form = add_form()
      form.add(GUI::Hidden_Field.new(:name => Tag_Synonym.tag.to_s, :value => param(:tag)))
      form.add(GUI::Input_Field.new(:name => Tag_Synonym.synonym, :label => tl(:add_synonym)))
      
      HTML.div { 
        list() + GUI::Async_Form_Decorator.new(form)
      }
		end

    # Undefine
    def perform_update
    end

    def edit
      exec_js("Aurita.Main.init_autocomplete_tag_selection(); ")

      Page.new(:header => tl(:edit_synonyms)) { 
        HTML.div.form_box {
          HTML.label { tl(:select_synonym_tag) } + 
          GUI::Tag_Autocomplete_Field.new(:name => :tag, :label => tl(:tag), :style => 'width: 329px; ') 
        } + 
        HTML.div(:id => :tag_form) { show() if param(:tag) } + 
        HTML.div { 
          link_to(:action => :list_all) { tl(:list_all_synonyms) }
        }
      }
    end

  end

end
end
