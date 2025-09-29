load("@rules_graphql_npm//:graphql-buddy/package_json.bzl", graphql_buddy_bin = "bin")
load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

exports_files(glob(["*.bzl"]))

graphql_buddy_bin.graphql_buddy_binary(
    name = "graphql-buddy",
)

bzl_library(
    name = "graphql_bundle",
    srcs = ["graphql_bundle.bzl"],
    deps = [ ":graphql_info" ]
)

bzl_library(
    name = "graphql_info",
    srcs = ["graphql_info.bzl"],
)

bzl_library(
    name = "graphql_library",
    srcs = ["graphql_library.bzl"],
    deps = [ ":graphql_info" ]
)
