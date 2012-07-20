#!/bin/sh
#
# Updates the repo with new tweets.
#
# Assumes that `last-tweet-id` in your root already contains the last tweet ID
# you've made.

proxy_host=172.16.19.254
proxy_port=8118

set -x

login="erning"
email="zhang@erning.com"

last_id=$(cat $login.last-tweet-id)

http_proxy=http://$proxy_host:$proxy_port madrox --import=twitter --since-id=$last_id --email=$email $login
# git merge -s ours $login

last_id=$(curl https://twitter.com/users/show/$login.json --silent -x $proxy_host:$proxy_port |
          tr ',' "\n" |
          grep -m2 '"id_str"' |
          sed -e 's/"id_str"://g' |
          sed -e 's/\"//g' |
          tail -n1)
echo $last_id > $login.last-tweet-id

