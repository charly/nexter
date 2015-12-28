require "spec_helper"

describe Nexter::Query::Direction do

  let(:compass) {Nexter::Compass.new(:next)}
  let(:columns) {[
    {col: "authors.name",  val: "nabokov", dir: "asc"},
    {col: "genre",         val: "novel",   dir: "asc"},
    {col: "title",         val: "ada",     dir: "asc"}
  ]}

  describe "#slice" do

    it "should be awesome" do
      direction = Nexter::Query::Direction.new(columns.pop, compass)

      expect(direction.slice).to eq("(title > 'ada' OR title IS NULL)")
    end
  end

end