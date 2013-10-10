module Ewd

  class Votes
    attr_accessor :questions,:answers

    VOTES={'yes'=> 1, 'no' => -1}

    def set_answer(spm,ip,vote)
      @answers ||= {}
      @answers[spm] ||= {}
      @answers[spm][ip.to_s] = vote_to_i(vote)
      @answers[spm].map{|k,v|v}.reduce(:+)
    end

    def set_question(spm,label,correct_answer)
      @questions  ||={}
      @questions[spm] = {label: label, answer: correct_answer}
    end

    private

    def vote_to_i(vote)
      VOTES[vote.downcase].to_i
    end

  end

end