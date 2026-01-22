# Repository Guidelines

Before finishing with every change:

- Run `just lint` to ensure code quality and consistency.

Don't ever run linters or formatters manually. Always use the provided `just` commands to maintain uniformity across the codebase.

Do not change or ignore any linting rules, you must fix the underlying issues instead. If there is already an ignore for a rule, you may leave it as is, but do not add new ignores.

## Coding guidelines

Keep your code absolutely simple and minimal. Avoid unnecessary abstractions, over-engineering, or complex patterns. Strive for clarity and maintainability in every line of code.
