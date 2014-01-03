# Leboncoin

Ruby library for fetching and parsing search results from
[Leboncoin](http://www.leboncoin.fr).

Features:

* Proper string encoding
* Parses dates and times as `Time` objects
* Unit tests

## Usage

### Results parsing

```ruby
require 'leboncoin'

url = 'http://www.leboncoin.fr/annonces/offres/ile_de_france/?f=a&th=1&q=iphone'
results = Leboncoin.search(url)
```

Example value of `results`:

```ruby
[{:title=>"IPhone 4S blanc",
  :time=>2013-12-30 23:17:00 +0100,
  :price=>260,
  :url=>"http://www.leboncoin.fr/telephonie/595333341.htm?ca=12_s",
  :photo_url=>"http://193.164.197.40/images/699/699330113783796.jpg"},
 {:title=>"Iphone 4 16g ios 6.1",
  :time=>2013-12-30 22:44:00 +0100,
  :price=>220,
  :url=>"http://www.leboncoin.fr/telephonie/595323714.htm?ca=12_s",
  :photo_url=>"http://193.164.197.40/images/692/692330113328756.jpg"},
 {:title=>"BMW 320CD Pack M",
  :time=>2013-12-30 22:44:00 +0100,
  :price=>8,
  :url=>"http://www.leboncoin.fr/voitures/595323696.htm?ca=12_s",
  :photo_url=>"http://193.164.197.40/images/698/698330113927140.jpg"},
 {:title=>"IPhone 5 & échange contre note 3",
  :time=>2013-12-30 22:43:00 +0100,
  :price=>540,
  :url=>"http://www.leboncoin.fr/telephonie/595323204.htm?ca=12_s",
  :photo_url=>"http://193.164.197.60/images/696/696330111779591.jpg"}]
```

### Atom feed generation

```ruby
title = "Rockrider 8.1"
url = "http://www.leboncoin.fr/annonces/offres/ile_de_france/?f=a&th=1&q=rockrider+8.1"
feed = Leboncoin::Feed.new(title, url)
puts feed.to_xml
```

A Rack app is provided to create an Atom feed webserver. Example `config.ru`:

```ruby
feed = Leboncoin::Feed.new(title, url)
run Leboncoin::Feed::RackApp.new(feed)
```

See `examples/my-feed/`.
