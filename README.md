A sample command-line application with an entrypoint in `bin/`, library code
in `lib/`, and example unit test in `test/`.

## Usage

## Development

### Pull Requests and Commits

Commit messages follow the [Conventional
Commits](https://www.conventionalcommits.org/en/v1.0.0/) format using the
[commitizen](https://commitizen.github.io/cz-cli/) npm package. Begin by
installing required npm packages:

```
npm install
```

To commit staged changes, run either `npx cz` or `npm run commit`. Or install
commitizen globally (`npm install -g commitizen`), then run `git cz`.

Note: IDE plugins may be available allowing properly formatted commit messages
to be written direclty in your editor.

### Testing
