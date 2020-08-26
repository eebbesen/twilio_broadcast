
## Development
### Local setup
```bash
bin/rake db:setup
yarn install --check-files
bin/rails webpacker:install
```
### Running locally
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
