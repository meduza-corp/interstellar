This is a super simple small project to get reviews from google play store for your application to slack.

It is intended to work via cron, to get the dayly review updates form google play store.

To use it you need to do some basic configuration:
first - create a file secrets/secrets.yml, (there is a secrets/secrets.yml.example)
You need to provide your app name in google play, the private repo, where google stores the csv with reviews and a slack incoming webhook url.

You also need to configure gsutil (a python app, that can get the csv with reviews from google storage)

You need to simply run ./gsutil and follow the steps. Once you do this, you will have a .boto file in your home dir, simply copy this file to the ./secrets folder and you are good to go.

It uses rest-client, so, install in via gem install rest-client
