require 'sinatra'
require 'net/http'
require 'uri'
require 'json'

SLACK_WEBHOOK=ENV['SLACK_WEBHOOK']
SLACK_CHANNEL=ENV['SLACK_CHANNEL']

ANSWER = {
  'q1' => 'Georgi'
}

class App < Sinatra::Base
  attr_reader :answers

  get '/ping' do
    'pong'
  end

  post '/submit' do
    if /^q[0-9]+$/ === params[:q] && ANSWER[params[:q]]
      check params[:q], params[:a]
    else
      'invalid request'
    end
  end

  helpers do
    def check(q, a)
      msg = if ANSWER[q] === a
        "#{request.ip} が #{q} を 正解 しました :ok_woman:"
      else
        "#{request.ip} が #{q} を 不正解 しました :no_good:"
      end

      slack(msg)

      msg
    end

    def slack(msg)
      uri = URI.parse(SLACK_WEBHOOK)
      payload = {
        text: msg,
        channel: SLACK_CHANNEL,
        username: '19新卒くん',
        icon_emoji: ':innocent:'
      }
      Net::HTTP.post_form(uri, { payload: payload.to_json })
    end
  end
end
