# Description:
#  Base utilities and types used throughout the XRTL library.

package(default_visibility = ["//xrtl:internal"])

licenses(["notice"])  # Apache 2.0

load("//xrtl/testing:portable_testing.bzl", "portable_cc_test")

cc_library(
    name = "arena",
    srcs = ["arena.cc"],
    hdrs = ["arena.h"],
    deps = [
        ":logging",
        ":macros",
        ":math",
    ],
)

portable_cc_test(
    name = "arena_test",
    size = "small",
    srcs = ["arena_test.cc"],
    deps = [
        ":arena",
        "//xrtl/testing:gtest_main",
    ],
)

# CLI main() entry point.
# This is linked in to CLI cc_binaries.
cc_library(
    name = "cli_main",
    srcs = ["cli_main.cc"],
    hdrs = ["cli_main.h"],
    deps = [
        ":platform_cli_main",
        "//xrtl/base:debugging",
        "//xrtl/base:flags",
        "//xrtl/base:logging",
    ],
    alwayslink = 1,
)

cc_library(
    name = "cli_main_hdrs",
    hdrs = ["cli_main.h"],
    visibility = ["//xrtl/port:ports_only"],
)

cc_library(
    name = "platform_cli_main",
    visibility = ["//visibility:private"],
    deps = [
        "//xrtl/port/common/base:posix_cli_main",
    ],
)

cc_library(
    name = "debugging",
    srcs = ["debugging.cc"],
    hdrs = ["debugging.h"],
    deps = [
        ":macros",
        "//xrtl/tools/target_platform",
    ] + select({
        "//xrtl/tools/target_platform:ios": [
            "//xrtl/port/apple/base:darwin_debugging",
        ],
        "//xrtl/tools/target_platform:macos": [
            "//xrtl/port/apple/base:darwin_debugging",
        ],
        "//xrtl/tools/target_platform:windows": [
            "//xrtl/port/windows/base:win32_debugging",
        ],
        "//conditions:default": [
            "//xrtl/port/common/base:posix_debugging",
        ],
    }),
)

cc_library(
    name = "debugging_hdrs",
    hdrs = ["debugging.h"],
    visibility = ["//xrtl/port:ports_only"],
    deps = [
        ":macros",
        "//xrtl/tools/target_platform",
    ],
)

cc_library(
    name = "debugging_settings",
    srcs = ["debugging_settings.cc"],
    hdrs = ["debugging_settings.h"],
    linkopts = select({
        # TODO(benvanik): figure out if something similar is needed on macos.
        "//xrtl/tools/target_platform:linux": [
            "-Wl,-u__asan_default_options",
            "-Wl,-u__asan_default_suppressions",
            "-Wl,-u__lsan_default_options",
            "-Wl,-u__lsan_default_suppressions",
            "-Wl,-u__msan_default_options",
            "-Wl,-u__tsan_default_options",
            "-Wl,-u__tsan_default_suppressions",
            "-Wl,-u__ubsan_default_options",
        ],
        "//conditions:default": [],
    }),
    linkstatic = 1,
    visibility = ["//visibility:public"],
    deps = [
        "//xrtl/tools/target_platform",
    ],
    alwayslink = 1,
)

cc_library(
    name = "env",
    srcs = ["env.cc"],
    hdrs = ["env.h"],
    deps = [
        ":macros",
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/types:optional",
    ] + select({
        "//xrtl/tools/target_platform:windows": [
            "//xrtl/port/windows/base:win32_env",
        ],
        "//conditions:default": [
            "//xrtl/port/common/base:posix_env",
        ],
    }),
)

cc_library(
    name = "env_hdrs",
    hdrs = ["env.h"],
    visibility = ["//xrtl/port:ports_only"],
    deps = [
        ":macros",
        "@com_google_absl//absl/strings",
        "@com_google_absl//absl/types:optional",
    ],
)

cc_library(
    name = "flags",
    hdrs = ["flags.h"],
    deps = [
        ":macros",
    ] + select({
        "//xrtl/tools/target_config:google_internal": [
            "//xrtl/port/google/base:flags_forward",
        ],
        "//conditions:default": [
            "//xrtl/port/common/base:gflags_flags",
        ],
    }),
)

cc_library(
    name = "flags_hdrs",
    hdrs = ["flags.h"],
    visibility = ["//xrtl/port:ports_only"],
    deps = [
        ":macros",
    ] + select({
        "//xrtl/tools/target_config:google_internal": [
            "//xrtl/port/google/base:flags_forward",
        ],
        "//conditions:default": [
            "//xrtl/port/common/base:gflags_flags_hdrs",
        ],
    }),
)

