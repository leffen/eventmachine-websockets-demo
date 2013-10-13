require_relative '../../spec_helper'

module Ewd
  describe Votes do

    let(:votes) { Votes.new }
    let(:questions) { 10.times.map { |i| [i, "sporsmal #{i}", 'yes'] } }
    let(:ips) { 10.times.map { |i| "192.168.3.#{random(256)}" } }
    let(:answers) { {1 => {"192.168.3.101" => {"vote" =>"yes","vote_value"=>'yes', "points"=>0}}} }

    context "Questions" do

      it "should be able to add question" do
        expect(votes.set_question(1, 'Is WebSockets cool ?', 'yes')).to eq({"label" => 'Is WebSockets cool ?', "answer" => 'yes'})
      end

      it "should be able to add an array of questions on the form [spm,question, answer]" do
        votes.set_questions(questions)
        expect(votes.questions.count).to eq(10)
      end

    end

    context "Answers" do

      it "Able to add a new vote for a given question" do
        expect(votes.set_answer(1, '192.168.3.110', 'yes')).to eq(1)
        expect(votes.answers.count).to eq(1)
      end

      it "should not change when voting wrong" do
        expect(votes.set_answer(1, '192.168.3.110', 'nox')).to eq(0)
      end
    end

    context "Point calculations" do
      let(:answer) { [i, "sporsmal #{i}", 'yes'] }

      it "should award one point for correct answer" do
        votes.set_question(1, 'Is WebSockets cool ?', 'yes')
        expect(votes.set_answer(1, '192.168.3.110', 'yes')).to eq(1)
      end
    end

    context "Json data" do
      it "should be able to create from json data" do
        data = {"questions" => questions, "answers" => answers }
        votes = Votes.from_json(data)

        expect(votes.questions.count).to eq(questions.count)
        expect(votes.answers.count).to eq(answers.count)
        expect(votes.spm_answer_yes_no_sum(answers.first[0])).to eq(1)
      end



    end


  end
end