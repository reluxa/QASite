class Comment
  include DataMapper::Resource
  property :id,         Serial    # An auto-increment integer key
  property :text,       Text      # A varchar type string, for short strings
  property :creation,   DateTime
  property :user,       String
end

class Vote
  include DataMapper::Resource
  property :id,         Serial    # An auto-increment integer key
  property :creation,   DateTime
  property :user,       String
end

class Question
  include DataMapper::Resource
  property :id,         Serial
  property :user,       String
  property :title,      String 
  property :text,       Text   
  property :views,      Integer
  property :creation,   DateTime
  has n, :answers
  has n, :comments,     :through => Resource
  has n, :tags,         :through => Resource
  has n, :votes,        :through => Resource
  belongs_to :correct, :model => "Answer", :required => false

  validates_length_of :title, :within => 10..160

  validates_length_of :text, :min =>100, :message=>"Please be a bit more specific!"

  validates_with_block :tags do
    if @tags != nil && @tags.length > 0
      true
    else
      [false, "At least one tag should be specified for the question!"]
    end
  end

  #belongs_to :owner, :model => "DmUser", :required => true
end

class Answer
  include DataMapper::Resource
  property :id,         Serial    # An auto-increment integer key
  property :user,       String
  property :mtext,      Text      # A varchar type string, for short strings
  property :creation,   DateTime
  has n,   :comments,   :through => Resource
  has n,   :votes,      :through => Resource
  belongs_to :question, :model => "Question", :required => false
end

class Tag
  include DataMapper::Resource
  property :id,        Serial    # An auto-increment integer key
  property :name,      Text      # A varchar type string, for short strings
  has n,   :questions, :through => Resource

  def self.tag_counts
    repository.adapter.select "select name, count(1) number from question_tags, tags
                              where question_tags.tag_id = tags.id
                              group by tag_id
                              order by number desc"
  end

end