const std = @import("std");
const cat = @import("cat.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const paths = args[1..];

    var writer = std.Io.File.Writer.init(.stdout(), io, &.{}); // No write buffer.
    const writer_interface = &writer.interface;

    for (paths) |file_path| {
        if (std.mem.eql(u8, file_path, "-")) {
            try cat.copyFileToWriter(io, std.Io.File.stdin(), writer_interface);
        }

        const opened_file = try cat.getFile(io, file_path);
        defer opened_file.close(io);

        try cat.copyFileToWriter(io, opened_file, writer_interface);
    }
}
