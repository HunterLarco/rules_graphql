GraphqlInfo = provider(
    doc = "Encapsulates information provided by rules in rules_graphql and derivative rule sets",
    fields = {
        "direct_sources": "Depset of schema files which are directly exported by the target.",
        "transitive_sources": "Depset of schema files which the target relies on either directly or transitively.",
    },
)

# Acceptable extensions for graphql schema files.
GRAPHQL_EXTENSIONS = ["graphql", "gql"]
GRAPHQL_EXTENSIONS_WITH_PREFIX = [".{}".format(extension) for extension in GRAPHQL_EXTENSIONS]

def gather_direct_sources(targets):
    """Given a list of targets, extracts all direct graphql schema files.

    Args:
      targets:
        A list of `GraphQL` targets (typically from `graphql_library` or graphql
        schema files).

    Returns:
      A list of file targets (source or generated).
    """

    sources = []
    for target in targets:
        if GraphqlInfo in target:
            graphql_info = target[GraphqlInfo]
            sources.append(graphql_info.direct_sources)
        elif DefaultInfo in target:
            default_info = target[DefaultInfo]
            sources.append(default_info.files)
        else:
            fail("Unsure how to gather target '{}'".format(target))

    return depset(transitive = sources)

def gather_all_dependencies(targets):
    """Given a list of targets, extracts all direct and transitively required graphql schema files.

    Args:
      targets:
        A list of `GraphQL` targets (typically from `graphql_library` or graphql
        schema files).

    Returns:
      A list of file targets (source or generated).
    """

    dependencies = []
    for target in targets:
        if GraphqlInfo in target:
            graphql_info = target[GraphqlInfo]
            dependencies.append(graphql_info.direct_sources)
            dependencies.append(graphql_info.transitive_sources)
        elif DefaultInfo in target:
            default_info = target[DefaultInfo]
            dependencies.append(default_info.files)
        else:
            fail("Unsure how to gather target '{}'".format(target))

    return depset(transitive = dependencies)
