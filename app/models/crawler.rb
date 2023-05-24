require 'nokogiri'
require 'httparty'
require 'csv'
require 'logger'
require 'net/http'

class Crawler < ApplicationRecord
  def self.crawl_website(url)
    logger = Logger.new(STDOUT)

    begin
      # Check website availability
      response = Net::HTTP.get_response(URI.parse(url))
      if response.code == '200'
        # Website is available, continue scraping
        response = HTTParty.get(url)
        html = response.body

        doc = Nokogiri::HTML(html)

        # Extract review_text
        review_texts = doc.css('.ellipses')

        # Extract ratings
        ratings = doc.css('div.star-new.card-rating.is-mobile.is-hidden-desktop.is-12')

        # Extract review_date
        review_dates = doc.css('span.is-pulled-right')

        # Extract order_id if available
        order_ids = doc.css('.order-id')

        # Print the extracted data
        logger.info("Review Texts: #{review_texts}")
        logger.info("Ratings: #{ratings}")
        logger.info("Review Dates: #{review_dates}")
        logger.info("Order IDs: #{order_ids}")

        # Store the extracted data
        review_texts.zip(ratings, review_dates, order_ids).each do |data|
          Crawler.create(
            review_text: data[0],
            ratings: data[1],
            review_date: data[2],
            order_id: data[3]
          )
        end
      else
        # Handle website unavailability or unexpected response
        puts "Website unavailable. Status code: #{response.code}"
      end
    rescue StandardError => e
      # Handle network-related errors
      puts "Network error: #{e.message}"
    end
  end

  def self.export_to_csv
    crawlers = Crawler.all

    CSV.open('public/reviews.csv', 'w') do |csv|
      csv << ['Review Text', 'Ratings', 'Review Date', 'Order ID']

      crawlers.each do |crawler|
        csv << [crawler.review_text, crawler.ratings, crawler.review_date, crawler.order_id]
      end
    end
  end
end
