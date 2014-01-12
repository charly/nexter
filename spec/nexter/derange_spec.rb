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

      it "handles nil values" do
        book.genre = nil
        derange = Nexter::Derange.new(book)
        derange.columns = nexter.order_values.tap(&:pop)

        expect(derange.range).to eq("books.genre IS NULL AND authors.name = 'nabokov'")
      end

      it "handles nil values (just for peace of mind)" do
        book.name = nil
        derange = Nexter::Derange.new(book)
        derange.columns = nexter.order_values.tap(&:pop)

        expect(derange.range).to eq("books.genre = 'novel' AND authors.name IS NULL")
      end
    end

    describe "#slice" do
      it "returns a range of rows related to the current model (book)" do
        derange = Nexter::Derange.new(book)
        order_col = nexter.order_values.pop
        derange.set_vals(nexter.order_values, order_col)

        expect(derange.slice).to eq("books.title > 'Ada'")
      end

      it "handles nil values" do
        book.title = nil
        derange = Nexter::Derange.new(book)
        order_col = nexter.order_values.pop
        derange.set_vals(nexter.order_values, order_col)

        expect(derange.slice).to eq("books.title IS NULL AND books.id > 71")
      end
    end

end