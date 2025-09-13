const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const awk_dep = b.dependency("mawk", .{});
    const mod = b.addModule("awk", .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    mod.addIncludePath(awk_dep.path(""));

    const only_posix: ?i64 = if (target.result.os.tag == .windows) null else 1;

    const config_h = b.addConfigHeader(.{
        .style = .{ .autoconf_undef = awk_dep.path("config_h.in") },
        .include_path = "config.h",
    }, .{
        .DECL_ENVIRON = only_posix,
        .FPE_TRAPS_ON = null,
        .GCC_NORETURN = null,
        .GCC_PRINTFLIKE = null,
        .GCC_SCANFLIKE = null,
        .GCC_UNUSED = null,
        .HAVE_BSD_STDLIB_H = null,
        .HAVE_CLOCK_GETTIME = 1,
        .HAVE_ENVIRON = only_posix,
        .HAVE_ERRNO_H = 1,
        .HAVE_FCNTL_H = 1,
        .HAVE_FORK = only_posix,
        .HAVE_FSEEKO = 1,
        .HAVE_FSTAT = 1,
        .HAVE_GETTIMEOFDAY = null,
        .HAVE_INT64_T = 1,
        .HAVE_INTTYPES_H = 1,
        .HAVE_ISINF = only_posix,
        .HAVE_ISNAN = 1,
        .HAVE_LIMITS_H = 1,
        .HAVE_LONG_LONG = 1,
        .HAVE_MATHERR = null,
        .HAVE_MATH__LIB_VERSION = null,
        .HAVE_MEMORY_H = 1,
        .HAVE_MKTIME = 1,
        .HAVE_PIPE = only_posix,
        .HAVE_REAL_PIPES = only_posix,
        .HAVE_REGEXPR_H_FUNCS = null,
        .HAVE_REGEXP_H_FUNCS = null,
        .HAVE_REGEX_H_FUNCS = null,
        .HAVE_SIGACTION = only_posix,
        .HAVE_SIGACTION_SA_SIGACTION = only_posix,
        .HAVE_SIGINFO_H = null,
        .HAVE_STDINT_H = 1,
        .HAVE_STDLIB_H = 1,
        .HAVE_STRFTIME = 1,
        .HAVE_STRINGS_H = 1,
        .HAVE_STRING_H = 1,
        .HAVE_STRTOD_OVF_BUG = null,
        .HAVE_SYS_STAT_H = 1,
        .HAVE_SYS_TYPES_H = 1,
        .HAVE_SYS_WAIT_H = null,
        .HAVE_TDESTROY = null,
        .HAVE_TSEARCH = 1,
        .HAVE_UINT64_T = 1,
        .HAVE_UNISTD_H = 1,
        .HAVE_WAIT = only_posix,
        .LOCALE = 1,
        .LOCAL_REGEXP = 1,
        .MAWK_RAND_MAX = @as(enum { INT_MAX, RAND_MAX }, switch (target.result.os.tag) {
            .windows => .RAND_MAX,
            else => .INT_MAX,
        }),
        .MAX__INT = null,
        .MAX__LONG = null,
        .MAX__UINT = null,
        .MAX__ULONG = null,
        .NAME_RANDOM = switch (target.result.os.tag) {
            .windows => "srand/rand",
            else => "srandom/random",
        },
        .NOINFO_SIGFPE = null,
        .NO_GAWK_OPTIONS = null,
        .NO_INIT_SRAND = null,
        .NO_INTERVAL_EXPR = null,
        .NO_LEAKS = null,
        .SIZEOF_DOUBLE = 8,
        .SIZEOF_FLOAT = 4,
        .SIZEOF_INT64_T = 8,
        .SIZEOF_LONG = 8,
        .SIZEOF_LONG_LONG = 8,
        .SIZE_T_STDDEF_H = 1,
        .SIZE_T_TYPES_H = null,
        .STDC_HEADERS = 1,
        .SYSTEM_NAME = "linux-gnu",
        .TURN_OFF_FPE_TRAPS = null,
        .TURN_ON_FPE_TRAPS = null,
        .USE_IEEEFP_H = null,
        .YY_NO_LEAKS = null,
        .@"const" = null,
        .mawk_rand = null,
        .mawk_srand = null,
    });
    mod.addIncludePath(config_h.getOutputDir());
    mod.addCMacro("_XOPEN_SOURCE", "500");
    mod.addCMacro("_DEFAULT_SOURCE", "");
    mod.addCMacro("_HAVE_CONFIG_H", "");

    const makesrc_wf = b.addWriteFiles();
    mod.addIncludePath(makesrc_wf.getDirectory().path(b, "include"));

    const makebits = b.addExecutable(.{
        .name = "makebits",
        .root_module = b.createModule(.{
            .target = b.graph.host,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    makebits.addIncludePath(config_h.getOutputDir());
    makebits.addCSourceFile(.{ .file = awk_dep.path("makebits.c") });
    const makebits_run = b.addRunArtifact(makebits);
    _ = makesrc_wf.addCopyFile(makebits_run.captureStdOut(), "include/makebits.h");

    const makescan = b.addExecutable(.{
        .name = "makescan",
        .root_module = b.createModule(.{
            .target = b.graph.host,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    makescan.addIncludePath(config_h.getOutputDir());
    makescan.addIncludePath(awk_dep.path(""));
    makescan.addCSourceFile(.{ .file = awk_dep.path("makescan.c") });
    const makescan_run = b.addRunArtifact(makescan);
    const makescan_c = makesrc_wf.addCopyFile(makescan_run.captureStdOut(), "src/scancode.c");
    mod.addCSourceFile(.{
        .file = makescan_c,
        .flags = flags,
        .language = .c,
    });

    mod.addCSourceFiles(.{
        .files = &.{
            "parse.c",
            "scan.c",
            "memory.c",
            "main.c",
            "hash.c",
            "execute.c",
            "code.c",
            "da.c",
            "error.c",
            "init.c",
            "bi_vars.c",
            "cast.c",
            "print.c",
            "bi_funct.c",
            "kw.c",
            "jmp.c",
            "array.c",
            "field.c",
            "split.c",
            "re_cmpl.c",
            "regexp.c",
            "zmalloc.c",
            "fin.c",
            "files.c",
            "matherr.c",
            "fcall.c",
            "version.c",
        },
        .root = awk_dep.path(""),
        .flags = flags,
    });
    // mod.addIncludePath(b.path("src"));

    const exe = b.addExecutable(.{
        .name = "awk",
        .root_module = mod,
    });
    b.installArtifact(exe);
}

const flags = &.{
    "-fno-optimize-sibling-calls",
    "-Wall",
    "-Wextra",
    "-Werror",
    "-pedantic",
    "-Wno-unused-parameter",
    "-Wno-format",
    "-Wno-implicit-function-declaration",
};
