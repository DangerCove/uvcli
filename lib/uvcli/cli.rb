require "thor"
require "uservoice-ruby"
require "uvcli/settings"

module Uvcli
  module Cli
    class Application < Thor
     
      @@settings = Uvcli::Settings.new

      desc "login", "Login to an existing UserVoice account."
      def login
        puts %{To login to your UserVoice account we'll your domain, key and secret.

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

        @client = UserVoice::Client.new(domain, key, secret)

        puts @@settings.add_site?(domain, key, secret) ? "Site saved" : "Something went wrong"
      end

      desc "check", "Check for new tickets"
      def check
        puts @@settings.sites
      end
    end
  end
end
