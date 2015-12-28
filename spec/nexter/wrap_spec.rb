require "spec_helper"

describe Nexter::Wrap do
  let(:relation) {Relation.new.tap{|r| r.order_values=["authors.name","genre","title"]}}
  let(:book)     {Book.new("novel", "nabokov", "ada")}

  describe "#after" do

    it "should create a realtion" do
      skip
      nexter = Nexter::Wrap.new(relation, book)

      expect(nexter.after).to eq("dfgjk")
    end
  end

end