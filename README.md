# Uvcli

Uvcli is a command line interface for the [UserVoice](https://www.uservoice.com) support and feedback platform.

## Installation

Open a terminal window and install uvcli.

    $ gem install uvcli

## Usage

Uvcli takes two commands `login` and `check`.

![Uvcli commands](https://github.com/dangercove/uvcli/raw/master/screenshots/commands.jpg)

### Login

Add new UserVoice sites to your configuration by running:

    $ uvcli login

It'll prompt you for the site's domain, key and secret. To get a key and secret go into __UserVoice &rarr; Settings &rarr; Integrations &rarr; UserVoice API keys__ and click __Add API Key...__ Make sure you set the API key to __TRUSTED__.

### Check

Uvcli will loop through each site that you've setup and look for open tickets. Afterwards you can tell uvcli to open a single ticket or all of them in your default browser.

    $ uvcli check 

![Uvcli tickets](https://github.com/dangercove/uvcli/raw/master/screenshots/tickets.jpg)

### Removing sites

You can manually remove sites from the configuration file, located in `~/.uvcli/uvcli.yml`.

## Contributing

1. Fork it ( https://github.com/dangercove/uvcli/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
