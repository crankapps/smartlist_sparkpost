module SmartlistSparkpost
  class Transmissions

    def self.deliver(to, from_email, from_name, reply_to, subject, body, date = nil)
      data = SmartlistSparkpost::Transmissions.make_body(to, from_email, from_name, reply_to, subject, body, date)

      url = "https://api.sparkpost.com/api/#{SmartlistSparkpost.configuration.version}/transmissions?num_rcpt_errors=3"
      headers = {
          'Authorization' => SmartlistSparkpost.configuration.api_key,
          'Content-Type' => 'application/json'
      }
      response = HTTParty.post(url, {body: data.to_json, headers: headers})

      if response.code == 200
        JSON.parse(response.body)
      else
        SmartlistSparkpost::Transmissions.handle_error(response)
      end
    end

    def self.handle_error(response)
      if response['errors']
        @response = response['errors']
        raise SmartlistSparkpost::DeliveryException, @response
      end
    end

    def self.make_body(to, from_email, from_name, reply_to, subject, body, date=nil)
      data = {
          recipients: [
              {
                  address: to
              }
          ],
          options: {
              start_time: 'now',
              open_tracking: true,
              click_tracking: true
          },
          content: {
              from: {
                  email: from_email,
                  name: from_name
              },
              reply_to: reply_to,
              subject: subject,
              html: body
          }
      }
      if date.nil?
        data[:options][:start_time] = 'now'
      else
        data[:options][:start_time] = date.strftime("%Y-%m-%dT%H:%M:%S%:z")
      end

      data[:options][:open_tracking] = SmartlistSparkpost.configuration.track_opens
      data[:options][:click_tracking] = SmartlistSparkpost.configuration.track_clicks
      unless SmartlistSparkpost.configuration.ip_pool.nil?
        data[:options][:ip_pool] = SmartlistSparkpost.configuration.ip_pool
      end
      data
    end
  end
end