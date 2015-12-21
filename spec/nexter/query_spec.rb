require "spec_helper"

describe Nexter::Query, broken: true do

  let(:columns) {[
    {col: "authors.name",  val: "nabokov", dir: "asc"},
    {col: "genre",         val: "novel",   dir: "asc"},
    {col: "title",         val: "ada",     dir: "asc"}
  ]}

  describe "#where" do

    it "builds the query from its ashes" do
      query = Nexter::Query.new(columns, :next)

      expect(query.wheres).to eq(
        [ "authors.name = 'nabokov' AND genre = 'novel' AND title > 'ada'",
          "authors.name = 'nabokov' AND genre > 'novel'",
          "authors.name > 'nabokov'"])
    end
  end

end