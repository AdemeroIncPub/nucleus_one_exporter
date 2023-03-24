## Nucleus One Exporter

Use this CLI tool to export documents from a Nucleus One project to your local
machine. A GUI tool is expected to follow in the future.

For more information about Nucleus One, visit https://nucleus.one/.

## GUI Usage
- Generate an api key in your user profile in the Nucleus One web app.
- Ensure Flutter Version Manager ([FVM](https://fvm.app/)) is installed on your machine.
- Clone this repository to your machine.
- Open a terminal window to your cloned repository (to the same folder as this
  README.md).
- Install the Flutter SDK version found in project config:
  ```
  fvm install
  ```
- Get required dependencies:
  ```
  fvm flutter pub get
  ```
- Run the app:
  ```
  fvm flutter run -d windows
  ```

## CLI Usage
- FVM currently will not work with this CLI (https://github.com/fluttertools/fvm/issues/512).

  These directions will be updated to use FVM when the issue is resolved.
- Ensure the Dart or Flutter SDK is installed on your machine.
- Generate an api key in your user profile in the Nucleus One web app.
- Clone this repository to your machine.
- Open a terminal window to your cloned repository (to the same folder as this
  README.md).
- Get required dependencies:
  ```
  dart pub get
  ```
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
Follow the [GUI Usage](#gui-usage) directions to get setup.

Open this folder in VS Code or your favorite IDE.

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
fvm flutter test
```
