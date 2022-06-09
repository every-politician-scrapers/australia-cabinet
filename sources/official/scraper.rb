#!/bin/env ruby
# frozen_string_literal: true

require 'every_politician_scraper/scraper_data'
require 'pry'

class MemberList
  class Member
    field :name do
      Name.new(
        full:     noko.css('.title').text.tidy,
        prefixes: %w[Dr Senator the Hon],
        suffixes: %w[MP AM CSC],
      ).short
    end

    field :position do
      noko.css('.ministries').text
          .gsub(', Assistant', '|Assistant')
          .gsub(', Deputy',    '|Deputy')
          .gsub(', Minister',  '|Minister')
          .gsub(', Special',   '|Special')
          .gsub(', Attorney',  '|Attorney')
          .gsub(', Cabinet',   '|Cabinet')
          .split('|')
    end
  end

  class Members
    def member_container
      noko.css('.minister-item')
    end
  end
end

file = Pathname.new 'official.html'
puts EveryPoliticianScraper::FileData.new(file).csv
