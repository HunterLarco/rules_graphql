load("@rules_graphql//graphql:defs.bzl", "graphql_library")

graphql_library(
    name = "users",
    srcs = glob(["*.graphql"]),
    visibility = ["//examples/import_aliases:__subpackages__"],
)
