## Nucleus One Exporter

Use this CLI tool to export documents from a Nucleus One project to your local
machine. A GUI tool is expected to follow in the future.

For more information about Nucleus One, visit https://nucleus.one/.

## GUI Usage
- Ensure the Flutter SDK is installed on your machine.
- TODO(apn)

## CLI Usage
- Ensure the Dart or Flutter SDK is installed on your machine.
- Clone this repository to your machine.
- Open a terminal window to your cloned repository (to the same folder as this
  README.md).
- Get required dependencies:
  ```
  dart pub get
  ```
- Generate an api key in your user profile in the Nucleus One web app.
- Set your api key:
  ```
  dart run .\bin\nucleus_one_exporter.dart api-key set <your api key>
  ```
- You'll need an Organization ID and a Project ID to do an export. You can list
  them with:
  ```
  dart run .\bin\nucleus_one_exporter.dart info
  ```
- Run the export specifying a destination path:
  ```
  dart run .\bin\nucleus_one_exporter.dart export -o <your organization id> -p <your project id> -d <local path>
  ```
- See --help for more options, including subcommands:
  ```
  dart run .\bin\nucleus_one_exporter.dart -h
  dart run .\bin\nucleus_one_exporter.dart export -h

  ```

## Development
Ensure the Flutter SDK is installed on your machine.

### Pull Requests and Commits

Commit messages follow the [Conventional
Commits](https://www.conventionalcommits.org/en/v1.0.0/) format using the
[commitizen](https://commitizen.github.io/cz-cli/) npm package. Begin by
installing required npm packages:
```
npm install
```

To commit staged changes, run either `npx cz` or `npm run commit`. Or install
commitizen globally (`npm install -g commitizen`) then run `git cz`.

Note: IDE plugins may be available allowing properly formatted commit messages
to be written direclty in your editor.

### Testing

```
flutter test
```
