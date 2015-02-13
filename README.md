This is a super simple small project to get reviews from google play store for your application to slack. (slack.com)

https://support.google.com/googleplay/android-developer/answer/138230

It is intended to work via cron, to get the daily review updates form google play store.

### Configuration
To use it you need to do some basic configuration:
first - create a file `secrets/secrets.yml`, (there is a secrets/secrets.yml.example)
You need to provide your app name in google play, the private repo, where google stores the csv with reviews and a slack incoming webhook url.

You also need to configure gsutil (a python app, that can get the csv with reviews from google storage)

### Gsutil configuration 
https://cloud.google.com/storage/docs/gsutil, https://github.com/GoogleCloudPlatform/gsutil
You need to simply run `gsutil/gsutil` and follow the steps. Once you do this, you will have a .boto file in your home dir, simply copy this file to the ./secrets folder and you are good to go.

It uses rest-client, so, install in via gem install rest-client

### Usage
Once configured - simpy run `ruby sender.rb`
