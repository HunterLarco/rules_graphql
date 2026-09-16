load("@aspect_bazel_lib//lib:testing.bzl", "assert_outputs")
load("@bazel_skylib//rules:build_test.bzl", "build_test")
load("@rules_graphql//graphql:defs.bzl", "graphql_document_library")

package(default_visibility = ["//visibility:public"])

# A fragment-only library validated against a schema with no root types.
graphql_document_library(
    name = "PublicUserFields",
    srcs = ["PublicUserFields.graphql"],
    schema = ["//src:PublicUser"],
)

# Multiple schema targets parsed together, plus a fragment dependency validated
# against a narrower schema.
graphql_document_library(
    name = "Users",
    srcs = ["Users.graphql"],
    schema = [
        "//src:PublicUser",
        "//src:Query",
    ],
    deps = [":PublicUserFields"],
)

# Documents validated against a bundle rather than a library.
graphql_document_library(
    name = "Me",
    srcs = ["Me.graphql"],
    schema = ["//src:bundle"],
)

build_test(
    name = "document_library_test.build",
    targets = [
        ":Me",
        ":PublicUserFields",
        ":Users",
    ],
)

assert_outputs(
    name = "document_library_test.outputs",
    actual = ":Users",
    expected = [
        "src/documents/PublicUserFields.graphql",
        "src/documents/Users.graphql",
        "src/documents/Users.validation",
    ],
)
