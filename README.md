# Nexter

What is Nexter ? A misspelled tv show or a killer feature ? Almost : it wraps your model with an ordered scope and cuts out the _next_ and _previous_ records. It also works with associations & nested columns (e.g order("books.genre, authors.name, published_at DESC"))

## Installation

    gem 'nexter'

## Usage

```ruby
@bboks = Book.where("type" = "novel").includes(:author).order("type", "authors.name", "title")
nexter = Nexter.wrap( @books.find(56), @books )

nexter.previous
nexter.next
```

## Use Case Full Stack

It helps you cycle consistentely through each record of any filtered collection instead of helplessly hit the back button of your browser . It plays well with gem which keeps the state of an activeRelation like [sipon][1], [ransack][2], [has_scope][2] & others.

```erb
<%= link_to "previous", book_path(@book.previous, book_search: params[:book_search]) %>
<%= link_to "collection", book_path(book_search: params[:book_search]) %>
<%= link_to "next", book_path(@book.next, book_search: params[:book_search])
```

```ruby
class Book
  def nexter=(relation)
    @collection = relation.result
    @nexter = Nexter.wrap(@collection, self)
  end

  def next
    @nexter.next
  end

  def previous
    @nexter.previous
  end
end
```

```ruby
class BookController
  before_filter :resource, except: :index

  def resource
    @book_search = BookSearch.new(params[:book_search])

    @book ||= Book.includes([:author]).find(params[:id]).tap do |book|
      book.nexter = siphon(Book.scoped).scope(@book_search)
    end
  end
end
```


## TODO

- (docs) How it works
- (feature) Joins ?





## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
