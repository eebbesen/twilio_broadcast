![Rails tests](https://github.com/eebbesen/twilio_broadcast/workflows/Rails%20tests/badge.svg)


## Development
### Local setup
```bash
bin/rake db:setup
yarn install --check-files
bin/rails webpacker:install
```
### Running locally
You only need to run the seeds once after building/rebuilding the database.
```bash
bin/rails db:seed
bin/rails server
```

http://localhost:3000

In the local environment a test user has been created: user@tb.tb.moc / Passw0rd!

## Testing
### Unit tests
```bash
bin/rake
```

### Linting
```bash
rubocop
```

## Deployment
### Variables
* `TWILIO_ACCOUNT_SID`
* `TWILIO_AUTH_TOKEN`
* `TWILIO_FROM_PHONE_NUMBER`
** can be a message service SID or a phone number
* `TWILIO_STATUS_CALLBACK`
** optional, but required for status updates
** set to the base URL of your application (e.g., https://your-app.herokuapp.com)

### Heroku
1. Push desired branch to Heroku
* `git push heroku main`
1. Run migrations
* `heroku run bin/rails db:migrate`

### Twilio
#### Set up voice call forwarding
These instructions show you how to forward calls to your Twilio number to another phone (landline or mobile). Call forwarding does not involve twilio_broadcast in any way and is entirely handled by Twilio.

1. Follow [instrctions](https://www.twilio.com/docs/studio/tutorials/how-to-forward-calls) to create a Twilio Studio Widget that will forward voice calls to your Twilio number on to another phone number.
1. From the Twilio dashboard, click Phone Numbers
1. Click the phone number you want to forward calls from
1. Scroll down to Voice & Fax
1. Select Studio Flow from A Call Comes In left dropdown
1. Select your Twilio Studio Widget from A Call Comes In right dropdown
1. Test by calling your Twilio number from a phone number that's _not_ the one your formward Twilio incoming calls to

#### Set up incoming subscriptions
Unlike incoming calls, twilio_broadcast handles incoming SMS messages. twilio_broadcast needs to be involved in the incoming SMS message process if you allow people to text your number to subscribe to recipient lists. This is a two-step process

*Associate a keyword with your recipient list on the recipient list create or edit page*
Hopefully self-explanatory

*Configure your Twilio number to send incoming SMS messages to your twilio_broadcast instance*
https://www.twilio.com/docs/sms/tutorials/how-to-receive-and-reply-ruby
1. Browse to https://www.twilio.com/console
1. Select the hash mark/pound sign in the upper left to navigate to your phone numbers
1. Click the number you are using for twilio_broadcast
1. Under Messaging, select Webhooks, TwiML Bins, Functions, Studio or Proxy from the Configure With dropdown
1. Select Webhook from the A Message Comes In dropdown
1. Enter your twilio_broadcast application URL followed by `/subscribe` in the text box to the right of the dropdown (e.g., `https://supc-broadcast-test.herokuapp.com/subscribe`)
1. Click Save
