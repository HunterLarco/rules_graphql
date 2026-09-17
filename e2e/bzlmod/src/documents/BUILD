load("@bazel_skylib//rules:build_test.bzl", "build_test")
load("@rules_graphql//graphql:defs.bzl", "graphql_document_library")
load("//build_rules:runfiles_test.bzl", "runfiles_test")

package(default_visibility = ["//visibility:public"])

# A fragment-only library validated against a schema with no root types.
graphql_document_library(
    name = "CurrentUserFields",
    srcs = ["CurrentUserFields.graphql"],
    schema = ["//src/schema:CurrentUser"],
)

# Framents and operations parsed together against bundled schema.
graphql_document_library(
    name = "Me.srcsOnly",
    srcs = [
        "CurrentUserFields.graphql",
        "Me.graphql",
    ],
    schema = ["//src/schema:bundle"],
)

# A operation parsed with a fragment dependency.
graphql_document_library(
    name = "Me.withDeps",
    srcs = ["Me.graphql"],
    schema = ["//src/schema:Query"],
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
        ":Me.srcsOnly",
        ":Me.withDeps",
        ":Composite",
    ],
)

# Runfiles carry documents only. Schema is validated against at build time but
# never shipped at runtime.
runfiles_test(
    name = "CurrentUserFields.runfiles_test",
    expected = ["src/documents/CurrentUserFields.graphql"],
    target_under_test = ":CurrentUserFields",
)

runfiles_test(
    name = "Me.srcsOnly.runfiles_test",
    expected = [
        "src/documents/CurrentUserFields.graphql",
        "src/documents/Me.graphql",
    ],
    target_under_test = ":Me.srcsOnly",
)

runfiles_test(
    name = "Me.withDeps.runfiles_test",
    expected = [
        "src/documents/CurrentUserFields.graphql",
        "src/documents/Me.graphql",
    ],
    target_under_test = ":Me.withDeps",
)

runfiles_test(
    name = "Composite.runfiles_test",
    expected = ["src/documents/Composite.graphql"],
    target_under_test = ":Composite",
)
