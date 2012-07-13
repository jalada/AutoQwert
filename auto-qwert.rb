require 'bundler'
Bundler.require

# Fix for bug in AppConfig
require 'erb'
AppConfig.configure do |config|
  config.config_file = "config.yml" 
end

class AutoQwert

  def state_file
    "current.txt"
  end

  def send_mail
    Pony.mail(subject: 'New Qwertee Tee!',
              html_body: "<h1>Hi!</h1> <p>There's a new Qwertee tshirt. Here it is:</p><img src='http://qwertee.com#{@current_image}'><p>Lots of love</p><br /><p>The Auto-Qwertee bot</p>")
  end

  def send_error(message="Problem!")
    Pony.mail(subject: 'Auto-Qwertee bot has a problem! :(',
              body: "The reported error was: #{message}. I'll try again later.")
  end

  def setup_pony
    Pony.options = { :from => AppConfig.from, :to => AppConfig.to }
  end

  def initialize
    @current_image = if File.exists? state_file
      File.read state_file
    end
    setup_pony
  end

  def run
    response = Typhoeus::Request.get("http://qwertee.com", follow_location: true)
    if response.success?
      html = Nokogiri::HTML.parse response.body
      image = html.at_css("#splash-picture-actual")
      send_error("No image found") and return unless image
      if image['src'] != @current_image
        @current_image = image['src']
        send_mail
        File.open(state_file, "w") do |f|
          f.write @current_image
          f.close
        end
      end
    else
      send_error(response.body)
    end
  end

end

AutoQwert.new.run
