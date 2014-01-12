require "spec_helper"

describe Nexter::Derange do

    let(:relation) { Relation.new }
    let(:book)     { Book.new("novel", "nabokov", "Ada") }
    let(:nexter)   { Nexter::Wrap.new(relation, book)}

    describe "#range" do
      it "returns a range of rows related to the current model (book)" do
        derange = Nexter::Derange.new(book)
        derange.columns = nexter.order_values.tap(&:pop)

        expect(derange.range).to eq("books.genre = 'novel' AND authors.name = 'nabokov'")
      end

    end

    describe "#slice" do
      it "returns a range of rows related to the current model (book)" do
        derange = Nexter::Derange.new(book)
        order_col = nexter.order_values.pop
        derange.set_vals(nexter.order_values, order_col)

        expect(derange.slice).to eq("books.title > 'Ada'")
      end


    end


end