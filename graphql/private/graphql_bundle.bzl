load("//graphql/private:graphql_info.bzl", "GRAPHQL_EXTENSIONS_WITH_PREFIX", "GraphqlInfo", "gather_all_dependencies", "gather_direct_sources")

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
    implementation = _graphql_bundle_implementation,
    provides = [DefaultInfo, GraphqlInfo],
    attrs = {
        "srcs": attr.label_list(
            allow_files = GRAPHQL_EXTENSIONS_WITH_PREFIX,
            providers = [GraphqlInfo],
        ),
        "deps": attr.label_list(providers = [GraphqlInfo]),
        "aliases": attr.string_dict(),
        "tree_shake": attr.bool(default = False),
        "_graphql_buddy": attr.label(
            executable = True,
            cfg = "exec",
            default = "//graphql/private:graphql-buddy",
        ),
    },
)
