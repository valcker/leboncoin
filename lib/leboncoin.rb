# encoding: utf-8

require 'faraday'
require 'nokogiri'

module Leboncoin
  class Error < RuntimeError
  end

  HTML_ENCODING = Encoding::WINDOWS_1252
  HTML_ENCODING_CHARSET = 'windows-1252'.freeze

  def self.search(url)
    parse_results(search_raw(url))
  end

  def self.search_raw(url)
    http = Faraday.new
    res = http.get(url)
    unless res.status == 200
      raise Error, "unexpected server response: #{res.status}"
    end
    html = res.body.dup
    if res.headers['content-type'] =~ /\bcharset=#{Regexp.escape HTML_ENCODING_CHARSET}\b/
      html.force_encoding(HTML_ENCODING)
    end
    html
  end

  def self.parse_results(html)
    doc = Nokogiri::HTML(html)
    doc.css('.lbc').map do |node|
      { :title => node.at_css('.title').text.strip,
        :time => ResultTime.parse(node.at_css('.date').text.strip.gsub(/\s+/, ' ')),
        :price => (n = node.at_css('.price') and n.text.to_i),
        :url => node.ancestors('a')[0].attr('href'),
        :photo_url => (n = node.at_css('.image img') and n.attr('src').sub(/\/thumbs\//, '/images/')) }
    end
  end

  module ResultTime
    UTC_OFFSET = '+01:00'.freeze
    MONTHS = %w(jan fév mars avr mai juin juillet août sept oct nov déc).freeze
    
    months = MONTHS.map { |m| Regexp.escape(m) }
    DATE_RE = /(\d\d?) (#{months * '|'}) (\d\d?):(\d\d)$/

    def self.parse(str)
      case str
      when /^Aujourd'hui (\d\d?):(\d\d)$/
        today_at($1, $2)
      when /^Hier (\d\d?):(\d\d)$/
        today_at($1, $2) - 86400
      when DATE_RE
        t = Time.now.utc
        month = MONTHS.index($2) or raise Error, "unrecognized month"
        Time.new(t.year, month + 1, $1, $3, $4, 0, UTC_OFFSET)
      else
        raise Error, "unhandled time format: #{str}"
      end
    end

    def self.today_at(hour, min)
      t = Time.now.utc
      Time.new(t.year, t.mon, t.day, hour, min, 0, UTC_OFFSET)
    end
  end
end
