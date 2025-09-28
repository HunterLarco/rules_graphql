load("@rules_graphql//graphql:defs.bzl", "graphql_bundle", "graphql_library")

graphql_library(
    name = "baz",
    srcs = ["Baz.graphql"],
)

graphql_library(
    name = "bar",
    srcs = ["Bar.graphql"],
    deps = [":baz"],
)

graphql_library(
    name = "foo",
    srcs = ["Foo.graphql"],
    deps = [":bar"],
)

graphql_library(
    name = "mutation",
    srcs = ["Mutation.graphql"],
    deps = [":foo"],
)

graphql_library(
    name = "query",
    srcs = ["Query.graphql"],
    deps = [":foo"],
)

graphql_library(
    name = "query_and_mutation",
    srcs = [
        "Mutation.graphql",
        "Query.graphql",
    ],
    deps = [":foo"],
)

graphql_bundle(
    name = "bundle_from_library",
    srcs = [":query_and_mutation"],
)

graphql_bundle(
    name = "bundle_from_files",
    srcs = [
        "Mutation.graphql",
        "Query.graphql",
    ],
    deps = [":foo"],
)

graphql_bundle(
    name = "bundle_from_files_and_library",
    srcs = [
        "Mutation.graphql",
        ":query",
    ],
)
