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

    const mod = b.addModule("awk", .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });

    // mod.addIncludePath(awk_dep.path(""));
    // mod.addIncludePath(awkgram_tab.dirname());
    // mod.addCSourceFile(.{ .file = proctab });
    // mod.addCSourceFile(.{ .file = awkgram_tab });
    // mod.addCSourceFiles(.{
    //     .files = &.{
    //         "tran.c",
    //         "lib.c",
    //         "run.c",
    //         "lex.c",
    //         "main.c",
    //         "parse.c",
    //         "b.c",
    //     },
    //     .root = awk_dep.path(""),
    // });
    mod.addCSourceFiles(.{
        .files = Sources.root,
        .root = awk_dep.path(""),
        .flags = flags,
    });
    // mod.addIncludePath(b.path("src"));

    const libsupport = b.addLibrary(.{
        .name = "support",
        .root_module = b.createModule(.{
            .target = target,
            .optimize = optimize,
            .link_libc = true,
        }),
    });
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
