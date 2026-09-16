load("@rules_graphql//graphql:defs.bzl", "graphql_document_library")

# Multiple schema targets are parsed together into a single schema, exactly as
# `graphql_bundle` would merge them.
graphql_document_library(
    name = "operations",
    srcs = glob(["*.graphql"]),
    schema = [
        "//examples/graphql_document_library/schema:mutation",
        "//examples/graphql_document_library/schema:query",
    ],
    deps = ["//examples/graphql_document_library/fragments"],
)
