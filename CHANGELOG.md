## Nexter 0.2.0 (Mars 2016)

* properly do order parsing so it works with arel or plain string
* quote or not values of a column (e.g "title > 'sweet bean'" or "num < 18")
* some dirty hack on float values to make comparaison work

## Nexter 0.1.0 (Dec 2015)

* All model values for building the query moved in wrap
* Query now only takes a hash of values to build itself
* Query relies on Section for the possible records
* Query uses Direction to look at the next bigger or smaller
* Nexter now **handles NULL** yey


## Nexter 0.0.5

* sanitize SQL (wonky still needs work)