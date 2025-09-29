load("@aspect_bazel_lib//lib:testing.bzl", "assert_outputs")
load("@bazel_skylib//rules:build_test.bzl", "build_test")
load("@bazel_skylib//rules:diff_test.bzl", "diff_test")
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

build_test(
  name = "library_test",
  targets = [":CurrentUser", ":PublicUser", ":Query"],
)

graphql_bundle(
    name = "bundle",
    srcs = [":Query"],
    tree_shake = True,
)

build_test(
  name = "bundle_test.build",
  targets = [":bundle"],
)

assert_outputs(
  name = "bundle_test.outputs",
  actual = ":bundle",
  expected = ["src/bundle.graphql"],
)

diff_test(
  name = "bundle_test.contents",
  file1 = ":bundle",
  file2 = "__goldens__/bundle.graphql",
)
