<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="graphql_document_library"></a>

## graphql_document_library

<pre>
load("@rules_graphql//graphql/private:graphql_document_library.bzl", "graphql_document_library")

graphql_document_library(<a href="#graphql_document_library-name">name</a>, <a href="#graphql_document_library-deps">deps</a>, <a href="#graphql_document_library-srcs">srcs</a>, <a href="#graphql_document_library-aliases">aliases</a>, <a href="#graphql_document_library-schema">schema</a>)
</pre>

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

**ATTRIBUTES**


| Name  | Description | Type | Mandatory | Default |
| :------------- | :------------- | :------------- | :------------- | :------------- |
| <a id="graphql_document_library-name"></a>name |  A unique name for this target.   | <a href="https://bazel.build/concepts/labels#target-names">Name</a> | required |  |
| <a id="graphql_document_library-deps"></a>deps |  Document dependencies of this target.<br><br>This may include other graphql_document_library targets or other targets that provide GraphqlDocumentInfo. Typically these are fragment libraries which documents in "srcs" `#import`.<br><br>Dependencies need not share this target's "schema". A fragment library may be validated against a subset of the schema used here.<br><br>The transitive sources & runfiles of targets in the `deps` attribute are added to the runfiles of this target. Their schema is not.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | optional |  `[]`  |
| <a id="graphql_document_library-srcs"></a>srcs |  Document files that are included in this library.<br><br>Each file may contain operations, fragments, or both. Files must not contain schema (type system) definitions.<br><br>This includes your checked-in code and any generated GraphQL files.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |
| <a id="graphql_document_library-aliases"></a>aliases |  A series of entries which re-map imports to lookup locations.<br><br>Keys are the aliases used in import statements, values are the paths they resolve to. Uses the same semantics as [`tsconfig.json#paths`](https://www.typescriptlang.org/tsconfig/#paths).<br><br>Aliases apply to imports in both documents and schema.   | <a href="https://bazel.build/rules/lib/dict">Dictionary: String -> String</a> | optional |  `{}`  |
| <a id="graphql_document_library-schema"></a>schema |  The schema to validate documents against.<br><br>Accepts schema files, graphql_library targets, graphql_bundle targets, or other targets that provide GraphqlInfo. All targets are parsed together into a single schema, exactly as `graphql_bundle` would merge them: direct sources of each target are entry points and their transitive dependencies are made available for `#import` resolution.   | <a href="https://bazel.build/concepts/labels">List of labels</a> | required |  |


