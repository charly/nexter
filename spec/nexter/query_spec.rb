require "spec_helper"

describe Nexter::Query do

  let(:columns) {[
    {col: "authors.name",  val: "nabokov", dir: "asc"},
    {col: "genre",         val: "novel",   dir: "asc"},
    {col: "title",         val: "ada",     dir: "asc"}
  ]}

  context "on a next query" do
    let(:query) { Nexter::Query.new(columns, :next) }

    describe "#where" do
      it "builds the query from its ashes" do
        expect(query.wheres).to include(
          "authors.name = 'nabokov' AND (genre > 'novel' OR genre IS NULL)")
      end
    end

    describe "#reloads" do
      it "keeps the original order" do
        expect(query.reorders).to eq([
          "authors.name ASC", "genre ASC", "title ASC"])
      end
    end
  end

  context "on a previous query" do
    let(:query) { Nexter::Query.new(columns, :previous) }

    describe "#where" do
      it "builds the query from its ashes" do
        expect(query.wheres.size).to eq(3)
        expect(query.wheres).to include(
          "authors.name = 'nabokov' AND genre = 'novel' AND (title < 'ada')")
      end
    end

    describe "#reloads" do
      it "reverses the original order" do
        expect(query.reorders).to eq([
          "authors.name DESC", "genre DESC", "title DESC"])
      end
    end
  end

  context "when some value (title) is null (AND nulls come last!)" do

    it "it skips **next** null (not possible) and moves to higher section" do
      columns.last.merge!({val: nil})
      query = Nexter::Query.new(columns, :next)

      expect(query.wheres.size).to eq(2)
    end

    it "it looks for **previous** non null value of title" do
      columns.last.merge!({val: nil})
      query = Nexter::Query.new(columns, :previous)

      expect(query.wheres[0]).to eq(
        "authors.name = 'nabokov' AND genre = 'novel' AND title IS NOT NULL")
    end
  end


end