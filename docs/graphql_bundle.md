<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="graphql_bundle"></a>

## graphql_bundle

<pre>
load("@rules_graphql//graphql/private:graphql_bundle.bzl", "graphql_bundle")

graphql_bundle(<a href="#graphql_bundle-name">name</a>, <a href="#graphql_bundle-deps">deps</a>, <a href="#graphql_bundle-srcs">srcs</a>, <a href="#graphql_bundle-aliases">aliases</a>, <a href="#graphql_bundle-tree_shake">tree_shake</a>)
</pre>



**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="graphql_bundle-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="graphql_bundle-deps"></a>deps |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="graphql_bundle-srcs"></a>srcs |  -   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="graphql_bundle-aliases"></a>aliases |  -   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="graphql_bundle-tree_shake"></a>tree_shake |  -   | Boolean | optional |  `False`  |


