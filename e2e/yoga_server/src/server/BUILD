load("@aspect_rules_ts//ts:defs.bzl", "ts_project")
load("@aspect_rules_js//js:defs.bzl", "js_binary")

ts_project(
		name = "main",
		srcs = ["main.ts"],
		declaration = True,
		source_map = True,
		tsconfig = "//:tsconfig",
		deps = [
				"//:node_modules/graphql-yoga",
        "//:node_modules/@types/node",
        "//:node_modules/tslib",
		],
		data = [
        "//src/schema:bundle",
		],
)

js_binary(
    name = "server",
    data = [":main"],
    entry_point = ":main.js",
)
