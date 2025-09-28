# graphql_library tests

It can be challenging to test build rules, at a high level we need to test that
different configurations of sources and dependencies build (and ideally that
some configurations don't build).

Right now our poor-man's way of achieving this is by adding a number of small
graphql projects in this directory which are expected to build. This doesn't
give us ways to test that some configurations _don't_ build but it's good enough
for a start and can catch many transitive dependency issues.
