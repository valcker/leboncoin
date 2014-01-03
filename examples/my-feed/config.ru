require 'leboncoin/feed'

title = "Rockrider 8.1"
url = "http://www.leboncoin.fr/annonces/offres/ile_de_france/?f=a&th=1&q=rockrider+8.1"
feed = Leboncoin::Feed.new(title, url)
run Leboncoin::Feed::RackApp.new(feed)
