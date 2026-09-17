"""Analysis test asserting the exact runfiles of a target."""

load("@bazel_skylib//lib:unittest.bzl", "analysistest", "asserts")

def _runfiles_test_impl(ctx):
    env = analysistest.begin(ctx)
    target = analysistest.target_under_test(env)

    actual = sorted([
        file.short_path
        for file in target[DefaultInfo].default_runfiles.files.to_list()
    ])
    asserts.equals(env, sorted(ctx.attr.expected), actual)

    return analysistest.end(env)

runfiles_test = analysistest.make(
    _runfiles_test_impl,
    attrs = {
        "expected": attr.string_list(
            mandatory = True,
            doc = "Workspace-relative paths of every file expected in the target's runfiles.",
        ),
    },
)
