
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
