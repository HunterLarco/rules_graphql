<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="graphql_bundle"></a>

## graphql_bundle

<pre>
load("@rules_graphql//graphql/private:graphql_bundle.bzl", "graphql_bundle")

graphql_bundle(<a href="#graphql_bundle-name">name</a>, <a href="#graphql_bundle-deps">deps</a>, <a href="#graphql_bundle-srcs">srcs</a>, <a href="#graphql_bundle-aliases">aliases</a>, <a href="#graphql_bundle-tree_shake">tree_shake</a>)
</pre>

graphq_bundle merges multiple GraphQL files and/or targets into a single file.
It's a critical step for resolving GraphQL imports which are not supported by
all runtimes.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="graphql_bundle-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="graphql_bundle-deps"></a>deps |  Dependencies of this target.<br><br>This may include other graphql_library targets or other targets that provide GraphqlInfo.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="graphql_bundle-srcs"></a>srcs |  Source files, graphql_library targets, graphql_bundle targets, or other targets that provide GraphqlInfo.<br><br>The generated bundle will include all symbols from files and direct sources of graphql targets. Transitive dependencies are made available for GraphQL imports but are not automatically added to the bundle unless included in the dependency tree starting with the direct sources.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="graphql_bundle-aliases"></a>aliases |  A series of entries which re-map imports to lookup locations.<br><br>Keys are the aliases used in import statements, values are the paths they resolve to. Uses the same semantics as [`tsconfig.json#paths`](https://www.typescriptlang.org/tsconfig/#paths).   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="graphql_bundle-tree_shake"></a>tree_shake |  If enabled, any types unreachable from GraphQL's root types (Query, Mutation, and Subscription) will be pruned.   | Boolean | optional |  `False`  |


