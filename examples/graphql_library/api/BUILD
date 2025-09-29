load("@rules_graphql//graphql:defs.bzl", "graphql_library")

graphql_library(
    name = "api",
    srcs = glob(["*.graphql"]),
    deps = ["//examples/graphql_library/users"],
)
