# encoding: utf-8
require "logstash/outputs/base"
require "logstash/namespace"

# Event notification through Pushover.
# Currently only supports plain messages (event) and no further configuration
# options are submitted.
class LogStash::Outputs::Pushover < LogStash::Outputs::Base
  config_name "pushover"

  # Application token, obtain by registring a new application
  config :app_token, :validate => :string, :require => true

  # Key for the receiving user
  config :user_key, :validate => :string, :require => true

  # User device name: https://pushover.net/api#identifiers
  config :device, :validate => :string

  # Message title: https://pushover.net/api#messages
  config :title, :validate => :string, :default => "Logstash"

  # Message priority: https://pushover.net/api#priority
  config :priority, :validate => [-2,-1,0,1,2], :default => 0

  # Timestamp for the message: https://pushover.net/api#timestamp
  config :timestamp, :validate => :string

  # Notification sound: https://pushover.net/api#sounds
  config :sound, :validate => :string

  # Supplementary URLs: https://pushover.net/api#urls
  config :url, :validate => :string # XXX: something://rest

  # Supplementary URL title: https://pushover.net/api#urls
  config :url_title, :validate => :string

  # Wether to append "tags: <list of tags>" to the event
  config :add_tags, :validate => :boolean, :default => :false

  # URL of the Pushover API; should generally not be adjusted but it's
  # configurable for testing or in case the something changes upstream and
  # this plugin isn't updated quick enough.
  config :api_url, :validate => :string, :default => 'https://api.pushover.net/1/messages.json'

  public
  def register
    require 'net/https'
    require 'uri'
    @api_uri = URI.parse(@api_url)
    @client = Net::HTTP.new(@api_uri.host, @api_uri.port)
  end # def register

  public
  def receive(event)
    return unless output?(event)

    @logger.info("Pushover event", :event => event)

    # If requested, add any logstash tags to the message
    message = event.to_s
    if @add_tags
      message += " tags: " + @tags.join(',') if @tags
    end

    begin
      request = Net::HTTP::Post.new(@api_uri.path)
      request.set_form_data({
        :token => @app_token,
        :user => @user_key,
        :message => event
      })
      # XXX: For any additional configuration keys, add them to the request.
      response = @client
      response.use_ssl = true
      response.verify_mode = OpenSSL::SSL::VERIFY_PEER
      response.start do |http|
        r = http.request(request)
        if status = r.body.match(/"status":(\d+)/)[1] != 1
          @logger.warn("API error", :status => status)
        end
      end
    rescue Exception => e
      @logger.warn("Failed to push notification", :event => event, :exception => e,
        :backtrace => e.backtrace)
    end
  end # def event
end # class LogStash::Outputs::Pushover
