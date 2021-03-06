#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Portrait'
  end

  class Officeholder < OfficeholderBase
    def columns
      %w[no img name constituency start end].freeze
    end

    def empty?
      (tds[5].text == tds[6].text) || too_early?
    end

    def raw_start
      start_cell.children.map(&:text).join(' ').tidy
    end

    def raw_end
      end_cell.children.map(&:text).join(' ').tidy
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
