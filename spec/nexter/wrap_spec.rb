require "spec_helper"

describe Nexter::Wrap do

  describe "#wheres" do
    it "has the right SQL condition" do
      relation = Relation.new.tap {|rel| rel.order_values=["authors.b", "c"]}
      book = Book.new("novel", "nabokov", "ada")
      nexter = Nexter::Wrap.new(relation, book)
      nexter.after

      expect(nexter.wheres[0]).to eq("( authors.b = 'nabokov' AND c > 'ada' )")
      expect(nexter.wheres[1]).to eq("(  authors.b > 'nabokov' )")
    end
  end


  describe "#reorders" do
    it "has the right SQL condition" do
      relation = Relation.new.tap {|rel| rel.order_values=["authors.b", "c"]}
      book = Book.new("novel", "nabokov", "ada")
      nexter = Nexter::Wrap.new(relation, book)
      nexter.before

      expect(nexter.wheres[0]).to eq("( authors.b = 'nabokov' AND c < 'ada' )")
    end

    it "has the right SQL order by" do
      relation = Relation.new.tap {|rel| rel.order_values=["authors.b", "c"]}
      book = Book.new("novel", "nabokov", "ada")
      nexter = Nexter::Wrap.new(relation, book)
      nexter.before

      expect(nexter.reorders[0]).to eq(" authors.b desc")
    end
  end



end