Logstash Plugin for Pushover output
===

This is a plugin for [logstash](https://www.elastic.co/products/logstash) to send events to [Pushover](https://pushover.net). It's not an official Pushover-service.

Usage
---

There are two required parameters that need to be set, so at the very least the
following is required:

    output {
		pushover {
			app_token => "YOUR_UNIQUE_APP_TOKEN"
			user_key => "RECEIVERS_UNIQUE_USER_KEY"
		}
	}

No futher configuration parameters that are listed on [the API specification](https://pushover.net/api)
are currently enabled.

ToDo
---

- Wire-up additional configuration parameters
- tests :)

Copyright
---

- 2015 Jasper Lievisse Adriaanse <j@jasper.la>

Contributing
---

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request