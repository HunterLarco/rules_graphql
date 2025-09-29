# Bazel rules for GraphQL

This ruleset is a Bazel integration for GraphQL, based on the excellent tools
provided by [The Guild].

[The Guild]: http://the-guild.dev/

`rules_graphql` is just one part of the wider bazel ecosystem. For additional
build rules we suggest visiting with [Bazel Central Registry] or consider
[Aspect]'s robust monorepo developer platform:

[Bazel Central Registry]: https://registry.bazel.build/
[Aspect]: https://www.aspect.build/

## Installation

Follow instructions from the release you wish to use:
<https://github.com/HunterLarco/rules_graphql/releases>.

## Usage

See the documentation in the [docs] folder.

[docs]: ./docs

## Examples

Basic usage examples can be found under the [examples] folder.

> Note that the examples also rely on code in the `/WORKSPACE` file in the root
> of this repo.

The [e2e] folder contains more complex and isolated examples demonstrating flow
such as a NodeJS GraphQL server.

[examples]: ./examples
[e2e]: ./e2e

## Design

GraphQL by design supports many runtimes (JavaScript, Rust, Java, etc...). We
decided that this ruleset would only support managing .graphql/.gql files and
*not* contain rules which transpile GraphQL into other languages. Our reasoning
was two-fold:

1. We want to avoid `rules_graphql` from pulling in many more dependencies than
   required for clients. If we were to support every GraphQL runtime, the
   `rules_graphql` package would have deep requirements for every project.
2. Many languages support multiple tools for transpiling GraphQL. We feel that
   individual projects should choose what's best for them, using `rules_graphql`
   as the base for their integration. We're not best qualified to select the
   universal GraphQL "best" stack for every language.

We hope that over time additional packages will be added such as
`rules_graphql_ts` to support specific languages and would be happy to help
anyone interested in contributing rules based on `graphql_rules`.

### What we do

Given that we are strictly focusing on GraphQL management, `rules_graphql`
primarily covers two useful responsibilities.

1. [`graphql_library`](./docs/graphql_library.md) ~ validates syntax and symbol
   resolution for any number of GraphQL files.
2. [`graphql_bundle`](./docs/graphql_bundle.md) ~ bundles GraphQL files or
   `graphql_library` targets into a single merged GraphQL file. Supports
   features such as tree-shaking to ensure graphs only contain reachable types.

Critically, both `graphql_library` and `graphql_bundle` contain their GraphQL
files and required transitive GraphQL dependencies in their runfiles so that
they can be included as [data dependencies] for most bazel rules—making it easy
to load GraphQL files into your application with all of their dependencies.

[data dependencies]: https://bazel.build/concepts/dependencies#data-dependencies
