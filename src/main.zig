const std = @import("std");
const cat = @import("cat.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const path = if (args.len > 1) args[1] else null;


    var writer = std.Io.File.Writer.init(.stdout(), io, &.{}); // No write buffer.
    const writer_interface = &writer.interface;

    if (path) |file_path| {
        const opened_file = try cat.getFile(io, file_path);
        defer opened_file.close(io);

        try cat.copyFileToWriter(io, opened_file, writer_interface);
    } else {
        try cat.copyFileToWriter(io, std.Io.File.stdin(), writer_interface);
    }
}

