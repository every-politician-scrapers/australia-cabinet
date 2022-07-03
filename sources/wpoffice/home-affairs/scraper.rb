#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Order'
  end

  def table_number
    1
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no name color party pm title start end].freeze
    end

    def raw_start
      start_cell.xpath('text()').first.text.tidy
    end

    def raw_end
      end_cell.xpath('text()').first.text.tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
