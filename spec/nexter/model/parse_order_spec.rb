require "spec_helper"

describe Nexter::Model::ParseOrder do

  context "String with MANY order values" do
    let(:parser) {Nexter::Model::ParseOrder.new ["authors.name ASC, title DESC"]}

    describe "#parse" do
      it "should create an array of ALL order values" do
        expect(parser.parse).to eq([["authors.name", "asc"], ["title", "desc"]])
      end
    end
  end

  context "String with ONE order value" do
    let(:parser) {Nexter::Model::ParseOrder.new ["authors.name"]}

    describe "#parse" do
      it "should create an array of ONE order values" do
        expect(parser.parse).to eq([["authors.name", "asc"]])
      end
    end
  end




  # describe "#parse" do
  #   let(:relation) {
  #     Relation.new.tap{|r| r.order_values=["authors.name ASC, title DESC"] }}

  #   it "should create hashes of attributes out of the order values" do
  #     model = Nexter::Model.new(book, relation)
  #     expect(model.values).to eq("fvhjk")
  #     expect(model.order_values).to eq("fvhjk")
  #   end
  # end
end