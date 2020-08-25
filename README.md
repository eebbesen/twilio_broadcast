
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

## Testing
### Unit tests
```bash
bin/rake
```

### Linting
```bash
rubocop
```
