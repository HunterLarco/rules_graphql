<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="graphql_library"></a>

## graphql_library

<pre>
load("@rules_graphql//graphql/private:graphql_library.bzl", "graphql_library")

graphql_library(<a href="#graphql_library-name">name</a>, <a href="#graphql_library-deps">deps</a>, <a href="#graphql_library-srcs">srcs</a>, <a href="#graphql_library-aliases">aliases</a>)
</pre>

graphql_library groups together GraphQL sources and arranges them and their
transitive dependencies into a provided `GraphqlInfo`. It additionally validates
syntax and ensures all symbols are defined for all files in "srcs".

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="graphql_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="graphql_library-deps"></a>deps |  Dependencies of this target.<br><br>This may include other graphql_library targets or other targets that provide GraphqlInfo.<br><br>The transitive sources & runfiles of targets in the `deps` attribute are added to the runfiles of this target.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="graphql_library-srcs"></a>srcs |  Source files that are included in this library.<br><br>This includes your checked-in code and any generated GraphQL files.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="graphql_library-aliases"></a>aliases |  A series of entries which re-map imports to lookup locations.<br><br>Keys are the aliases used in import statements, values are the paths they resolve to. Uses the same semantics as [`tsconfig.json#paths`](https://www.typescriptlang.org/tsconfig/#paths).<br><br>Supports two patterns:<br><br>1. Exact mapping: Maps a specific alias to a specific file    `'@user': '/path/to/user.graphql'`<br><br>2. Wildcard mapping: Maps a prefix pattern to a directory pattern using '*'<br><br>   2a. The '*' is replaced with the remainder of the import path        `'@models/*': '/path/to/models/*'`<br><br>   2b. Maps to a directory without wildcard expansion        `'@types/*': '/path/to/types'`<br><br>For example:<br><br><pre><code class="language-starlark">{&#10;  # Exact mapping&#10;  "@schema": "project/schema/main.graphql",&#10;&#10;  # Wildcard mapping with expansion&#10;  "@models/*": "project/graphql/models/*",&#10;&#10;  # Wildcard mapping without expansion&#10;  "@types/*": "project/graphql/types.graphql",&#10;}</code></pre><br><br>Import examples:<br><br>- `#import User from "@schema"` → `/project/schema/main.graphql` - `#import User from "@models/user.graphql"` → `/project/graphql/models/user.graphql` - `#import User from "@types/user.graphql"` → `/project/graphql/types.graphql`   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |


