require 'sinatra'

class App < Sinatra::Base
  get '/' do
    `cd /opt/isucon5-qualify/bench && cat ../webapp/script/testsets/testsets.json | jq '.[0]' | gradle run -q -Pargs="net.isucon.isucon5q.bench.scenario.Isucon5Qualification #{request.ip}:8080" | ruby -rjson -r../eventapp/lib/score -e "r=JSON.parse(STDIN.read);puts Isucon5Portal::Score.calculate(r);puts r['responses'];r['violations'].each{|v| puts v['description']}" `
  end
end
