load("//graphql/private:graphql_info.bzl", "GRAPHQL_EXTENSIONS_WITH_PREFIX", "GraphqlInfo", "gather_all_dependencies", "gather_direct_sources")

_DOC = """
graphq_bundle merges multiple GraphQL files and/or targets into a single file.
It's a critical step for resolving GraphQL imports which are not supported by
all runtimes.
"""

_ATTRS = {
    "srcs": attr.label_list(
        allow_files = GRAPHQL_EXTENSIONS_WITH_PREFIX,
        providers = [GraphqlInfo],
        doc = """Source files, graphql_library targets, graphql_bundle targets,
        or other targets that provide GraphqlInfo.

        The generated bundle will include all symbols from files and direct
        sources of graphql targets. Transitive dependencies are made available 
        for GraphQL imports but are not automatically added to the bundle unless
        included in the dependency tree starting with the direct sources.
        """,
    ),
    "deps": attr.label_list(
        providers = [GraphqlInfo],
        doc = """Dependencies of this target.

        This may include other graphql_library targets or other targets that
        provide GraphqlInfo.
        """,
    ),
    "aliases": attr.string_dict(
        doc = """A series of entries which re-map imports to lookup locations.

        Keys are the aliases used in import statements, values are the paths
        they resolve to. Uses the same semantics as
        [`tsconfig.json#paths`](https://www.typescriptlang.org/tsconfig/#paths).
        """,
    ),
    "tree_shake": attr.bool(
        default = False,
        doc = """If enabled, any types unreachable from GraphQL's root types
        (Query, Mutation, and Subscription) will be pruned.
        """
    ),
    "_graphql_buddy": attr.label(
        executable = True,
        cfg = "exec",
        default = "//graphql/private:graphql-buddy",
    ),
}

def _graphql_bundle_implementation(ctx):
    # Collect a list of all transitive dependencies.

    sources = gather_direct_sources(ctx.attr.srcs)
    transitive_deps = gather_all_dependencies(ctx.attr.srcs + ctx.attr.deps)

    # Run bundler.

    merged_output = ctx.actions.declare_file(ctx.label.name + ".graphql")

    arguments = ctx.actions.args()
    arguments.add("bundle")
    arguments.add_all(sources)
    arguments.add("--out", merged_output)
    arguments.add("--silent")
    for key, value in ctx.attr.aliases.items():
        arguments.add("--alias", "{}={}".format(key, value))
    if not ctx.attr.tree_shake:
        arguments.add("--no-shake")

    ctx.actions.run(
        mnemonic = "BundleGraphQL",
        executable = ctx.executable._graphql_buddy,
        arguments = [arguments],
        inputs = depset(transitive = [sources, transitive_deps]),
        outputs = [merged_output],
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
            files = depset([merged_output]),
            runfiles = ctx.runfiles(files = [merged_output]),
        ),
        GraphqlInfo(
            direct_sources = depset([merged_output]),
            transitive_sources = depset(),
        ),
    ]

graphql_bundle = rule(
    doc = _DOC,
    implementation = _graphql_bundle_implementation,
    provides = [DefaultInfo, GraphqlInfo],
    attrs = _ATTRS,
)
