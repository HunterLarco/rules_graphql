load("@bazel_skylib//:bzl_library.bzl", "bzl_library")

package(default_visibility = ["//visibility:public"])

exports_files(glob(["*.bzl"]))

bzl_library(
    name = "defs",
    srcs = ["defs.bzl"],
    deps = [
        "//graphql/private:graphql_bundle",
        "//graphql/private:graphql_library",
    ],
)

bzl_library(
    name = "providers",
    srcs = ["providers.bzl"],
    deps = [
        "//graphql/private:graphql_info",
    ],
)
