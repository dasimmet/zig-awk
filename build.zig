const std = @import("std");

pub fn build(b: *std.Build) void {
    const target = b.standardTargetOptions(.{});
    const optimize = b.standardOptimizeOption(.{});
    const awk_dep = b.dependency("awk", .{});
    const yacc_dep = b.dependency("oyacc", .{});

    const yacc = b.addRunArtifact(yacc_dep.artifact("yacc"));
    yacc.addArgs(&.{ "-d", "-b", "awkgram", "-o" });
    const awkgram_tab = yacc.addOutputFileArg("awkgram.tab.c");
    yacc.addFileArg(awk_dep.path("awkgram.y"));

    const maketab = b.addExecutable(.{
        .name = "maketab",
        .root_module = b.createModule(.{
            .target = b.graph.host,
            .optimize = .ReleaseSmall,
            .link_libc = true,
        }),
    });
    maketab.addIncludePath(awkgram_tab.dirname());
    maketab.addCSourceFile(.{
        .file = awk_dep.path("maketab.c"),
        .flags = flags,
    });
    const mt_run = b.addRunArtifact(maketab);
    mt_run.addFileArg(awkgram_tab.dirname().path(b, "awkgram.tab.h"));
    const w_proc = b.addWriteFiles();
    const proctab = w_proc.addCopyFile(mt_run.captureStdOut(), "proctab.c");

    const mod = b.addModule("awk", .{
        .target = target,
        .optimize = optimize,
        .link_libc = true,
    });
    mod.addIncludePath(awk_dep.path(""));
    mod.addIncludePath(awkgram_tab.dirname());
    mod.addCSourceFile(.{
        .file = proctab,
        .flags = flags,
    });
    mod.addCSourceFile(.{
        .file = awkgram_tab,
        .flags = flags,
    });
    mod.addCSourceFiles(.{
        .files = &.{
            "tran.c",
            "lib.c",
            "run.c",
            "lex.c",
            "main.c",
            "parse.c",
            "b.c",
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
    "-Wno-unused-but-set-variable",
    "-Wno-strict-prototypes",
    // "-Wno-inconsistent-dllimport",
    // "-Wno-implicit-function-declaration",
    // "-Wno-void-pointer-to-int-cast",
    // "-Wno-int-to-pointer-cast",
};
