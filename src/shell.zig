const std = @import("std");
const builtin_cmds = @import("builtin.zig");

pub const Shell = struct {
    allocator: std.mem.Allocator,
    io: std.Io,

    pub fn init(allocator: std.mem.Allocator, io: std.Io) Shell {
        return .{ 
            .allocator = allocator,
            .io = io,
        };
    }

    pub fn runLine(self: *Shell, line: []const u8) !void {
        var it = std.mem.tokenizeAny(u8, line, " \t\r\n");
        var args: std.ArrayList([]const u8) = .empty;
        defer args.deinit(self.allocator);

        while (it.next()) |arg| {
            try args.append(self.allocator, arg);
        }

        if (args.items.len == 0) return;

        const cmd_name = args.items[0];

        // Check builtins
        for (builtin_cmds.builtins) |builtin| {
            if (std.mem.eql(u8, cmd_name, builtin.name)) {
                try builtin.run(self.allocator, self.io, args.items);
                return;
            }
        }

        // Execute external command
        var child = try std.process.spawn(self.io, .{
            .argv = args.items,
        });
        _ = try child.wait(self.io);
    }
};
