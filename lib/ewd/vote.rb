require 'json'

module Ewd

  class Votes
    attr_accessor :questions, :answers

    VOTES={'yes' => 1, 'no' => -1}

    def initialize(questions=nil, answers=nil)
      @questions={}
      @answers={}

      set_questions(questions) if questions
      answers.each{|spm,v| v.each{|ip,value| set_answer(spm,ip,value["vote"]) } } if answers

    end

    def set_answer(spm, ip, vote)
      key = spm.to_i
      @answers[key] ||= {}
      @answers[key][ip.to_s] ={"vote" => vote, "vote_value" => vote_to_i(vote), "points"=>0}
      spm_answer_yes_no_sum(key)
    end

    # Calculates the yes no sum on the answer. Based on yes = 1 and no = -1
    def spm_answer_yes_no_sum(spm)
      @answers[spm.to_i].map { |k, v| v["vote_value"] }.reduce(:+)
    end

    # Use a array to set a batch of answers. Format [[spm,label,correct_answer],[...]]
    def set_questions(questions)
      questions.each { |q| set_question(q[0], q[1], q[2]) }
    end

    def set_question(spm, label, correct_answer)
      @questions[spm] = {"label" => label, "answer" => correct_answer}
    end

    def to_json(*a)
      {
          :questions => @questions,
          :answers => @answers
      }.to_json(*a)
    end

    def self.from_json(json_data)
      self.new(json_data["questions"], json_data["answers"])
    end

    private

    def vote_to_i(vote)
      VOTES[vote.downcase].to_i
    end

  end

end