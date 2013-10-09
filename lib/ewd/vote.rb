module Ewd

  class Votes
    attr_accessor :questions

    def add(spm,ip,vote)
      @questions ||= {}
      @questions[spm] ||= {}
      @questions[spm][ip.to_s] = vote_to_i(vote)
      @questions[spm].map{|k,v|v}.reduce(:+)
    end

  end

end