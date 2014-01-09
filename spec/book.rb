Author = Struct.new(:name)

Book = Struct.new(:genre, :name, :title) do

  def id; 71; end

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
    @order_values ||= ["books.genre", "authors.name", "books.title"]
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