"""Providers for building derivative rules"""

load("//graphql/private:graphql_document_info.bzl", _GraphqlDocumentInfo = "GraphqlDocumentInfo")
load("//graphql/private:graphql_info.bzl", _GraphqlInfo = "GraphqlInfo")

GraphqlDocumentInfo = _GraphqlDocumentInfo
GraphqlInfo = _GraphqlInfo
