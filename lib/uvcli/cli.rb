require "thor"
require "uservoice-ruby"
require "uvcli/settings"

module Uvcli
  module Cli
    class Application < Thor
     
      @@settings = Uvcli::Settings.new

      desc "login", "Login to an existing UserVoice account."
      def login
        puts %{To login to your UserVoice account we'll need your domain, key and secret.

The domain is the part in front of your uservoice.com domain, e.g. dangercove.uservoice.com.

To create a key and secret login to your UserVoice account, head over to Settings, then Integrations and click Add API Key... Only enter a name and make sure TRUSTED is not checked.

}
        puts "Domain:"
        STDOUT.flush
        domain = STDIN.gets.chomp
        puts "Key:"
        STDOUT.flush
        key = STDIN.gets.chomp
        puts "Secret:"
        STDOUT.flush
        secret = STDIN.gets.chomp

        puts "\nLogging in..."

        client = UserVoice::Client.new(domain, key, secret)
        begin
          client.get("/api/v1/tickets.json")
          puts @@settings.add_site?(domain, key, secret) ? "Site saved" : "Something went wrong"
        rescue OAuth::Unauthorized
        rescue UserVoice::Unauthorized
          puts "Failed to login"
        end
      end

      desc "check", "Check for new tickets"
      def check
        @@settings.sites.each do |site|
          client = UserVoice::Client.new(site['domain'], site['key'], site['secret'])
          tickets = client.get("/api/v1/tickets.json?per_page=10")
          if tickets
            puts "#{site['domain']}:"
            tickets['tickets'].each do |ticket|
              subject = ticket['subject'] #.truncate(25)
              last_message = ticket['messages'].first
              from = last_message['sender']['name']
              #body = last_message['body'].delete('\n') #.truncate(50)
              puts " #{from}: #{subject}\n"
            end
          else
            puts "Something went wrong"
          end
        end
      end
    end
  end
end
