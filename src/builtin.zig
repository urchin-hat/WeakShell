const std = @import("std");

pub const BuiltinCommand = struct {
    name: []const u8,
    run: *const fn (allocator: std.mem.Allocator, io: std.Io, args: [][]const u8) anyerror!void,
};

pub const builtins = [_]BuiltinCommand{
    .{ .name = "cd", .run = cd },
    .{ .name = "exit", .run = exit },
};

fn cd(allocator: std.mem.Allocator, io: std.Io, args: [][]const u8) anyerror!void {
    _ = allocator;
    if (args.len < 2) return;
    
    // In 0.16.0, we use io to open the directory and then setCurrentDir.
    var dir = try std.Io.Dir.openDir(std.Io.Dir.cwd(), io, args[1], .{});
    defer dir.close(io);
    try std.process.setCurrentDir(io, dir);
}

fn exit(allocator: std.mem.Allocator, io: std.Io, args: [][]const u8) anyerror!void {
    _ = allocator;
    _ = io;
    _ = args;
    std.process.exit(0);
}
