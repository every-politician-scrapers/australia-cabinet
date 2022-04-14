#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class OfficeholderList < OfficeholderListBase
  decorator RemoveReferences
  decorator UnspanAllTables
  decorator WikidataIdsDecorator::Links

  def header_column
    'Term'
  end

  class Officeholder < OfficeholderBase
    @@party = {}

    def columns
      %w[name party district].freeze
    end

    field :party do
      @@party[partyLabel] ||= tds[1].css('a/@wikidata').text
    end

    field :partyLabel do
      tds[1].text.tidy
    end

    field :district do
      tds[2].css('a/@wikidata').text
    end

    field :districtLabel do
      tds[2].css('a').text
    end

    def startDate
    end

    def endDate
    end
  end
end

url = ARGV.first
puts EveryPoliticianScraper::ScraperData.new(url, klass: OfficeholderList).csv
