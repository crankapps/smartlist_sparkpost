require "smartlist_sparkpost/version"
require "smartlist_sparkpost/delivery_exception"
require "smartlist_sparkpost/transmissions"

module SmartlistSparkpost
  class << self
    attr_accessor :configuration
  end

  def self.configuration
    @configuration ||= Configuration.new
  end

  def self.configure
    self.configuration ||= Configuration.new
    yield(configuration)
  end

  class Configuration
    attr_accessor :api_key
    attr_accessor :version

    attr_accessor :track_opens
    attr_accessor :track_clicks

    attr_accessor :campaign_id

    attr_accessor :transactional
    attr_accessor :ip_pool
    attr_accessor :html_content_only

    def initialize
      set_defaults
    end

    def set_defaults
      if ENV.has_key?('SPARKPOST_API_KEY')
        @api_key = ENV['SPARKPOST_API_KEY']
      else
        @api_key = ''
      end

      @sandbox = false

      @track_opens = false
      @track_clicks = false

      @campaign_id = nil

      @transactional = false
      @ip_pool = nil
      @html_content_only = false
      @version = 'v1'
    end
  end
end
