# encoding: utf-8

require 'leboncoin'
require 'nokogiri'

class Leboncoin::Feed
  def initialize(title, url)
    @title = title
    @url = url
  end

  def to_xml
    build_xml.to_xml(:encoding => 'UTF-8')
  end

private

  def build_xml
    results = Leboncoin.search(@url)
    Nokogiri::XML::Builder.new do |xml|
      xml.feed(:xmlns => "http://www.w3.org/2005/Atom") do
        xml.id(@url)
        xml.title(@title)
        xml.link(:href => @url)
        if res = results[0]
          xml.updated(res[:time])
        else
          xml.updated(Time.now)
        end
        results.each do |res|
          xml.entry do
            xml.id(res[:url])
            xml.title(res[:title])
            xml.link(:type => 'text/html', :href => res[:url])
            xml.updated(res[:time])
            if p = res[:price]
              xml.summary("Prix : #{p} €")
            end
            if (u = res[:photo_url]; p || u)
              xml.content(
                [ (p and "Prix : #{p} €"),
                  (u and %(<img href="#{u}"/>))
                ].compact.join("\n")
              )
            end
          end
        end
      end
    end
  end

  class RackApp
    CONTENT_TYPE = 'application/atom+xml'.freeze

    def initialize(feed)
      @feed = feed
    end

    def call(env)
      case m = env['REQUEST_METHOD']
      when 'GET', 'HEAD'
        content = @feed.to_xml
        headers = {
          'Content-Type' => CONTENT_TYPE,
          'Content-Length' => content.bytesize.to_s
        }
        if m == 'HEAD'
          [200, headers, []]
        else
          [200, headers, [content]]
        end
      else
        [405, {}, []]
      end
    end
  end
end
