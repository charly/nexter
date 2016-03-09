require "spec_helper"

describe Nexter::Model do
  let(:relation) {
    Relation.new.tap{|r| r.order_values=["authors.name","genre","title"]}}

  let(:book) { Book.new("novel", "nabokov", "ada") }

  describe "#values" do
    it "should create hashes of attributes out of the order values" do
      model = Nexter::Model.new(book, relation)

      expect(model.values).to eq([
        {col: "authors.name",  val: "nabokov", dir: "asc"},
        {col: "genre",         val: "novel",   dir: "asc"},
        {col: "title",         val: "ada",     dir: "asc"}
      ])
    end

    it "should skip non existing columns (for now ?)" do
      relation = Relation.new.tap{|r| r.order_values=["pg_search_8bf729ffe074caee622c02.rank","title"]}
      model = Nexter::Model.new(book, relation)

      expect(model.values).to eq([
        {col: "title",         val: "ada",     dir: "asc"}
      ])
    end
  end


end