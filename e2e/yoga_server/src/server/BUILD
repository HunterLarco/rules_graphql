load("@aspect_rules_js//js:defs.bzl", "js_binary")
load("@aspect_rules_ts//ts:defs.bzl", "ts_project")

ts_project(
    name = "main",
    srcs = ["main.ts"],
    data = [
        "//src/schema:bundle",
    ],
    declaration = True,
    source_map = True,
    tsconfig = "//:tsconfig",
    deps = [
        "//:node_modules/@types/node",
        "//:node_modules/graphql-yoga",
        "//:node_modules/tslib",
    ],
)

js_binary(
    name = "server",
    data = [":main"],
    entry_point = ":main.js",
)
