require "spec_helper"

describe Nexter::Wrap do

  context "no missing values" do
    let(:relation) { Relation.new.tap {|rel| rel.order_values=["authors.name", "title"]} }
    let(:book)     { Book.new("novel", "nabokov", "ada") }

    describe "#wheres" do
      it "has the right SQL condition" do
        nexter = Nexter::Wrap.new(relation, book)
        nexter.after

        expect(nexter.wheres[0]).to eq("(authors.name = 'nabokov' AND title > 'ada')")
      end
    end

    describe "#reorders" do
      it "has the right SQL condition" do
        nexter = Nexter::Wrap.new(relation, book)
        nexter.before

        expect(nexter.wheres[0]).to eq("(authors.name = 'nabokov' AND title < 'ada')")
      end

      it "has the right SQL order by" do
        nexter = Nexter::Wrap.new(relation, book)
        nexter.before

        expect(nexter.reorders[0]).to eq(" authors.name desc")
      end
    end
  end

  context "nil values" do
    let(:relation) { Relation.new.tap {|rel| rel.order_values=["genre", "title"]} }

    describe "#wheres" do
      let(:book) { Book.new(nil, "nabokov", "Ada") }

      it "has the right SQL condition" do
        nexter = Nexter::Wrap.new(relation, book)
        nexter.after

        expect(nexter.wheres[0]).to eq("(genre IS NULL AND title > 'Ada')")
      end
    end

    describe "#wheres" do
      let(:book) { Book.new("novel", "nabokov", nil) }

      it "has the right SQL condition" do
        nexter = Nexter::Wrap.new(relation, book)
        nexter.after

        expect(nexter.wheres[0]).to eq("(genre = 'novel' AND title IS NULL AND books.id > #{book.id})")
      end
    end

  end #contextr

end