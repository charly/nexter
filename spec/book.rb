Book = Struct.new(:genre, :name, :title) do


  def id; 71; end

  def self.table_name
    "books"
  end

  def self.sanitize(args)
    "'#{args}'"
  end

  def self.reflections
    {author: "blurb"}
  end

  def author
    a = Struct.new(:name)
    a.new(name)
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

  def order(args)
    self
  end

end