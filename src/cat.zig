const std = @import("std");

pub fn getFile(io: std.Io, path: [:0]const u8) std.Io.File.OpenError!std.Io.File {
    const file = std.Io.Dir.cwd().openFile(io, path, .{ .mode = .read_only, .allow_directory = false }) catch | err | switch (err) {
        error.FileNotFound => return error.FileNotFound, // TODO: Makes no sense atm, but just as a reminder in case we extend this in the future
        else => return err,
    };
    return file;
}

pub fn copyFileToWriter(io: std.Io, path: [:0]const u8) !void {
    const file = try getFile(io, path);
    defer file.close(io);

    var reader = file.reader(io, &.{}); // []u8
    var reader_interface = &reader.interface;

    var stdout_file_writer = std.Io.File.Writer.init(.stdout(), io, &.{});
    const stdout_writer = &stdout_file_writer.interface; 

    var chunk: [4096]u8 = undefined;

    while (true) {
        const bytes_read = try reader_interface.readSliceShort(&chunk);

        if (bytes_read == 0) break;

        try stdout_writer.writeAll(chunk[0..bytes_read]);
    }
    // try stdout_writer.flush();
    // Completely useless since we are working on a zero bytes writer.
}
