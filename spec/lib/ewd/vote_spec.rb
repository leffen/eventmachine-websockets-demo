require_relative '../../spec_helper'

module Ewd
  describe Votes do
     it "Able to add a new vote for a given question" do
       votes = Votes.new
        expect(votes.set_answer(1,'192.168.3.110','yes')).to eq(1)
        expect(votes.answers.count).to eq(1)
     end

    it "should not change when voting wrong" do
      votes = Votes.new
      expect(votes.set_answer(1,'192.168.3.110','nox')).to eq(0)
    end

    it "should award one point for correct answer" do
      votes = Votes.new
      expect(votes.set_question(1,'Is WebSockets cool ?','yes')).to eq({label: 'Is WebSockets cool ?', answer: 'yes'})
      expect(votes.set_answer(1,'192.168.3.110','yes')).to eq(1)


    end


  end
end