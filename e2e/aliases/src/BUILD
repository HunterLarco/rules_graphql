load("@rules_graphql//graphql:defs.bzl", "graphql_bundle", "graphql_library")

aliases = {
    "@/*": "src/*",
    "custom-bar-import": "src/Bar.graphql",
}

graphql_library(
    name = "foo",
    srcs = ["Foo.graphql"],
    aliases = aliases,
    deps = [":bar"],
)

graphql_library(
    name = "bar",
    srcs = ["Bar.graphql"],
    aliases = aliases,
)

graphql_library(
    name = "query",
    srcs = ["Query.graphql"],
    aliases = aliases,
    deps = [":foo"],
)

graphql_bundle(
    name = "bundle",
    srcs = [":query"],
    aliases = aliases,
)
