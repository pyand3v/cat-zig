const std = @import("std");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const path = args[1];

    const file = try std.Io.Dir.cwd().openFile(io, path, .{ .mode = .read_only, .allow_directory = false });
    defer file.close(io);

    var reader = file.reader(io, &.{}); // [4096]u8
    var reader_interface = &reader.interface;

    // const content = try reader_interface.allocRemaining(init.arena.allocator(), .limited(1024*1024));

    var stdout_file_writer = std.Io.File.Writer.init(.stdout(), io, &.{});
    const stdout_writer = &stdout_file_writer.interface; 

    var chunk: [4096]u8 = undefined;

    while (true) {
        const bytes_read = try reader_interface.readSliceShort(&chunk);

        if (bytes_read == 0) break;
        
        try stdout_writer.writeAll(chunk[0..bytes_read]);
    }
    try stdout_writer.flush();
}

