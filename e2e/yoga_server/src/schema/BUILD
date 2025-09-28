load("@rules_graphql//graphql:defs.bzl", "graphql_bundle", "graphql_library")

package(default_visibility = ["//visibility:public"])

graphql_library(
    name = "CurrentUser",
    srcs = ["CurrentUser.graphql"],
)

graphql_library(
    name = "PublicUser",
    srcs = ["PublicUser.graphql"],
)

graphql_library(
    name = "Query",
    srcs = ["Query.graphql"],
    deps = [
      ":CurrentUser",
      ":PublicUser",
    ],
)

graphql_bundle(
    name = "bundle",
    srcs = [":Query"],
    tree_shake = True
)
