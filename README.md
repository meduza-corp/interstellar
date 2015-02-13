This is a super simple ruby app to get reviews for you Google Play Store-released application to the Slack channel.

At the end you can expect to have something like that in your slack chat

![slack](https://raw.githubusercontent.com/meduza-corp/interstellar/master/slack_screenshot.jpg?token=AAyQJbZeASPCKj8YppJQFsOTtR8FLUeDks5U5ysrwA%3D%3D)

# How it works
Google Play [exports](https://support.google.com/googleplay/android-developer/answer/138230) all your app reviews once a day to the [Google Cloud Storage](https://cloud.google.com/storage/docs) bucket.

_Interstellar_ downloads reviews via google-provided [gsutil](https://cloud.google.com/storage/docs/gsutil) tool and triggers [Slack incoming webhook](https://api.slack.com/incoming-webhooks) for all new or updated reviews.

It is intended to be fired once a day via cron.

# Why do we need it
Monitoring Google Play reviews is a must for a responsible Android developer.

Users treat Google Play reviews as a way to seek for support.

Although you have only one hit — consecutive edits of *your* reply won’t be emailed to the user as the first one — it helps a lot in troubleshooting, especially given the range of different devices and OS versions on the market.

# Configuration

1. create a file `secrets/secrets.yml`, (there is an example in secrets/secrets.yml.example)

  You will need to provide:
  - report bucket id. Found in the Reviews page of Google Play Developer console, e.g. `pubsite_prod_rev_01234567890987654321`
  - package name, eg `com.example.reader`, found in the Google Play Developer console
  - slack incoming webhook url, create new one via [direct link](https://slack.com/services/new/incoming-webhook) once you've logged in to the slack

2. configure [gsutil](https://github.com/GoogleCloudPlatform/gsutil/). It’s a python app from Google.

## Gsutil configuration 
https://cloud.google.com/storage/docs/gsutil, https://github.com/GoogleCloudPlatform/gsutil
Run `gsutil/gsutil` and follow the steps. Once you do this, you will have a .boto file in your home dir. Copy this file to the ./secrets folder and you are good to go. You can always get the latest gsutil(https://cloud.google.com/storage/docs/gsutil_install) and change this line
`system “BOTO_PATH=./secrets/.boto gsutil/gsutil cp -r gs://#{CONFIG[“app_repo”]}/reviews/#{csv_file_name} .”`
to point it to whatever place you like (keep in mind though, that the sender.rb script expects, that the csv file is in the same folder).

It uses rest-client, so, install it via gem install rest-client

# Usage
Once configured - run `ruby sender.rb`

# License
This piece of software is distributed under 2-clause BSD license.

Well, actually, you code it yourself during the coffee-break.
