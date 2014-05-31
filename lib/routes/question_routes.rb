get '/add/question' do
  haml :edit, :locals => {:q_title => params[:q_title]}
end

get '/edit/question/:id' do
  haml :edit, :locals => {:question => Question.get(Integer(params[:id]))}
end

get '/show/question/:id/*' do
  question = QuestionUtil.load_question_for_view(params[:id]);
  haml :show, :locals => {:question => question}
end

post '/save/question' do
  if params[:qid] != nil && params[:qid].length > 0
    puts "innen"
    question = Question.get(params[:qid]);
    question.tags.clear();
  else
    question = Question.new(
      :creation => Time.new,
      :user => current_user()
    );
  end
  question.text = params[:q_text];
  question.title = params[:q_title];
  params[:tags].split(',').each { |tag_name|
    question.tags.push(Tag.first_or_new(:name => tag_name));
  }
  if question.valid? && question.save
    redirect "/"
  else
    haml :edit, :locals => {:question => question}
  end
end

get '/vote/question/:id/:direction' do
  question = QuestionUtil.vote_question(params[:id],params[:direction], current_user());
  question.votes.length.to_s;
end

get '/accept/question/:qid/:aid' do
  QuestionUtil.accept_answer(params[:qid],params[:aid]);
end

get '/vote/answer/:id/:direction' do
  answer = QuestionUtil.vote_answer(params[:id],params[:direction], current_user());
  answer.votes.length.to_s
end

post '/comment/answer/:id' do
  answer = QuestionUtil.add_answer_comment(params[:id],params[:comment], current_user());
  redirect QuestionUtil.create_question_show_url(answer.question.id);
end

post '/comment/question/:id' do
  question = QuestionUtil.add_question_comment(params[:id],params[:comment], current_user());
  redirect QuestionUtil.create_question_show_url(question.id);
end

post '/answer/question/:qid' do
  question = QuestionUtil.get(params[:qid]);
  question.answers.create(
       :mtext => params[:answer],
       :creation => Time.new,
       :user => current_user()
  )
  question.save;
  puts question.errors.full_messages.join(",");
  redirect QuestionUtil.create_question_show_url(question.id);
end


