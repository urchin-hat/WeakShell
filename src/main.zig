const std = @import("std");
const Shell = @import("shell.zig").Shell;

pub fn main(init: std.process.Init) !void {
    const arena = init.arena.allocator();
    var shell = Shell.init(arena, init.io);

    // Using std.debug.print for now as a shortcut, 
    // but for real input we need something else.
    // Let's try to use the new Io interface if we can.
    
    var buf: [1024]u8 = undefined;
    while (true) {
        std.debug.print("weak> ", .{});
        
        const n = try std.posix.read(std.posix.STDIN_FILENO, &buf);
        if (n == 0) break;
        
        const line = std.mem.trimEnd(u8, buf[0..n], " \t\r\n");
        if (line.len == 0) continue;
        
        shell.runLine(line) catch |err| {
            std.debug.print("Error: {}\n", .{err});
        };
    }
}

test {
    std.testing.refAllDecls(@This());
}
