load(
    ":graphql_document_info.bzl",
    "GraphqlDocumentInfo",
    "gather_all_document_dependencies",
    "gather_all_schema_dependencies",
)
load(
    ":graphql_info.bzl",
    "GRAPHQL_EXTENSIONS_WITH_PREFIX",
    "GraphqlInfo",
    graphql_info_gather_all_dependencies = "gather_all_dependencies",
    graphql_info_gather_direct_sources = "gather_direct_sources",
)

_DOC = """
graphql_document_library groups together GraphQL documents (operations and
fragments) and arranges them and their transitive dependencies into a provided
`GraphqlDocumentInfo`. It additionally validates syntax and ensures all
documents match the provided schema.
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
        or other targets that provide GraphqlInfo.

        The transitive schema of targets in the `schema` attribute are added to
        the runfiles of this target.
        """,
    ),
    "deps": attr.label_list(
        providers = [GraphqlDocumentInfo],
        doc = """Document dependencies of this target.

        This may include other graphql_document_library targets or other
        targets that provide GraphqlDocumentInfo. Typically these are fragment
        libraries which documents in "srcs" `#import`.

        The transitive sources and schema of targets in the `deps` attribute are
        added to the runfiles of this target.
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
    # Collect a list of all transitive dependencies

    deps_transitive_documents = gather_all_document_dependencies(ctx.attr.deps)
    deps_transitive_schema = gather_all_schema_dependencies(ctx.attr.deps)
    schema_transitive_schema = graphql_info_gather_all_dependencies(ctx.attr.schema)

    # Run validation.

    validation_output = ctx.actions.declare_file(ctx.label.name + ".validation")

    arguments = ctx.actions.args()
    arguments.add("validate")
    arguments.add_all(graphql_info_gather_direct_sources(ctx.attr.schema))
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
            transitive = [
                deps_transitive_documents,
                deps_transitive_schema,
                schema_transitive_schema,
            ],
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
                transitive = [
                    deps_transitive_documents,
                    deps_transitive_schema,
                    schema_transitive_schema,
                ],
            ),
            runfiles = ctx.runfiles(
                files = ctx.files.srcs,
                transitive_files = depset(transitive = [
                    deps_transitive_documents,
                    deps_transitive_schema,
                    schema_transitive_schema,
                ]),
            ),
        ),
        GraphqlDocumentInfo(
            direct_sources = depset(ctx.files.srcs),
            transitive_sources = deps_transitive_documents,
            transitive_schema = depset(
                transitive = [deps_transitive_schema, schema_transitive_schema],
            ),
        ),
    ]

graphql_document_library = rule(
    doc = _DOC,
    implementation = _graphql_document_library_implementation,
    provides = [DefaultInfo, GraphqlDocumentInfo],
    attrs = _ATTRS,
)
