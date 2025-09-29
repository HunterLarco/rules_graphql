load(":graphql_info.bzl", "GRAPHQL_EXTENSIONS_WITH_PREFIX", "GraphqlInfo", "gather_all_dependencies")

_DOC = """
js_library groups together GraphQL sources and arranges them and their
transitive dependencies into a provided `GraphqlInfo`. It additionally validates
syntax and ensures all symbols are defined for all files in "srcs".
"""

_ATTRS = {
    "srcs": attr.label_list(
        allow_files = GRAPHQL_EXTENSIONS_WITH_PREFIX,
        doc = """Source files that are included in this library.

        This includes your checked-in code and any generated GraphQL files.
        """,
    ),
    "deps": attr.label_list(
        providers = [GraphqlInfo],
        doc = """Dependencies of this target.

        This may include other graphql_library targets or other targets that
        provide GraphqlInfo.

        The transitive sources & runfiles of targets in the `deps` attribute are
        added to the runfiles of this target.
        """,
    ),
    "aliases": attr.string_dict(
        doc = """A series of entries which re-map imports to lookup locations.

        Keys are the aliases used in import statements, values are the paths
        they resolve to. Uses the same semantics as
        [`tsconfig.json#paths`](https://www.typescriptlang.org/tsconfig/#paths).

        Supports two patterns:

        1. Exact mapping: Maps a specific alias to a specific file
           `'@user': '/path/to/user.graphql'`
        2. Wildcard mapping: Maps a prefix pattern to a directory pattern using '*'
           2a. The '*' is replaced with the remainder of the import path
               `'@models/*': '/path/to/models/*'`
           2b. Maps to a directory without wildcard expansion
               `'@types/*': '/path/to/types'`

        For example:
   
        ```starlark
        {
          # Exact mapping
          "@schema": "project/schema/main.graphql",
     
          # Wildcard mapping with expansion
          "@models/*": "project/graphql/models/*",
     
          # Wildcard mapping without expansion
          "@types/*": "project/graphql/types.graphql",
        }
        ```
       
        Import examples:
        - `#import User from "@schema"` → `/project/schema/main.graphql`
        - `#import User from "@models/user.graphql"` → `/project/graphql/models/user.graphql`
        - `#import User from "@types/user.graphql"` → `/project/graphql/types.graphql`
        """,
    ),
    "_graphql_buddy": attr.label(
        executable = True,
        cfg = "exec",
        default = Label("//graphql/private:graphql-buddy"),
    ),
}

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
    doc = _DOC,
    implementation = _graphql_library_implementation,
    provides = [DefaultInfo, GraphqlInfo],
    attrs = _ATTRS,
)
