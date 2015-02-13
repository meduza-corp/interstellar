require 'rest-client'
require 'json'
require 'date'
require 'csv'
require 'yaml'

CONFIG = YAML.load_file('./secrets/secrets.yml')

date = Date.today-1
file_date = date.strftime("%Y%m")
csv_file_name = "#{CONFIG["app_name"]}_#{file_date}.csv"

system "BOTO_PATH=./secrets/.boto gsutil/gsutil cp -r gs://#{CONFIG["app_repo"]}/reviews/#{csv_file_name} ."


class Slack
  def self.notify(message)
    RestClient.post CONFIG["slack_url"], {
      payload:
      { text: message }.to_json
    },
    content_type: :json,
    accept: :json
  end
end

class Review
  def self.collection
    @collection ||= []
  end

  def self.send_reviews_from_date(date)
    message = collection.select do |r|
      r.submitted_at > date && (r.title || r.text)
    end.map do |r|
      r.build_message
    end.join("\n")

    if message != ""
      Slack.notify(message)
    else
      print "No new reviews\n"
    end
  end

  attr_accessor :text, :title, :submitted_at, :rate, :device, :url, :version

  def initialize data = {}
    @text = data[:text] ? data[:text].to_s.encode("utf-8") : nil
    @title = data[:title] ? "*#{data[:title].to_s.encode("utf-8")}*\n" : nil

    @submitted_at = DateTime.parse(data[:submitted_at].encode("utf-8"))

    @rate = data[:rate].encode("utf-8").to_i
    @device = data[:device] ? data[:device].to_s.encode("utf-8") : nil
    @url = data[:url].to_s.encode("utf-8")
    @version = data[:version].to_s.encode("utf-8")
  end

  def notify_to_slack
    if text || title
      message = "*Rating: #{rate}* | version: #{version} | subdate: #{submitted_at}\n #{[title, text].join(" ")}\n <#{url}|Ответить в Google play>"
      Slack.notify(message)
    end
  end

  def build_message
    [
      "\n\n~~~ #{rate.times.map{"★"}.join("")} ~~~ ",
      "Version: #{version} | subdate: #{submitted_at}",
      "#{[title, text].join(" ")}",
      "<#{url}|Ответить в Google play>"
    ].join("\n")
  end
end

CSV.foreach(csv_file_name, encoding: 'bom|utf-16le', headers: true) do |row|
  # If there is no reply - push this review
  if row[11].nil?
    Review.collection << Review.new({
      text: row[10],
      title: row[9],
      submitted_at: row[6],
      rate: row[8],
      device: row[3],
      url: row[14],
      version: row[1],
    })
  end
end

Review.send_reviews_from_date(date)
