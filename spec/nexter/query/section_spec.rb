require "spec_helper"

describe Nexter::Query::Section do

  # let(:compass) {Nexter::Compass.new(:next)}
  let(:columns) {[
    {col: "authors.name",  val: "nabokov", dir: "asc"},
    {col: "genre",         val: "novel",   dir: "asc"},
    {col: "title",         val: "ada",     dir: "asc"}
  ]}

  describe "#iterate" do

    it "should iterate mother fucker" do
      section = Nexter::Query::Section.new(columns)

      expect(section.iterate).to eq(
        "authors.name = 'nabokov' AND genre = 'novel' AND title = 'ada'")
    end
  end
end