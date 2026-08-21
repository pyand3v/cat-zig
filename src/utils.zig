const std = @import("std");

pub fn printError(io: std.Io, message: []const u8) !void {
    var writer = std.Io.File.writer(.stderr(), io, &.{});
    try writer.interface.print("Error: {s}", .{message});
    try writer.interface.flush();
}
