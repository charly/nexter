# Nexter

[![Gem Version](https://badge.fury.io/rb/nexter.png)](http://badge.fury.io/rb/nexter)
[![Build Status](https://travis-ci.org/charly/nexter.png?branch=master)](https://travis-ci.org/charly/nexter)

What is Nexter ? A misspelled tv show or a killer feature ? Not sure but it wraps your ActiveRecord model with an ordered scope and consistently cuts out the _next_ and _previous_ records. It also works with associations & nested columns : `order("books.genre, authors.name, published_at desc")` 

## Installation

    gem 'nexter'
    # (edge) gem 'nexter', git: 'https://github.com/charly/nexter'

## Bare Usage

```ruby
@books = Book.includes(:author).bestsellers.
              order("genre", "authors.name", "published_at desc")

nexter = Nexter.wrap( @books, @books.find(params[:id]) )
nexter.previous
nexter.next
```

## Rails Usage

It helps you cycle consistentely through each record of any filtered collection instead of helplessly hit the back button of your browser to find the next item of your search. It plays well with gem which keeps the state of an `ActiveRelation like [siphon](https://github.com/charly/siphon), [ransack](https://github.com/activerecord-hackery/ransack), [has_scope](https://github.com/plataformatec/has_scope) & others.

### New way (edge)

With the new view helper no need to inject previous/next in the ActiveRecord model.
However there's a few assumptions : 

1. the formobject responds to result and returns an activerelation (like ransack does)
2. the formobject responds to params and returns those persisting the activerelation

```ruby
class BookController
  before_filter :resource, except: :index

  def resource
    @book_search ||= BookSearch.new(params[:book_search])
    @book ||= Book.includes([:author]).find(params[:id])
  end
end
```

```erb
<%- nexter @book, @book_search do |book| %>
  <%= link_to "previous",   book.path([:edit, :admin, @book.previous]) %>
  <%= link_to "collection", book.path([:admin, @book.class]) %>
  <%= link_to "next",       book.path([:edit, :admin, @book.next])
```

### Old way (still applies but verbose)

```ruby
class Book
  def nexter=(relation)
    @nexter = Nexter.wrap(relation, self)
  end

  def next
    @nexter.next || self
  end

  def previous
    @nexter.previous || self
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

```erb
<%= link_to "previous", book_path(@book.previous, book_search: params[:book_search]) %>
<%= link_to "collection", book_path(book_search: params[:book_search]) %>
<%= link_to "next", book_path(@book.next, book_search: params[:book_search])
```

## TODO

- (feature) group/havings logic
- (test) viewhelper
- (docs) How it works
- (feature) Joins ?
- (docs) previous/next through ctrl (not preloaded)
- (fix) for nil values you need a reorder with default delimiter

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request


[![Bitdeli Badge](https://d2weczhvl823v0.cloudfront.net/charly/nexter/trend.png)](https://bitdeli.com/free "Bitdeli Badge")

