load("@rules_graphql//graphql:defs.bzl", "graphql_library")

graphql_library(
    name = "api",
    srcs = glob(["*.graphql"]),
    aliases = {
        "//*": "examples/import_aliases/*",
    },
    deps = ["//examples/import_aliases/users"],
)
