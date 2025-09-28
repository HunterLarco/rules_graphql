load("@aspect_rules_js//js:defs.bzl", "js_library")
load("@npm//:defs.bzl", "npm_link_all_packages")

# A workaround for gazelle.
#
# See https://github.com/aspect-build/aspect-cli/issues/560
npm_link_all_packages(name = "node_modules")

alias(
    name = "format",
    actual = "//tools/format",
)

alias(
    name = "format.check",
    actual = "//tools/format:format.check",
)
