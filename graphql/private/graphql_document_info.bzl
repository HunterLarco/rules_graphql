GraphqlDocumentInfo = provider(
    doc = """Encapsulates information about GraphQL documents (operations and
    fragments) provided by rules in rules_graphql and derivative rule sets.

    Documents are kept distinct from schema (see `GraphqlInfo`) so that a
    document target can never be mistaken for schema by rules such as
    `graphql_library` or `graphql_bundle`.
    """,
    fields = {
        "direct_sources": "Depset of document files (operations and fragments) which are directly exported by the target.",
        "transitive_sources": "Depset of document files which the target relies on either directly or transitively.",
        "transitive_schema": "Depset of schema files which the target relies on directly or transitively.",
    },
)

def gather_direct_sources(targets):
    """Given a list of targets, extracts all direct graphql document files.

    Args:
        targets: A list of `GraphQL` targets (typically from `graphql_document_library` or graphql document files).

    Returns:
        A list of file targets (source or generated).
    """

    sources = []
    for target in targets:
        if GraphqlDocumentInfo in target:
            graphql_info = target[GraphqlDocumentInfo]
            sources.append(graphql_info.direct_sources)
        elif DefaultInfo in target:
            default_info = target[DefaultInfo]
            sources.append(default_info.files)
        else:
            fail("Unsure how to gather target '{}'".format(target))

    return depset(transitive = sources)

def gather_all_document_dependencies(targets):
    """Given a list of targets, extracts all direct and transitively required graphql document files.

    Args:
        targets: A list of `GraphQL` targets (typically from `graphql_document_library` or graphql document files).

    Returns:
        A list of file targets (source or generated).
    """

    dependencies = []
    for target in targets:
        if GraphqlDocumentInfo in target:
            graphql_info = target[GraphqlDocumentInfo]
            dependencies.append(graphql_info.direct_sources)
            dependencies.append(graphql_info.transitive_sources)
        elif DefaultInfo in target:
            default_info = target[DefaultInfo]
            dependencies.append(default_info.files)
        else:
            fail("Unsure how to gather target '{}'".format(target))

    return depset(transitive = dependencies)

def gather_all_schema_dependencies(targets):
    """Given a list of targets, extracts all direct and transitively required graphql schema files.

    Args:
        targets: A list of `GraphQL` targets (typically from `graphql_document_library` or graphql schema files).

    Returns:
        A list of file targets (source or generated).
    """

    dependencies = []
    for target in targets:
        if GraphqlDocumentInfo in target:
            graphql_info = target[GraphqlDocumentInfo]
            dependencies.append(graphql_info.transitive_schema)
        elif DefaultInfo in target:
            default_info = target[DefaultInfo]
            dependencies.append(default_info.files)
        else:
            fail("Unsure how to gather target '{}'".format(target))

    return depset(transitive = dependencies)
