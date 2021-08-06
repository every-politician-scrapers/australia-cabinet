#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  # details for an individual member
  class Member < Scraped::HTML
    field :name do
      noko.css('.title').text.tidy
        .delete_prefix('Senator the Hon ')
        .delete_prefix('The Hon ')
        .delete_prefix('Dr ')
        .sub(/ MP$/, '')
        .sub(/ AM$/, '')
        .sub(/ CSC$/, '')
    end

    field :position do
      noko.css('.ministries').text.split(/, (?=Minister)/).map(&:tidy)
    end
  end

  # The page listing all the members
  class Members < Scraped::HTML
    field :members do
      member_container.flat_map do |member|
        data = fragment(member => Member).to_h
        [data.delete(:position)].flatten.map { |posn| data.merge(position: posn) }
      end
    end

    private

    def member_container
      noko.css('.minister-item')
    end
  end
end

file = Pathname.new 'html/official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
