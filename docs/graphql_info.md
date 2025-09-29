<!-- Generated with Stardoc: http://skydoc.bazel.build -->



<a id="GraphqlInfo"></a>

## GraphqlInfo

<pre>
load("@rules_graphql//graphql/private:graphql_info.bzl", "GraphqlInfo")

GraphqlInfo(<a href="#GraphqlInfo-direct_sources">direct_sources</a>, <a href="#GraphqlInfo-transitive_sources">transitive_sources</a>)
</pre>

Encapsulates information provided by rules in rules_graphql and derivative rule sets

**FIELDS**

| Name  | Description |
| :------------- | :------------- |
| <a id="GraphqlInfo-direct_sources"></a>direct_sources |  Depset of schema files which are directly exported by the target.    |
| <a id="GraphqlInfo-transitive_sources"></a>transitive_sources |  Depset of schema files which the target relies on either directly or transitively.    |


<a id="gather_all_dependencies"></a>

## gather_all_dependencies

<pre>
load("@rules_graphql//graphql/private:graphql_info.bzl", "gather_all_dependencies")

gather_all_dependencies(<a href="#gather_all_dependencies-targets">targets</a>)
</pre>

Given a list of targets, extracts all direct and transitively required graphql schema files.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="gather_all_dependencies-targets"></a>targets |  A list of `GraphQL` targets (typically from `graphql_library` or graphql schema files).   |  none |

**RETURNS**

A list of file targets (source or generated).


<a id="gather_direct_sources"></a>

## gather_direct_sources

<pre>
load("@rules_graphql//graphql/private:graphql_info.bzl", "gather_direct_sources")

gather_direct_sources(<a href="#gather_direct_sources-targets">targets</a>)
</pre>

Given a list of targets, extracts all direct graphql schema files.

**PARAMETERS**


| Name  | Description | Default Value |
| :------------- | :------------- | :------------- |
| <a id="gather_direct_sources-targets"></a>targets |  A list of `GraphQL` targets (typically from `graphql_library` or graphql schema files).   |  none |

**RETURNS**

A list of file targets (source or generated).


