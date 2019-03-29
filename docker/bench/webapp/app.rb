require 'sinatra'
require 'net/http'
require 'uri'
require 'json'

SLACK_WEBHOOK=ENV['SLACK_WEBHOOK']
SLACK_CHANNEL=ENV['SLACK_CHANNEL']


class App < Sinatra::Base
  get '/' do
    msg = `cd /opt/isucon5-qualify/bench && cat ../webapp/script/testsets/testsets.json | jq '.[0]' | gradle run -q -Pargs="net.isucon.isucon5q.bench.scenario.Isucon5Qualification #{request.ip}:8080" | ruby -rjson -r../eventapp/lib/score -e "r=JSON.parse(STDIN.read);puts Isucon5Portal::Score.calculate(r);puts r['responses'];r['violations'].each{|v| puts v['description']}" `

    slack <<EOF
benchmark result: `#{request.ip}` :runner:
#{msg}
EOF

    msg
  end

  helpers do
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
