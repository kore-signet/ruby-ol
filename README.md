# a ruby OpenLibrary api

### usage

```ruby
ol = OpenLibrary::Client.new

# getting a Work by ISBN, alongside all editions of it
work = ol.work(OpenLibrary::ISBN('9781250789082'), include_editions: true)
# now let's find the hardcover edition...
edition = work.editions.find { |e| e.physical_format == "hardcover" }
# and download/save the cover! 
File.write("cover.jpg", ol.cover(edition.covers[0], size: OpenLibrary::CoverSize::Large))

# we can also get a book by its OpenLibrary ID:
ancillary_justice = ol.work('OL17062644W')

# or just a single edition!
ancillary_justice_ebook = ol.edition('OL26489449M')
ancillary_justice_ebook = ol.edition(OpenLibrary::ISBN('9780316246620'))
```
