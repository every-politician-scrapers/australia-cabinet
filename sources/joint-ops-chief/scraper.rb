#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Postnominal'
  end

  def table_number
    1
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[rnk name pn image start end].freeze
    end

    def empty?
      tds[2].text == tds[3].text
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
