helpers do
  include Rack::Utils
  alias_method :h, :escape_html

  def time_ago(time)
    if (time != nil)
      capture_haml do
        haml_tag :abbr, :class => "timeago", :title=>time.iso8601
      end
    end
  end

  def vote_answer(answer)
    capture_haml do
      haml_tag :div, :class=>"clickable", :onclick=>"a_vote("+answer.id.to_s+",'up')" do
        haml_concat "&#9650;"
      end
      haml_tag :div, :id=>"a_votes"+answer.id.to_s do
        haml_concat answer.votes.length
      end
      haml_tag :div, :class=>"clickable", :onclick=>"a_vote("+answer.id.to_s+",'down')" do
        haml_concat "&#9660;"
      end
    end
  end

  def vote_question(question)
    capture_haml do
      haml_tag :div, :class=>"clickable", :onclick=>"q_vote("+question.id.to_s+",'up')" do
        haml_concat "&#9650;"
      end
      haml_tag :div, :id=>"q_votes"+question.id.to_s do
        haml_concat question.votes.length
      end
      haml_tag :div, :class=>"clickable", :onclick=>"q_vote("+question.id.to_s+",'down')" do
        haml_concat "&#9660;"
      end
    end
  end

  def display_readonly_tags(tags)
    capture_haml do
      tags.each do |tag|
        haml_tag :span,  :class => "tagit-choice ui-widget-content ui-state-default ui-corner-all tagit-choice-read-only mtag"  do
          haml_concat tag.name
        end
      end
    end
  end

  def display_readonly_tags_vertical(tags)
    capture_haml do
      tags.each do |tag|
        haml_tag :span,  :class => "tagit-choice ui-widget-content ui-state-default ui-corner-all tagit-choice-read-only mtag"  do
          haml_concat tag.name
        end
        haml_tag :br
      end
    end
  end

  def display_popular_tags(tags)
    capture_haml do
      tags.each do |tag|
        haml_tag :span,  :class => "tagit-choice ui-widget-content ui-state-default ui-corner-all tagit-choice-read-only mtag"  do
          haml_concat tag.name
        end
        haml_concat "x "+tag.number.to_s
        haml_tag :br
      end
    end
  end

  def show_accept_symbol(question, answer)
    capture_haml do
      if (question.correct == nil)
        haml_tag :span, :class => "acceptable clickable", :onclick=>"accept_answer("+question.id.to_s+","+answer.id.to_s+")" do
          haml_concat "&#10004;"
        end
      elsif (question.correct == answer)
        haml_tag :span, :class => "accepted clickable" do
          haml_concat "&#10004;"
        end
      end
    end
  end


  def display_markup(text)
    capture_haml do
      haml_tag :input, :type=>"hidden", :class=>"markup", :value=>text
    end
  end

  def escape_title(title)
    return CGI::escape(title.gsub(/\ /,'-').downcase)
  end


  def navigation_button(name,link)
     capture_haml do
       haml_tag :button, :class=>"navigation-button", :onclick=>"navigate('#{link}')" do
          haml_concat name
       end
     end
  end

  def display_action_button(name, action)
     capture_haml do
       haml_tag :span, :class=>"action_text clickable", :onclick=>action do
          haml_concat name
       end
     end
  end

  def create_question_show_url(id)
    question = Question.get(id);
    return '/show/question/'+question.id.to_s+"/"+escape_title(question.title);
  end
  
  def render_component(component, locals)
    contents = File.read("views/components/"+component.to_s+".haml");
    Haml::Engine.new(contents).render(self, locals);
  end
  
  def field_validation(target, field)
    if (target != nil && target.errors[field].length > 0)
      capture_haml do
        haml_tag :p, :class => "error" do
          haml_concat target.errors[field][0]
        end
      end
    end
  end

  def base_url
    if request.env['HTTP_X_FORWARDED_HOST'] != nil
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_X_FORWARDED_HOST']}"
    else 
      @base_url ||= "#{request.env['rack.url_scheme']}://#{request.env['HTTP_HOST']}"  
    end
  end

end