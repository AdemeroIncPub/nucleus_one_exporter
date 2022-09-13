module.exports = {
  // See config at https://github.com/conventional-changelog/commitlint/tree/master/@commitlint/config-conventional
  extends: ['@commitlint/config-conventional'],
  rules: {
    // Add scopes as needed
    'scope-enum': [2, 'always', [
      'cli',
      'gui',
      'lib',
    ]],
  },
  prompt: {
    settings: {
      enableMultipleScopes: true,
      scopeEnumSeparator: ','
    }
  }
};
