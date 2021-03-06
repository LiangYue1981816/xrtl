# Description:
#  XRTL common workspace that can be merged into subproject workspaces.
#
#  Usage:
#    my/WORKSPACE:
#      load("//xrtl:workspace.bzl", "xrtl_workspace")
#      xrtl_workspace(path_to_xrtl_root)

# Parses the bazel version string from `native.bazel_version`.
# e.g. "1.2.3rc1 abcd" -> (1, 2, 3)
def _parse_bazel_version(bazel_version):
  # Remove commit (or anything trailing a space) from version.
  version = bazel_version.split(" ", 1)[0]

  # Strip any trailing characters like 'rc1' from the version number.
  for i in range(len(version)):
    c = version[i]
    if not (c.isdigit() or c == '.'):
      version = version[:i]
      break

  # Return the version as a tuple of integers.
  return tuple([int(n) for n in version.split('.')])

# Checks that a specific bazel version is being used.
def check_version(bazel_version):
  if "bazel_version" not in dir(native):
    fail("\nCurrent Bazel version is lower than 0.2.1, expected at least %s\n" % bazel_version)
  elif not native.bazel_version:
    print("\nCurrent Bazel is not a release version, cannot check for compatibility.")
    print("Make sure that you are running at least Bazel %s.\n" % bazel_version)
  else:
    current_bazel_version = _parse_bazel_version(native.bazel_version)
    minimum_bazel_version = _parse_bazel_version(bazel_version)
    if minimum_bazel_version > current_bazel_version:
      fail("\nCurrent Bazel version is {}, expected at least {}\n".format(
          native.bazel_version, bazel_version))
  pass

def xrtl_workspace(path_prefix=""):
  # Verify supported bazel version.
  check_version("0.6.0")

  if path_prefix:
    path_prefix = path_prefix + "/"

  # //third_party/gflags/
  native.new_local_repository(
      name = "com_github_gflags_gflags",
      path = path_prefix + "third_party/gflags/",
      build_file = path_prefix + "third_party/gflags.BUILD",
  )

  # //third_party/glm/
  native.new_local_repository(
      name = "com_github_gtruc_glm",
      path = path_prefix + "third_party/glm/",
      build_file = path_prefix + "third_party/glm.BUILD",
  )

  # //third_party/glslang/
  native.new_local_repository(
      name = "com_github_khronosgroup_glslang",
      path = path_prefix + "third_party/glslang/",
      build_file = path_prefix + "third_party/glslang.BUILD",
  )

  # //third_party/spirv_cross/
  # NOTE: this would be com_github_KhronosGroup_SPIRV_Cross, but that causes
  #       path limit issues on Windows.
  native.new_local_repository(
      name = "spirv_cross",
      path = path_prefix + "third_party/spirv_cross/",
      build_file = path_prefix + "third_party/spirv_cross.BUILD",
  )

  # //third_party/spirv_headers/
  native.new_local_repository(
      name = "com_github_khronosgroup_spirv_headers",
      path = path_prefix + "third_party/spirv_headers/",
      build_file = path_prefix + "third_party/spirv_headers.BUILD",
  )

  # //third_party/spirv_tools/
  # NOTE: this would be com_github_KhronosGroup_SPIRV_Tools, but that causes
  #       path limit issues on Windows.
  native.new_local_repository(
      name = "spirv_tools",
      path = path_prefix + "third_party/spirv_tools/",
      build_file = path_prefix + "third_party/spirv_tools.BUILD",
  )

  # //third_party/stblib/
  native.new_local_repository(
      name = "com_github_nothings_stb",
      path = path_prefix + "third_party/stblib/",
      build_file = path_prefix + "third_party/stblib.BUILD",
  )

  # //third_party/swiftshader/
  native.new_local_repository(
      name = "com_github_google_swiftshader",
      path = path_prefix + "third_party/swiftshader/",
      build_file = path_prefix + "third_party/swiftshader.BUILD",
  )

  # Apple build rules.
  native.git_repository(
      name = "build_bazel_rules_apple",
      remote = "https://github.com/bazelbuild/rules_apple.git",
      tag = "0.1.0",
  )

  # Protobuf deps. Unfortunately the builtin rules look for these with different
  # names, so we need to alias them.
  PROTOBUF_NAMES = [
      "com_google_protobuf",       # proto_library
      "com_google_protobuf_cc",    # cc_proto_library
      "com_google_protobuf_java",  # java_proto_library
  ]
  for protobuf_name in PROTOBUF_NAMES:
    native.http_archive(
        name = protobuf_name,
        urls = ["https://github.com/google/protobuf/archive/v3.4.1.zip"],
        strip_prefix = "protobuf-3.4.1",
    )

  # //third_party/abseil-cpp/
  native.local_repository(
      name = "com_google_absl",
      path = path_prefix + "third_party/abseil-cpp/",
  )
  # GoogleTest/GoogleMock framework. Used by most unit-tests.
  native.http_archive(
       name = "com_google_googletest",
       urls = ["https://github.com/google/googletest/archive/master.zip"],
       strip_prefix = "googletest-master",
  )
  # CCTZ (Time-zone framework).
  native.http_archive(
      name = "com_googlesource_code_cctz",
      urls = ["https://github.com/google/cctz/archive/master.zip"],
      strip_prefix = "cctz-master",
  )
  # RE2 regular-expression framework. Used by some unit-tests.
  native.http_archive(
      name = "com_googlesource_code_re2",
      urls = ["https://github.com/google/re2/archive/master.zip"],
      strip_prefix = "re2-master",
  )
