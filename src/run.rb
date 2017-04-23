require 'capybara'
require 'capybara/poltergeist'
require 'irb'

theo_username = ENV['THEO_USERNAME'] || raise('`username` should be spcecified as a environment variable')
theo_password = ENV['THEO_PASSWORD'] || raise('`password` should be spcecified as a environment variable')
slack_api_token = ENV['SLACK_API_TOKEN'] || raise('`SLACK_API_TOKEN` should be spcecified as a environment variable')

Capybara.javascript_driver = :poltergeist

session = Capybara::Session.new(:poltergeist)

session.visit 'https://app.theo.blue/account/login'

username = session.find('input#username')
username.native.send_key(theo_username)
password = session.find('input#password')
password.native.send_key(theo_password)

button = session.find('button.btn-primary')
button.trigger('click')

sleep 5

path = File.join('tmp', Time.now.strftime('%Y-%m-%d-%H%M%S') + '.png')
session.save_screenshot path

`curl -F file=@#{path} -F channels=#zatsu-dan -F token=#{slack_api_token} https://slack.com/api/files.upload`