portable_cc_test(
    name = "flags_test",
    size = "small",
    srcs = ["flags_test.cc"],
    deps = [
        ":flags",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "geometry",
    hdrs = ["geometry.h"],
)

portable_cc_test(
    name = "geometry_test",
    size = "small",
    srcs = ["geometry_test.cc"],
    deps = [
        ":geometry",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "intrusive_list",
    hdrs = ["intrusive_list.h"],
    deps = [
        ":logging",
        ":macros",
        ":ref_ptr",
    ],
)

portable_cc_test(
    name = "intrusive_list_test",
    size = "small",
    srcs = ["intrusive_list_test.cc"],
    deps = [
        ":intrusive_list",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "intrusive_pool",
    hdrs = ["intrusive_pool.h"],
    deps = [
        ":intrusive_list",
        ":logging",
        ":macros",
    ],
)

portable_cc_test(
    name = "intrusive_pool_test",
    size = "small",
    srcs = ["intrusive_pool_test.cc"],
    deps = [
        ":intrusive_pool",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "logging",
    srcs = ["logging.cc"],
    hdrs = ["logging.h"],
    # Some third_party builds may reference this to reuse our logging.
    visibility = ["//visibility:public"],
    deps = [
        ":macros",
        "@com_google_absl//absl/base",
    ] + select({
        "//xrtl/tools/target_config:google_internal": [
            "//xrtl/port/google/base:logging_forward",
        ],
        "//conditions:default": [
            "//xrtl/port/common/base:logging_macros",
        ],
    }),
    alwayslink = 1,
)

cc_library(
    name = "logging_hdrs",
    hdrs = ["logging.h"],
    visibility = ["//xrtl/port:ports_only"],
    deps = [
        ":macros",
        "@com_google_absl//absl/base",
    ] + select({
        "//xrtl/tools/target_config:google_internal": [
            "//xrtl/port/google/base:logging_forward",
        ],
        "//conditions:default": [
            "//xrtl/port/common/base:logging_macros_hdrs",
        ],
    }),
)

portable_cc_test(
    name = "logging_test",
    size = "small",
    srcs = ["logging_test.cc"],
    deps = [
        ":logging",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "macros",
    hdrs = [
        "macros.h",
    ],
    deps = [
        ":debugging_settings",
        "//xrtl/tools/target_config",
        "//xrtl/tools/target_platform",
        "@com_google_absl//absl/base",
        "@com_google_absl//absl/memory",
    ],
)

portable_cc_test(
    name = "macros_test",
    size = "small",
    srcs = ["macros_test.cc"],
    deps = [
        ":macros",
        ":ref_ptr",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "math",
    hdrs = ["math.h"],
    deps = [
        ":macros",
    ],
)

portable_cc_test(
    name = "math_test",
    size = "small",
    srcs = ["math_test.cc"],
    deps = [
        ":math",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "proto_util",
    srcs = ["proto_util.cc"],
    hdrs = ["proto_util.h"],
    deps = [
        ":macros",
    ],
)

portable_cc_test(
    name = "proto_util_test",
    size = "small",
    srcs = ["proto_util_test.cc"],
    deps = [
        ":proto_util",
        "//xrtl/base/testdata:proto_util_test_cc_proto",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "ref_ptr",
    hdrs = ["ref_ptr.h"],
    deps = [
        ":logging",
        ":macros",
    ],
)

portable_cc_test(
    name = "ref_ptr_test",
    size = "small",
    srcs = ["ref_ptr_test.cc"],
    deps = [
        ":ref_ptr",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "stopwatch",
    hdrs = ["stopwatch.h"],
    deps = [":system_clock"],
)

portable_cc_test(
    name = "stopwatch_test",
    size = "small",
    srcs = ["stopwatch_test.cc"],
    deps = [
        ":stopwatch",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "system_clock",
    srcs = ["system_clock.cc"],
    hdrs = ["system_clock.h"],
    deps = [
        ":macros",
    ] + select({
        "//xrtl/tools/target_platform:ios": [
            "//xrtl/port/apple/base:mach_system_clock",
        ],
        "//xrtl/tools/target_platform:macos": [
            "//xrtl/port/apple/base:mach_system_clock",
        ],
        "//xrtl/tools/target_platform:windows": [
            "//xrtl/port/windows/base:win32_system_clock",
        ],
        "//conditions:default": [
            "//xrtl/port/common/base:posix_system_clock",
        ],
    }),
)

cc_library(
    name = "system_clock_hdrs",
    hdrs = ["system_clock.h"],
    visibility = ["//xrtl/port:ports_only"],
)

portable_cc_test(
    name = "system_clock_test",
    size = "small",
    srcs = ["system_clock_test.cc"],
    deps = [
        ":system_clock",
        "//xrtl/testing:gtest_main",
    ],
)

cc_library(
    name = "tracing",
    srcs = ["tracing.cc"],
    hdrs = ["tracing.h"],
    deps = [
        ":logging",
        ":macros",
        # TODO(benvanik): third_party/tracing_framework_bindings_cpp/
    ],
)

cc_library(
    name = "uri",
    srcs = ["uri.cc"],
    hdrs = ["uri.h"],
    deps = [
        "@com_google_absl//absl/strings",
    ],
)

portable_cc_test(
    name = "uri_test",
    size = "small",
    srcs = ["uri_test.cc"],
    deps = [
        ":uri",
        "//xrtl/testing:gtest_main",
    ],
)

load("//xrtl/testing:portable_testing.bzl", "portable_test_suite")

portable_test_suite()
