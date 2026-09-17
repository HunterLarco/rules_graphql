load("@aspect_bazel_lib//lib:testing.bzl", "assert_outputs")
load("@bazel_skylib//rules:build_test.bzl", "build_test")
load("@rules_graphql//graphql:defs.bzl", "graphql_document_library")

package(default_visibility = ["//visibility:public"])

# A fragment-only library validated against a schema with no root types.
graphql_document_library(
    name = "CurrentUserFields",
    srcs = ["CurrentUserFields.graphql"],
    schema = ["//src/schema:CurrentUser"],
)

# Framents and operations parsed together against bundled schema.
graphql_document_library(
    name = "Me",
    srcs = [
        "CurrentUserFields.graphql",
        "Me.graphql",
    ],
    schema = ["//src/schema:bundle"],
    deps = [":CurrentUserFields"],
)

# Documents validated against multiple schema targets.
graphql_document_library(
    name = "Composite",
    srcs = ["Composite.graphql"],
    schema = [
        "//src/schema:CurrentUser",
        "//src/schema:PublicUser",
        "//src/schema:Query",
    ],
)

build_test(
    name = "document_library_test.build",
    targets = [
        ":CurrentUserFields",
        ":Me",
        ":Composite",
    ],
)
