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

### Set up voice call forwarding
1. Follow [instrctions](https://www.twilio.com/docs/studio/tutorials/how-to-forward-calls) to create a Twilio Studio Widget that will forward voice calls to your Twilio number on to another phone number.
1. From the Twilio dashboard, click Phone Numbers
1. Click the phone number you want to forward calls from
1. Scroll down to Voice & Fax
1. Select Studio Flow from A Call Comes In left dropdown
1. Select your Twilio Studio Widget from A Call Comes In right dropdown
1. Test by calling your Twilio number from a phone number that's _not_ the one your formward Twilio incoming calls to
