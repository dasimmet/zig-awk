const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const awk_dep = b.dependency("awk", .{});

    // const yacc_dep = b.dependency("oyacc", .{});

    // const yacc = b.addRunArtifact(yacc_dep.artifact("yacc"));
    // yacc.addArgs(&.{ "-d", "-b", "awkgram", "-o" });
    // const awkgram_tab = yacc.addOutputFileArg("awkgram.tab.c");
    // yacc.addFileArg(awk_dep.path("awkgram.y"));

    // const maketab = b.addExecutable(.{
    //     .name = "maketab",
    //     .root_module = b.createModule(.{
    //         .target = b.graph.host,
    //         .optimize = .ReleaseSmall,
    //         .link_libc = true,
    //     }),
    // });
    // maketab.addIncludePath(awkgram_tab.dirname());
    // maketab.addCSourceFile(.{ .file = awk_dep.path("maketab.c") });
    // const mt_run = b.addRunArtifact(maketab);
    // mt_run.addFileArg(awkgram_tab.dirname().path(b, "awkgram.tab.h"));
    // const w_proc = b.addWriteFiles();
    // const proctab = w_proc.addCopyFile(mt_run.captureStdOut(), "proctab.c");
    const config_h = b.addConfigHeader(.{
        .style = .{ .autoconf_undef = awk_dep.path("configh.in") },
        .include_path = "config.h",
    }, .{
        .DYNAMIC = 1,
        .ENABLE_NLS = .gid_t,
        .GETGROUPS_T = {},
        .GETPGRP_VOID = 1,
        .HAVE_ADDR_NO_RANDOMIZE = 1,
        .HAVE_ALARM = 1,
        .HAVE_ARPA_INET_H = 1,
        .HAVE_ATEXIT = {},
        .HAVE_BTOWC = 1,
        .HAVE_CFLOCALECOPYPREFERREDLANGUAGES = {},
        .HAVE_CFPREFERENCESCOPYAPPVALUE = {},
        .HAVE_CLOCK_GETTIME = 1,
        .HAVE_C_BOOL = {},
        .HAVE_C_VARARRAYS = 1,
        .HAVE_DCGETTEXT = 1,
        .HAVE_DECL_TZNAME = {},
        .HAVE_FCNTL_H = 1,
        .HAVE_FMOD = 1,
        .HAVE_FWRITE_UNLOCKED = 1,
        .HAVE_GAI_STRERROR = 1,
        .HAVE_GETADDRINFO = 1,
        .HAVE_GETDTABLESIZE = 1,
        .HAVE_GETGRENT = 1,
        .HAVE_GETGROUPS = 1,
        .HAVE_GETTEXT = 1,
        .HAVE_GETTIMEOFDAY = 1,
        .HAVE_GRANTPT = 1,
        .HAVE_HISTORY_LIST = {},
        .HAVE_ICONV = {},
        .HAVE_INTMAX_T = 1,
        .HAVE_INTTYPES_H = {},
        .HAVE_ISASCII = 1,
        .HAVE_ISBLANK = 1,
        .HAVE_ISWCTYPE = 1,
        .HAVE_ISWLOWER = 1,
        .HAVE_ISWUPPER = 1,
        .HAVE_LANGINFO_CODESET = 1,
        .HAVE_LC_MESSAGES = 1,
        .HAVE_LIBINTL_H = 1,
        .HAVE_LIBREADLINE = {},
        .HAVE_LOCALE_H = 1,
        .HAVE_LONG_LONG_INT = 1,
        .HAVE_LSTAT = 1,
        .HAVE_MBRLEN = 1,
        .HAVE_MBRTOWC = 1,
        .HAVE_MCHECK_H = 1,
        .HAVE_MEMCMP = 1,
        .HAVE_MEMCPY = 1,
        .HAVE_MEMMOVE = 1,
        .HAVE_MEMORY_H = 1,
        .HAVE_MEMSET = 1,
        .HAVE_MINIX_CONFIG_H = {},
        .HAVE_MKSTEMP = 1,
        .HAVE_MKTIME = 1,
        .HAVE_MPFR = {},
        .HAVE_MTRACE = 1,
        .HAVE_NETDB_H = 1,
        .HAVE_NETINET_IN_H = 1,
        .HAVE_PERSONALITY = 1,
        .HAVE_POSIX_OPENPT = 1,
        .HAVE_SETENV = 1,
        .HAVE_SETLOCALE = 1,
        .HAVE_SETSID = 1,
        .HAVE_SIGPROCMASK = 1,
        .HAVE_SNPRINTF = 1,
        .HAVE_SOCKADDR_STORAGE = 1,
        .HAVE_SOCKETS = 1,
        .HAVE_SPAWN_H = 1,
        .HAVE_STDBOOL_H = 1,
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
        .HAVE_STROPTS_H = {},
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
        .HAVE_SYS_PERSONALITY_H = 1,
        .HAVE_SYS_SELECT_H = 1,
        .HAVE_SYS_SOCKET_H = 1,
        .HAVE_SYS_STAT_H = 1,
        .HAVE_SYS_TIME_H = 1,
        .HAVE_SYS_TYPES_H = 1,
        .HAVE_SYS_WAIT_H = 1,
        .HAVE_TERMIOS_H = 1,
        .HAVE_TIMEGM = 1,
        .HAVE_TMPFILE = 1,
        .HAVE_TM_ZONE = 1,
        .HAVE_TOWLOWER = 1,
        .HAVE_TOWUPPER = 1,
        .HAVE_TZNAME = {},
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
        .HAVE__NSGETEXECUTABLEPATH = {},
        .HAVE___ETOA_L = {},
        .NO_LINT = {},
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
        .SIZEOF_UNSIGNED_LONG = 8,
        .SIZEOF_VOID_P = 8,
        .STDC_HEADERS = 1,
        .SUPPLY_INTDIV = 1,
        .TIME_T_IN_SYS_TYPES_H = {},
        .TM_IN_SYS_TIME = {},
        .USE_EBCDIC = {},
        .USE_PERSISTENT_MALLOC = 1,
        ._ALL_SOURCE = 1,
        ._DARWIN_C_SOURCE = 1,
        .__EXTENSIONS__ = 1,
        ._GNU_SOURCE = 1,
        ._HPUX_ALT_XOPEN_SOCKET_API = 1,
        ._MINIX = {},
        ._NETBSD_SOURCE = 1,
        ._OPENBSD_SOURCE = 1,
        ._POSIX_SOURCE = {},
        ._POSIX_1_SOURCE = {},
        ._POSIX_PTHREAD_SEMANTICS = 1,
        .__STDC_WANT_IEC_60559_ATTRIBS_EXT__ = 1,
        .__STDC_WANT_IEC_60559_BFP_EXT__ = 1,
        .__STDC_WANT_IEC_60559_DFP_EXT__ = 1,
        .__STDC_WANT_IEC_60559_FUNCS_EXT__ = 1,
        .__STDC_WANT_IEC_60559_TYPES_EXT__ = 1,
        .__STDC_WANT_LIB_EXT2__ = 1,
        .__STDC_WANT_MATH_SPEC_FUNCS__ = 1,
        ._TANDEM_SOURCE = 1,
        ._XOPEN_SOURCE = {},
        .VERSION = "5.3.2",
        ._FILE_OFFSET_BITS = {},
        ._LARGE_FILES = {},
        .__CHAR_UNSIGNED__ = {},
        .__STDC_NO_VLA__ = {},
        .@"const" = {},
        .gid_t = {},
        .@"inline" = {},
        .intmax_t = {},
        .pid_t = {},
        .restrict = .__restrict__,
        .size_t = {},
        .socklen_t = {},
        .ssize_t = {},
        .uid_t = {},
        .uintmax_t = {},
    });

    const mod = b.addModule("awk", .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    mod.addIncludePath(config_h.getOutputDir());
    mod.addCSourceFiles(.{
        .files = Sources.root,
        .root = awk_dep.path(""),
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
        .files = Sources.support,
        .root = awk_dep.path("support"),
        .flags = &.{
            "-DGAWK",
            "-DHAVE_CONFIG_H",
        },
    });
    libsupport.addIncludePath(awk_dep.path(""));
    libsupport.addIncludePath(awk_dep.path("support"));

    mod.linkLibrary(libsupport);

    mod.addCSourceFiles(.{
        .files = Sources.extension,
        .root = awk_dep.path("extension"),
    });
    mod.addCSourceFiles(.{
        .files = Sources.awklib,
        .root = awk_dep.path("awklib"),
    });
    mod.addIncludePath(awk_dep.path(""));
    mod.addIncludePath(awk_dep.path("support"));

    const exe = b.addExecutable(.{
        .name = "awk",
        .root_module = mod,
    });
    b.installArtifact(exe);
}

const Sources = struct {
    const root = &.{
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
        "gawkmisc.c",
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

    const support = &.{
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
        "pma.c",
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

    const awklib = &.{
        "pwcat.c",
        "grcat.c",
        "eg/lib/grcat.c",
        "eg/lib/pwcat.c",
    };
};
