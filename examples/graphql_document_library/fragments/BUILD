load("@rules_graphql//graphql:defs.bzl", "graphql_document_library")

# Fragments only need the type definitions they select from; the schema need
# not define any root types. Operations which import these fragments may be
# validated against a larger schema, such as
# `//examples/graphql_document_library/operations`.
graphql_document_library(
    name = "fragments",
    srcs = glob(["*.graphql"]),
    schema = ["//examples/graphql_document_library/schema:users"],
    visibility = ["//examples/graphql_document_library:__subpackages__"],
)
