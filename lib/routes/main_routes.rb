get '/' do
  haml :list, :locals => {:questions => Question.all(:order =>[:creation.desc]), :popular_tags => Tag.tag_counts, :title =>"Recent Questions"}
end

get '/show/unanswered' do
  haml :list, :locals => {:questions => Question.all(:correct =>nil), :popular_tags => Tag.tag_counts, :title =>"Unanswered Questions"}
end
