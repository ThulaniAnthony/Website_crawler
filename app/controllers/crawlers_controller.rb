class CrawlersController < ApplicationController
  def index
    @crawlers = Crawler.all
  end

  def crawl
    url = params[:url]

    if url.present?
      Crawler.crawl_website('https://www.hellopeter.com/miway')
      flash[:success] = 'Crawling process started successfully.'
    else
      flash[:error] = 'Please provide a valid URL.'
    end

    redirect_to root_path
  end
end


