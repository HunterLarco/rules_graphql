GraphqlDocumentInfo = provider(
    doc = """Encapsulates information about GraphQL documents (operations and
    fragments) provided by rules in rules_graphql and derivative rule sets.

    Documents are kept distinct from schema (see `GraphqlInfo`) so that a
    document target can never be mistaken for schema by rules such as
    `graphql_library` or `graphql_bundle`.
    """,
    fields = {
        "direct_sources": "Depset of document files (operations and fragments) which are directly exported by the target.",
        "transitive_sources": "Depset of document files which the target relies on either directly or transitively, such as imported fragments.",
        "schema": """A `GraphqlInfo` describing the schema these documents were
        validated against. Its `direct_sources` are the schema entry points and
        its `transitive_sources` are every schema file reachable from them.

        This describes only this target's own schema. Fragment dependencies may
        have been validated against a different (typically narrower) schema.
        """,
    },
)

def gather_document_dependencies(targets):
    """Given a list of document targets, extracts all direct and transitively required document files.

    Args:
        targets: A list of targets providing `GraphqlDocumentInfo` (typically from `graphql_document_library`).

    Returns:
        A depset of file targets (source or generated).
    """

    dependencies = []
    for target in targets:
        if GraphqlDocumentInfo in target:
            document_info = target[GraphqlDocumentInfo]
            dependencies.append(document_info.direct_sources)
            dependencies.append(document_info.transitive_sources)
        else:
            fail("Unsure how to gather target '{}'".format(target))

    return depset(transitive = dependencies)
