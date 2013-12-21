Author = Struct.new(:b)

Book = Struct.new(:a, :b, :c) do

  def self.table_name
    "books"
  end

  def reflections
    {:author => "blurb"}
  end

  def author
    Author.new("nabokov")
  end
end

class Relation
  attr_accessor :order_values, :includes_values

  def order_values
    @order_values ||= ["books.a", "authors.b", "books.c"]
  end

  def includes_values
    [:author]
  end

  def where(args)
    self
  end

  def reorder(args)
    self
  end

end