load(":graphql_document_info.bzl", "GraphqlDocumentInfo", "gather_document_dependencies")
load(":graphql_info.bzl", "GRAPHQL_EXTENSIONS_WITH_PREFIX", "GraphqlInfo", "gather_all_dependencies", "gather_direct_sources")

_DOC = """
graphql_document_library groups together GraphQL documents (queries, mutations,
subscriptions, and fragments) and validates them against a schema. It arranges
the documents and their transitive fragment dependencies into a provided
`GraphqlDocumentInfo`.

Every document in "srcs" is checked for valid syntax and validated against the
schema formed by parsing all targets in "schema" together, ensuring each
referenced field, argument, and type exists. Fragments defined in other
documents are pulled in with `#import`, the same mechanism used by schema files.

Fragment libraries may be validated against a narrower schema than the
operations that use them. For example a shared fragment package might only
depend on the `users` portion of a graph while an operation importing it is
validated against the complete graph. For this reason the schema of a target and
the schema of its "deps" are never required to match; a fragment is re-validated
in the context of each operation that imports it.
"""

_ATTRS = {
    "srcs": attr.label_list(
        allow_files = GRAPHQL_EXTENSIONS_WITH_PREFIX,
        mandatory = True,
        allow_empty = False,
        doc = """Document files that are included in this library.

        Each file may contain operations, fragments, or both. Files must not
        contain schema (type system) definitions.

        This includes your checked-in code and any generated GraphQL files.
        """,
    ),
    "schema": attr.label_list(
        allow_files = GRAPHQL_EXTENSIONS_WITH_PREFIX,
        providers = [GraphqlInfo],
        mandatory = True,
        allow_empty = False,
        doc = """The schema to validate documents against.

        Accepts schema files, graphql_library targets, graphql_bundle targets,
        or other targets that provide GraphqlInfo. All targets are parsed
        together into a single schema, exactly as `graphql_bundle` would merge
        them: direct sources of each target are entry points and their
        transitive dependencies are made available for `#import` resolution.
        """,
    ),
    "deps": attr.label_list(
        providers = [GraphqlDocumentInfo],
        doc = """Document dependencies of this target.

        This may include other graphql_document_library targets or other
        targets that provide GraphqlDocumentInfo. Typically these are fragment
        libraries which documents in "srcs" `#import`.

        Dependencies need not share this target's "schema". A fragment library
        may be validated against a subset of the schema used here.

        The transitive sources & runfiles of targets in the `deps` attribute are
        added to the runfiles of this target. Their schema is not.
        """,
    ),
    "aliases": attr.string_dict(
        doc = """A series of entries which re-map imports to lookup locations.

        Keys are the aliases used in import statements, values are the paths
        they resolve to. Uses the same semantics as
        [`tsconfig.json#paths`](https://www.typescriptlang.org/tsconfig/#paths).

        Aliases apply to imports in both documents and schema.
        """,
    ),
    "_graphql_buddy": attr.label(
        executable = True,
        cfg = "exec",
        default = Label("//graphql/private:graphql-buddy"),
    ),
}

def _graphql_document_library_implementation(ctx):
    # Collect the schema. Entry points are passed to the validator and the
    # transitive closure is made available so that `#import` resolves.

    schema_sources = gather_direct_sources(ctx.attr.schema)
    schema_transitive_sources = gather_all_dependencies(ctx.attr.schema)

    # Collect fragment dependencies. Only document files are gathered; the
    # schema a dependency was validated against is intentionally excluded so
    # that every symbol used here must exist in this target's own schema.

    transitive_deps = gather_document_dependencies(ctx.attr.deps)

    # Run validation.

    validation_output = ctx.actions.declare_file(ctx.label.name + ".validation")

    arguments = ctx.actions.args()
    arguments.add("validate")
    arguments.add_all(schema_sources)
    arguments.add("--operations")
    arguments.add_all(ctx.files.srcs)
    arguments.add("--stamp", validation_output)
    arguments.add("--silent")
    for [key, value] in ctx.attr.aliases.items():
        arguments.add("--alias", "{}={}".format(key, value))

    ctx.actions.run(
        mnemonic = "ValidateGraphQLDocuments",
        executable = ctx.executable._graphql_buddy,
        arguments = [arguments],
        inputs = depset(
            ctx.files.srcs,
            transitive = [schema_transitive_sources, transitive_deps],
        ),
        outputs = [validation_output],
        env = {
            # Normally it's recommended to use `ctx.bin_dir.path` here but that
            # would require all of our input files to exist in bazel-bin which
            # our graphql files don't (because they're source code and not
            # compiled output). So instead we execute from the bazel execution
            # root which has access to both bazel-bin and any source files
            # passed in as inputs.
            "BAZEL_BINDIR": ".",
        },
    )

    # Form the build artifacts.

    return [
        DefaultInfo(
            files = depset(
                # For the `ValidateGraphQLDocuments` action to run, it needs to
                # be somewhere in the bazel graph. Since we don't want it in the
                # runfiles (included at runtime) it needs to be here as a file
                # exported by the rule.
                ctx.files.srcs + [validation_output],
                transitive = [transitive_deps],
            ),
            runfiles = ctx.runfiles(
                files = ctx.files.srcs,
                transitive_files = transitive_deps,
            ),
        ),
        GraphqlDocumentInfo(
            direct_sources = depset(ctx.files.srcs),
            transitive_sources = transitive_deps,
            schema = GraphqlInfo(
                direct_sources = schema_sources,
                transitive_sources = schema_transitive_sources,
            ),
        ),
    ]

graphql_document_library = rule(
    doc = _DOC,
    implementation = _graphql_document_library_implementation,
    provides = [DefaultInfo, GraphqlDocumentInfo],
    attrs = _ATTRS,
)
