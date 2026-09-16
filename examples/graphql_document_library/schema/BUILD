load("@rules_graphql//graphql:defs.bzl", "graphql_library")

package(default_visibility = ["//examples/graphql_document_library:__subpackages__"])

graphql_library(
    name = "users",
    srcs = [
        "CurrentUser.graphql",
        "PublicUser.graphql",
    ],
)

graphql_library(
    name = "query",
    srcs = ["Query.graphql"],
    deps = [":users"],
)

graphql_library(
    name = "mutation",
    srcs = ["Mutation.graphql"],
    deps = [":users"],
)
