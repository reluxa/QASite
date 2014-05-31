require "cgi"

# To change this template, choose Tools | Templates
# and open the template in the editor.

class QuestionUtil

  def self.load_question_for_view(id)
    question = get(id)
    question.views = question.views.to_i + 1;
    question.save;
    return question;
  end

  def self.vote_question(id, direction, user)
    question = get(id)
    vote = question.votes.first(:user => user)
    if (direction == "up" && vote == nil)
      vote = question.votes.create(
         :creation => Time.new,
         :user => user
      )
      question.save;
    elsif (direction == "down" && vote != nil)
      question.votes.delete(vote);
      vote.destroy
      question.save;
    end
    return question;
  end

  def self.vote_answer(id,direction, user)
    answer = Answer.get(id)
    vote = answer.votes.first(:user => user)
    if (direction == "up" && vote == nil)
      vote = answer.votes.create(
         :creation => Time.new,
         :user => user
      )
      answer.save;
    elsif (direction == "down" && vote != nil)
      answer.votes.delete(vote);
      vote.destroy
      answer.save;
    end
    return answer;
  end

  def self.accept_answer(qid,aid)
    question = get(qid);
    answer = Answer.get(aid);
    question.correct = answer;
    question.save;
  end

 def self.add_answer_comment(id,text, user)
    answer = Answer.get(id)
    comment = Comment.create(
       :text => text,
       :creation => Time.new,
       :user => user
    )
    comment.save;
    answer.comments.push(comment);
    answer.save!;
    return answer;
 end

 def self.get(id)
   question = Question.get(id);
   question.tags.size
   return question
 end

 def self.add_question_comment(id,text, user)
    question = Question.get(id)
    comment = Comment.create(
       :text => text,
       :creation => Time.new,
       :user => user
    )
    comment.save;
    question.comments.push(comment);
    question.save!;
    return question;
 end

 def self.create_question_show_url(id)
    question = Question.get(id);
    return '/show/question/'+question.id.to_s+"/"+escape_title(question.title);
 end

 def self.escape_title(title)
    return CGI::escape(title.gsub(/\ /,'-').downcase)
 end


  
end
