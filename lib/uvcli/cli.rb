require "thor"
require "uservoice-ruby"
require "uvcli/settings"

module Uvcli
  module Cli
    class Application < Thor
     
      @@settings = Uvcli::Settings.new

      desc "login", "Login to an existing UserVoice account"
      def login
        puts %{\nTo login to your UserVoice account we'll need your domain, key and secret.

The domain is the part in front of your uservoice.com domain, e.g. dangercove.uservoice.com.

To create a key and secret login to your UserVoice account, head over to Settings, then Integrations and click Add API Key... Only enter a name and make sure TRUSTED is checked.

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
          puts @@settings.add_site?(domain, key, secret) ? green("Site saved") : red("Something went wrong")
        rescue OAuth::Unauthorized
        rescue UserVoice::Unauthorized
          puts red("Failed to login")
        end
      end

      desc "check", "Check for new tickets"
      def check
        if(@@settings.sites.empty?)
          puts red("\nSetup a few sites first with 'uvcli login'")
          return
        end

        all_tickets = []
        @@settings.sites.each do |site|
          client = UserVoice::Client.new(site['domain'], site['key'], site['secret'])
          response = client.get("/api/v1/tickets.json?state=open")
          if response 
            puts "\n#{site['domain']}:"
            tickets = response['tickets'] 
            if tickets.empty?
              puts green(" Inbox zero!")
            else
              tickets.each do |ticket|
                all_tickets << ticket
                subject = ticket['subject'][0...70]
                subject = "#{subject}..." if subject.length < ticket['subject'].length
                last_message = ticket['messages'].first
                sender = last_message['sender']['name']
                email = last_message['sender']['email']
                body = last_message['plaintext_body'].gsub("\n", " ")[0...70]
                body = "#{body}..." if body.length < last_message['body'].length
                updated = DateTime.parse(last_message['updated_at'])
                puts "\n [#{green(all_tickets.size)}] #{red(subject)}\n #{body}\n #{updated.strftime('%d/%m/%Y at %H:%M')} by #{green(sender)} <#{green(email)}>\n"
              end
            end
          else
            puts red(" Unable to retrieve tickets")
          end
        end

        return if all_tickets.empty?

        puts "\nOpen ticket (#{green('#')} for ticket, #{green('a')} for all, #{red('q')} to quit):"
        STDOUT.flush
        ticketid = STDIN.gets.chomp.downcase
       
        if(ticketid.to_i > 0 and ticketid.to_i.is_a? Integer)
          puts "Showing ticket #{ticketid.to_i}"
          `open #{all_tickets[ticketid.to_i]['url']}`
        elsif(ticketid == "a")
          if(all_tickets.size > 10)
            puts "\nAre you sure? This will open #{all_tickets.size} browser windows? [y/N]"
            STDOUT.flush
            sure = STDIN.gets.chomp.downcase
            if(sure == "y")
              puts "Showing all tickets"
              all_tickets.each do |ticket|
                `open #{ticket['url']}`
                sleep(1.0/10.0)
              end
            end
          end
        end
      end

      private

      def colorize(text, color_code)
          "\e[#{color_code}m#{text}\e[0m"
      end

      def red(text); colorize(text, 31); end
      def green(text); colorize(text, 32); end
    end
  end
end
