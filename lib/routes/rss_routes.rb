get '/rss.xml/?:lastid?' do
  if (params[:lastid] != nil)
    questions = Question.all(:order => [ :creation.desc], :id.gt => params[:lastid])
  else
    questions = Question.all(:order => [ :creation.desc ])
  end
  builder do |xml|
    xml.instruct! :xml, :version => '1.0'
    xml.rss :version => "2.0" do
      xml.channel do
        xml.title "QA Site"
        xml.description "LH Systems Q&A RSS Aggregate"
        xml.link base_url

        questions.each do |question|
          xml.item do
            xml.title question.title
            xml.link base_url+create_question_show_url(question.id);
            xml.description question.tags.collect{|tag| tag.name}.join(', ')
            xml.pubDate question.creation.rfc822()
            xml.author question.id
          end
        end
      end
    end
  end
end