<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="graphql_document_library"></a>

## graphql_document_library

<pre>
load("@rules_graphql//graphql/private:graphql_document_library.bzl", "graphql_document_library")

graphql_document_library(<a href="#graphql_document_library-name">name</a>, <a href="#graphql_document_library-deps">deps</a>, <a href="#graphql_document_library-srcs">srcs</a>, <a href="#graphql_document_library-aliases">aliases</a>, <a href="#graphql_document_library-schema">schema</a>)
</pre>

graphql_document_library groups together GraphQL documents (operations and
fragments) and arranges them and their transitive dependencies into a provided
`GraphqlDocumentInfo`. It additionally validates syntax and ensures all
documents match the provided schema.

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="graphql_document_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="graphql_document_library-deps"></a>deps |  Document dependencies of this target.<br><br>This may include other graphql_document_library targets or other targets that provide GraphqlDocumentInfo. Typically these are fragment libraries which documents in "srcs" `#import`.<br><br>The transitive sources of targets in the `deps` attribute are added to the runfiles of this target.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="graphql_document_library-srcs"></a>srcs |  Document files that are included in this library.<br><br>Each file may contain operations, fragments, or both. Files must not contain schema (type system) definitions.<br><br>Sources are always included in the runfiles of this target.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="graphql_document_library-aliases"></a>aliases |  A series of entries which re-map imports to lookup locations.<br><br>Keys are the aliases used in import statements, values are the paths they resolve to. Uses the same semantics as [`tsconfig.json#paths`](https://www.typescriptlang.org/tsconfig/#paths).<br><br>Aliases apply to imports in both documents and schema.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="graphql_document_library-schema"></a>schema |  The schema to validate documents against.<br><br>Accepts schema files, graphql_library targets, graphql_bundle targets, or other targets that provide GraphqlInfo.<br><br>The schema is never added to runfiles. Only graphql documents are accessible as runfiles from `graphql_document_library` targets.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |


