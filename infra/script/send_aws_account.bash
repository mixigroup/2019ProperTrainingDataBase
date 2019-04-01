# slackbotからIAMアカウントの認証情報を送信するスクリプトです

# 実行に必要なもの
# - terraform が適用済みであること
# - terraform コマンド
# - jq コマンド

passwords() {
	terraform output --json | jq -r '[.passwords.value, .users.value] | transpose | map(.[0] + ":" + .[1]) | .[]'
}

slack() {
	local slack_name=$(echo $1 | sed 's/^db\.//')
	local channel="@$slack_name" # 動作確認するときはchannelを自分のアカウントにする
	echo IAM=$1 / Slack=$slack_name

	curl -X POST --data-urlencode "payload={\"channel\": \"$channel\", \"username\": \"19新卒くん\", \"text\": \"$slack_name san:\n【演習用AWSアカウント情報】\nID: \`$1\`\nPW: \`$2\`\n\n以下のURLからAWSにログインしてください :bow:\nhttps://752949577078.signin.aws.amazon.com/console?region=us-west-2\", \"icon_emoji\": \":innocent:\"}" $SLACK_WEBHOOK
}

run() {
	# 環境変数の設定（SLACK_WEBHOOKなど）
	aws s3 cp s3://mixi-db-training/server/slack.env tmp/slack.env
	source tmp/slack.env

	# パスワード復元用のGPG鍵
	aws s3 cp s3://mixi-db-training/config/keys/hello.private.gpg - | gpg --import

	# 一人ずつDMで送信
	for line in $(passwords); do
		local pw=$(echo $line | cut -d ':' -f 1 | base64 -d | gpg)
		local id=$(echo $line | cut -d ':' -f 2)
		slack $id $pw
	done
}

run
