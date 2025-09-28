load(":graphql_info.bzl", "GRAPHQL_EXTENSIONS_WITH_PREFIX", "GraphqlInfo", "gather_all_dependencies")

def _graphql_library_implementation(ctx):
    # Collect a list of all transitive dependencies.

    transitive_deps = gather_all_dependencies(ctx.attr.deps)

    # Run validation.

    validation_output = ctx.actions.declare_file(ctx.label.name + ".validation")

    arguments = ctx.actions.args()
    arguments.add("validate")
    arguments.add_all(ctx.files.srcs)
    arguments.add("--stamp", validation_output)
    arguments.add("--silent")
    for [key, value] in ctx.attr.aliases.items():
        arguments.add("--alias", "{}={}".format(key, value))

    ctx.actions.run(
        mnemonic = "ValidateGraphQL",
        executable = ctx.executable._graphql_buddy,
        arguments = [arguments],
        inputs = depset(ctx.files.srcs, transitive = [transitive_deps]),
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
                # For the `ValidateGraphQL` action to run, it needs to be
                # somewhere in the bazel graph. Since we don't want it in the
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
        GraphqlInfo(
            direct_sources = depset(ctx.files.srcs),
            transitive_sources = transitive_deps,
        ),
    ]

graphql_library = rule(
    implementation = _graphql_library_implementation,
    provides = [DefaultInfo, GraphqlInfo],
    attrs = {
        "srcs": attr.label_list(allow_files = GRAPHQL_EXTENSIONS_WITH_PREFIX),
        "deps": attr.label_list(providers = [GraphqlInfo]),
        "aliases": attr.string_dict(),
        "_graphql_buddy": attr.label(
            executable = True,
            cfg = "exec",
            default = "//graphql/private:graphql-buddy",
        ),
    },
)
