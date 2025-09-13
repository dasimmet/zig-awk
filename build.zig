const std = @import("std");
const zon = @import("build.zig.zon");
const zon_version = std.SemanticVersion.parse(zon.version) catch unreachable;

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const awk_dep = b.dependency("awk", .{});

    const target_ptr_bytes = target.result.ptrBitWidth() / 8;
    const target_linux = @as(?i64, switch (target.result.os.tag) {
        .linux => 1,
        else => null,
    });

    const target_not_macos_musl = @as(?i64, switch (target.result.os.tag) {
        .macos => switch (target.result.abi.isMusl()) {
            true => null,
            else => 1,
        },
        else => 1,
    });

    const target_not_windows = @as(?i64, switch (target.result.os.tag) {
        .windows => null,
        else => 1,
    });

    // const target_windows = @as(?i64, switch (target.result.os.tag) {
    //     .windows => 1,
    //     else => null,
    // });

    const config_h = b.addConfigHeader(.{
        .style = .{ .autoconf_undef = awk_dep.path("configh.in") },
        .include_path = "config.h",
    }, .{
        .DYNAMIC = null,
        .ENABLE_NLS = @as(?enum { gid_t }, switch (target.result.os.tag) {
            .windows => null,
            else => .gid_t,
        }),
        .GETGROUPS_T = @as(enum { gid_t, int }, switch (target.result.os.tag) {
            .windows => .int,
            else => .gid_t,
        }),
        .GETPGRP_VOID = 1,
        .HAVE_ADDR_NO_RANDOMIZE = target_not_windows,
        .HAVE_ALARM = 1,
        .HAVE_ARPA_INET_H = target_not_windows,
        .HAVE_ATEXIT = 1,
        .HAVE_BTOWC = 1,
        .HAVE_CFLOCALECOPYPREFERREDLANGUAGES = null,
        .HAVE_CFPREFERENCESCOPYAPPVALUE = null,
        .HAVE_CLOCK_GETTIME = 1,
        .HAVE_C_BOOL = 1,
        .HAVE_C_VARARRAYS = 1,
        .HAVE_DCGETTEXT = 1,
        .HAVE_DECL_TZNAME = null,
        .HAVE_FCNTL_H = 1,
        .HAVE_FMOD = 1,
        .HAVE_FWRITE_UNLOCKED = target_linux,
        .HAVE_GAI_STRERROR = 1,
        .HAVE_GETADDRINFO = 1,
        .HAVE_GETDTABLESIZE = 1,
        .HAVE_GETGRENT = 1,
        .HAVE_GETGROUPS = null,
        .HAVE_GETTEXT = 1,
        .HAVE_GETTIMEOFDAY = 1,
        .HAVE_GRANTPT = 1,
        .HAVE_HISTORY_LIST = null,
        .HAVE_ICONV = null,
        .HAVE_INTMAX_T = 1,
        .HAVE_INTTYPES_H = null,
        .HAVE_ISASCII = 1,
        .HAVE_ISBLANK = 1,
        .HAVE_ISWCTYPE = 1,
        .HAVE_ISWLOWER = 1,
        .HAVE_ISWUPPER = 1,
        .HAVE_LANGINFO_CODESET = 1,
        .HAVE_LC_MESSAGES = 1,
        .HAVE_LIBINTL_H = 1,
        .HAVE_LIBREADLINE = null,
        .HAVE_LOCALE_H = 1,
        .HAVE_LONG_LONG_INT = 1,
        .HAVE_LSTAT = 1,
        .HAVE_MBRLEN = 1,
        .HAVE_MBRTOWC = 1,
        .HAVE_MCHECK_H = null,
        .HAVE_MEMCMP = 1,
        .HAVE_MEMCPY = 1,
        .HAVE_MEMMOVE = 1,
        .HAVE_MEMORY_H = 1,
        .HAVE_MEMSET = 1,
        .HAVE_MINIX_CONFIG_H = null,
        .HAVE_MKSTEMP = 1,
        .HAVE_MKTIME = 1,
        .HAVE_MPFR = null,
        .HAVE_MTRACE = 1,
        .HAVE_NETDB_H = 1,
        .HAVE_NETINET_IN_H = 1,
        .HAVE_PERSONALITY = target_linux,
        .HAVE_POSIX_OPENPT = 1,
        .HAVE_SETENV = 1,
        .HAVE_SETLOCALE = 1,
        .HAVE_SETSID = 1,
        .HAVE_SIGPROCMASK = 1,
        .HAVE_SNPRINTF = 1,
        .HAVE_SOCKADDR_STORAGE = 1,
        .HAVE_SOCKETS = 1,
        .HAVE_SPAWN_H = 1,
        .HAVE_STDBOOL_H = null,
        .HAVE_STDDEF_H = 1,
        .HAVE_STDINT_H = 1,
        .HAVE_STDIO_H = 1,
        .HAVE_STDLIB_H = 1,
        .HAVE_STRCASECMP = 1,
        .HAVE_STRCHR = 1,
        .HAVE_STRCOLL = 1,
        .HAVE_STRERROR = 1,
        .HAVE_STRFTIME = 1,
        .HAVE_STRINGIZE = 1,
        .HAVE_STRINGS_H = 1,
        .HAVE_STRING_H = 1,
        .HAVE_STRNCASECMP = 1,
        .HAVE_STROPTS_H = null,
        .HAVE_STRSIGNAL = 1,
        .HAVE_STRTOD = 1,
        .HAVE_STRTOUL = 1,
        .HAVE_STRUCT_GROUP_GR_PASSWD = 1,
        .HAVE_STRUCT_PASSWD_PW_PASSWD = 1,
        .HAVE_STRUCT_STAT_ST_BLKSIZE = 1,
        .HAVE_STRUCT_TM_TM_ZONE = 1,
        .HAVE_SYSTEM = 1,
        .HAVE_SYS_IOCTL_H = 1,
        .HAVE_SYS_PARAM_H = 1,
        .HAVE_SYS_PERSONALITY_H = target_linux,
        .HAVE_SYS_SELECT_H = 1,
        .HAVE_SYS_SOCKET_H = 1,
        .HAVE_SYS_STAT_H = 1,
        .HAVE_SYS_TIME_H = 1,
        .HAVE_SYS_TYPES_H = 1,
        .HAVE_SYS_WAIT_H = target_not_windows,
        .HAVE_TERMIOS_H = 1,
        .HAVE_TIMEGM = 1,
        .HAVE_TMPFILE = 1,
        .HAVE_TM_ZONE = 1,
        .HAVE_TOWLOWER = 1,
        .HAVE_TOWUPPER = 1,
        .HAVE_TZNAME = null,
        .HAVE_TZSET = 1,
        .HAVE_UINTMAX_T = 1,
        .HAVE_UNISTD_H = 1,
        .HAVE_UNSIGNED_LONG_LONG_INT = 1,
        .HAVE_USLEEP = 1,
        .HAVE_WAITPID = 1,
        .HAVE_WCHAR_H = 1,
        .HAVE_WCRTOMB = 1,
        .HAVE_WCSCOLL = 1,
        .HAVE_WCTYPE = 1,
        .HAVE_WCTYPE_H = 1,
        .HAVE_WCTYPE_T = 1,
        .HAVE_WINT_T = 1,
        .HAVE__NSGETEXECUTABLEPATH = null,
        .HAVE___ETOA_L = null,
        .NO_LINT = null,
        .PACKAGE = "gawk",
        .PACKAGE_BUGREPORT = "bug-gawk@gnu.org",
        .PACKAGE_NAME = "GNU Awk",
        .PACKAGE_STRING = "GNU Awk 5.3.2",
        .PACKAGE_TARNAME = "gawk",
        .PACKAGE_URL = "https://www.gnu.org/software/gawk/",
        .PACKAGE_VERSION = "5.3.2",
        .PRINTF_HAS_A_FORMAT = 1,
        .PRINTF_HAS_F_FORMAT = 1,
        .SIZEOF_UNSIGNED_INT = 4,
        .SIZEOF_UNSIGNED_LONG = target_ptr_bytes,
        .SIZEOF_VOID_P = target_ptr_bytes,
        .STDC_HEADERS = 1,
        .SUPPLY_INTDIV = 1,
        .TIME_T_IN_SYS_TYPES_H = null,
        .TM_IN_SYS_TIME = null,
        .USE_EBCDIC = null,
        .USE_PERSISTENT_MALLOC = target_not_macos_musl,
        ._ALL_SOURCE = 1,
        ._DARWIN_C_SOURCE = 1,
        .__EXTENSIONS__ = 1,
        ._GNU_SOURCE = 1,
        ._HPUX_ALT_XOPEN_SOCKET_API = 1,
        ._MINIX = null,
        ._NETBSD_SOURCE = 1,
        ._OPENBSD_SOURCE = 1,
        ._POSIX_SOURCE = null,
        ._POSIX_1_SOURCE = null,
        ._POSIX_PTHREAD_SEMANTICS = 1,
        .__STDC_WANT_IEC_60559_ATTRIBS_EXT__ = 1,
        .__STDC_WANT_IEC_60559_BFP_EXT__ = 1,
        .__STDC_WANT_IEC_60559_DFP_EXT__ = 1,
        .__STDC_WANT_IEC_60559_FUNCS_EXT__ = 1,
        .__STDC_WANT_IEC_60559_TYPES_EXT__ = 1,
        .__STDC_WANT_LIB_EXT2__ = 1,
        .__STDC_WANT_MATH_SPEC_FUNCS__ = 1,
        ._TANDEM_SOURCE = 1,
        ._XOPEN_SOURCE = null,
        .VERSION = zon.version,
        ._FILE_OFFSET_BITS = null,
        ._LARGE_FILES = null,
        .__CHAR_UNSIGNED__ = null,
        .__STDC_NO_VLA__ = null,
        .@"const" = null,
        .gid_t = null,
        .@"inline" = null,
        .intmax_t = null,
        .pid_t = null,
        .restrict = .__restrict__,
        .size_t = null,
        .socklen_t = null,
        .ssize_t = null,
        .uid_t = null,
        .uintmax_t = null,
    });

    const libsupport = b.addLibrary(.{
        .name = "support",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    libsupport.addIncludePath(config_h.getOutputDir());
    libsupport.addCSourceFiles(.{
        .files = Sources.Support.common,
        .root = awk_dep.path("support"),
        .flags = Sources.flags(target),
    });
    libsupport.addIncludePath(awk_dep.path(""));
    libsupport.addIncludePath(awk_dep.path("support"));
    libsupport.installHeadersDirectory(awk_dep.path("support"), "", .{});

    const mod = b.addModule("awk", .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    mod.addIncludePath(config_h.getOutputDir());
    mod.addCSourceFiles(.{
        .files = Sources.Root.common,
        .root = awk_dep.path(""),
        .flags = Sources.flags(target),
    });

    mod.linkLibrary(libsupport);
    mod.addIncludePath(awk_dep.path(""));

    if (target.result.os.tag == .windows) {
        libsupport.addIncludePath(awk_dep.path("pc"));
        // libsupport.root_module.addCMacro("__MINGW__", "");
        // mod.addCMacro("__MINGW__", "");
        mod.addIncludePath(awk_dep.path("pc"));
        mod.addCSourceFiles(.{
            .files = Sources.windows,
            .root = awk_dep.path("pc"),
            .flags = Sources.flags(target),
        });
        mod.addCSourceFiles(.{
            .files = Sources.Root.posix,
            .root = awk_dep.path(""),
            .flags = &.{
                "-std=c99",
            },
        });
    } else {
        mod.addCSourceFiles(.{
            .files = Sources.Root.posix,
            .root = awk_dep.path(""),
            .flags = Sources.flags(target),
        });
        libsupport.addCSourceFiles(.{
            .files = Sources.Support.unix,
            .root = awk_dep.path("support"),
            .flags = Sources.flags(target),
        });
    }

    // const libextension = build_extensions(b, awk_dep, target, optimize);
    // mod.linkLibrary(libextension);
    // mod.addIncludePath(awk_dep.path("extension"));

    const exe = b.addExecutable(.{
        .name = "awk",
        .root_module = mod,
    });
    b.installArtifact(exe);
}

const Sources = struct {
    pub fn flags(target: std.Build.ResolvedTarget) []const []const u8 {
        return switch (target.result.os.tag) {
            .windows => &(Flags.default ++ Flags.unwarn ++ Flags.macro_common ++ Flags.macro_windows),
            else => &(Flags.default ++ Flags.unwarn ++ Flags.macro_common ++ Flags.macro_posix),
        };
    }

    const Flags = struct {
        const default = .{
            "-std=c23",
            "-Wall",
            "-Wextra",
            // "-Weverything",
            "-Werror",
            "-pedantic",
        };
        const unwarn = .{
            "-Wno-anon-enum-enum-conversion",
            "-Wno-assign-enum",
            "-Wno-bitwise-instead-of-logical",
            "-Wno-cast-align",
            "-Wno-cast-function-type-mismatch",
            "-Wno-cast-qual",
            "-Wno-comma",
            "-Wno-conditional-uninitialized",
            "-Wno-constant-conversion",
            "-Wno-covered-switch-default",
            "-Wno-declaration-after-statement",
            "-Wno-extra-semi-stmt",
            "-Wno-float-overflow-conversion",
            "-Wno-format-nonliteral",
            "-Wno-format",
            "-Wno-implicit-const-int-float-conversion",
            "-Wno-implicit-fallthrough",
            "-Wno-implicit-int-conversion",
            "-Wno-missing-field-initializers",
            "-Wno-missing-prototypes",
            "-Wno-missing-variable-declarations",
            "-Wno-padded",
            "-Wno-pre-c11-compat",
            "-Wno-pre-c23-compat",
            "-Wno-redundant-parens",
            "-Wno-reserved-identifier",
            "-Wno-reserved-macro-identifier",
            "-Wno-shadow",
            "-Wno-shift-count-overflow",
            "-Wno-sign-compare",
            "-Wno-sign-conversion",
            "-Wno-switch-default",
            "-Wno-switch-enum",
            "-Wno-tautological-constant-compare",
            "-Wno-tautological-value-range-compare",
            "-Wno-undef",
            "-Wno-unreachable-code",
            "-Wno-unsafe-buffer-usage",
            "-Wno-unused-but-set-variable",
            "-Wno-unused-macros",
            "-Wno-unused-parameter",
            "-Wno-used-but-marked-unused",
            "-Wno-vla",
        };
        const macro_common = .{
            "-DGAWK",
            "-DHAVE_CONFIG_H",
            "-DNDEBUG",
        };
        const macro_posix = .{
            "-DSHLIBEXT=\"so\"",
            "-DDEFLIBPATH=\"/usr/local/share/awk\"",
            "-DDEFPATH=\"/usr/local/share/awk\"",
        };
        const macro_windows = .{
            "-DSHLIBEXT=\"so\"",
            "-DDEFLIBPATH=\"/usr/local/share/awk\"",
            "-DDEFPATH=\"/usr/local/share/awk\"",
        };
    };

    const Root = struct {
        const common = &.{
            "array.c",
            "awkgram.c",
            "builtin.c",
            "cint_array.c",
            "command.c",
            "debug.c",
            "eval.c",
            "ext.c",
            "field.c",
            "floatcomp.c",
            "gawkapi.c",
            "int_array.c",
            "io.c",
            "main.c",
            "mpfr.c",
            "msg.c",
            "node.c",
            "printf.c",
            "profile.c",
            "re.c",
            "replace.c",
            "str_array.c",
            "symbol.c",
            "version.c",
        };
        const posix = &.{
            "gawkmisc.c",
        };
    };

    const Support = struct {
        const common = &.{
            "dfa.c",
            "getopt.c",
            "getopt1.c",
            "localeinfo.c",
            "random.c",
            "regex.c",
            "malloc/dynarray_at_failure.c",
            "malloc/dynarray_emplace_enlarge.c",
            "malloc/dynarray_finalize.c",
            "malloc/dynarray_resize.c",
            "malloc/dynarray_resize_clear.c",
        };
        const unix = &.{
            "pma.c",
        };
    };
    const extension = &.{
        "testext.c",
        "filefuncs.c",
        "stack.c",
        "gawkfts.c",
        "fnmatch.c",
        "fork.c",
        "inplace.c",
        "intdiv.c",
        "ordchr.c",
        "readdir.c",
        "readfile.c",
        "revoutput.c",
        "revtwoway.c",
        "rwarray.c",
        "time.c",
    };

    const windows = &.{
        "getid.c",
        "popen.c",
    };
};

/// TODO: extensions are not built yet
pub fn build_extensions(
    b: *std.Build,
    awk_dep: *std.Build.Dependency,
    target: std.Build.ResolvedTarget,
    optimize: std.builtin.OptimizeMode,
) *std.Build.Step.Compile {
    const target_ptr_bytes = target.result.ptrBitWidth() / 8;
    const ext_config_h = b.addConfigHeader(.{
        .style = .{ .autoconf_undef = awk_dep.path("extension/configh.in") },
        .include_path = "config.h",
    }, .{
        .DIR_FD_MEMBER_NAME = null,
        .ENABLE_NLS = 1,
        .HAVE_ADDR_NO_RANDOMIZE = 1,
        .HAVE_CFLOCALECOPYPREFERREDLANGUAGES = null,
        .HAVE_CFPREFERENCESCOPYAPPVALUE = null,
        .HAVE_CLOCK_GETTIME = 1,
        .HAVE_DCGETTEXT = 1,
        .HAVE_DECL_DIRFD = 1,
        .HAVE_DIRENT_H = 1,
        .HAVE_DIRFD = 1,
        .HAVE_DLFCN_H = 1,
        .HAVE_FDOPENDIR = null,
        .HAVE_FMOD = null,
        .HAVE_FNMATCH = 1,
        .HAVE_FNMATCH_H = 1,
        .HAVE_GETDTABLESIZE = 1,
        .HAVE_GETSYSTEMTIMEASFILETIME = null,
        .HAVE_GETTEXT = 1,
        .HAVE_GETTIMEOFDAY = 1,
        .HAVE_ICONV = null,
        .HAVE_INTTYPES_H = 1,
        .HAVE_LANGINFO_CODESET = null,
        .HAVE_LC_MESSAGES = null,
        .HAVE_LIMITS_H = 1,
        .HAVE_MINIX_CONFIG_H = null,
        .HAVE_MPFR = null,
        .HAVE_NANOSLEEP = 1,
        .HAVE_NDIR_H = null,
        .HAVE_SELECT = 1,
        .HAVE_STATVFS = 1,
        .HAVE_STDINT_H = 1,
        .HAVE_STDIO_H = 1,
        .HAVE_STDLIB_H = 1,
        .HAVE_STRINGS_H = 1,
        .HAVE_STRING_H = 1,
        .HAVE_STRPTIME = 1,
        .HAVE_STRUCT_STAT_ST_BLKSIZE = 1,
        .HAVE_SYS_DIR_H = null,
        .HAVE_SYS_MKDEV_H = null,
        .HAVE_SYS_NDIR_H = null,
        .HAVE_SYS_PARAM_H = 1,
        .HAVE_SYS_SELECT_H = 1,
        .HAVE_SYS_STATVFS_H = 1,
        .HAVE_SYS_STAT_H = 1,
        .HAVE_SYS_SYSMACROS_H = 1,
        .HAVE_SYS_TIME_H = 1,
        .HAVE_SYS_TYPES_H = 1,
        .HAVE_UNISTD_H = 1,
        .HAVE_WCHAR_H = 1,
        .LT_OBJDIR = ".libs",
        .PACKAGE = "gawk-extensions",
        .PACKAGE_BUGREPORT = "bug-gawk@gnu.org",
        .PACKAGE_NAME = "GNU Awk Bundled Extensions",
        .PACKAGE_STRING = "GNU Awk Bundled Extensions 5.3.2",
        .PACKAGE_TARNAME = "gawk-extensions",
        .PACKAGE_URL = "https://www.gnu.org/software/gawk-extensions/",
        .PACKAGE_VERSION = zon.version,
        .SIZEOF_VOID_P = target_ptr_bytes,
        .STDC_HEADERS = 1,
        .USE_PERSISTENT_MALLOC = 1,
        ._ALL_SOURCE = 1,
        ._DARWIN_C_SOURCE = 1,
        .__EXTENSIONS__ = 1,
        ._GNU_SOURCE = 1,
        ._HPUX_ALT_XOPEN_SOCKET_API = 1,
        ._MINIX = null,
        ._NETBSD_SOURCE = 1,
        ._OPENBSD_SOURCE = 1,
        ._POSIX_SOURCE = null,
        ._POSIX_1_SOURCE = null,
        ._POSIX_PTHREAD_SEMANTICS = 1,
        .__STDC_WANT_IEC_60559_ATTRIBS_EXT__ = 1,
        .__STDC_WANT_IEC_60559_BFP_EXT__ = 1,
        .__STDC_WANT_IEC_60559_DFP_EXT__ = 1,
        .__STDC_WANT_IEC_60559_FUNCS_EXT__ = 1,
        .__STDC_WANT_IEC_60559_TYPES_EXT__ = 1,
        .__STDC_WANT_LIB_EXT2__ = 1,
        .__STDC_WANT_MATH_SPEC_FUNCS__ = 1,
        ._TANDEM_SOURCE = 1,
        ._XOPEN_SOURCE = null,
        .VERSION = zon.version,
        ._FILE_OFFSET_BITS = null,
        ._LARGE_FILES = null,
        .@"inline" = null,
    });
    const libextension = b.addLibrary(.{
        .name = "extension",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
    libextension.addCSourceFiles(.{
        .files = Sources.extension,
        .root = awk_dep.path("extension"),
        .flags = Sources.flags(target),
    });
    libextension.addIncludePath(awk_dep.path("extension"));
    libextension.addIncludePath(awk_dep.path(""));
    libextension.addIncludePath(ext_config_h.getOutputDir());
    return libextension;
}
