const std = @import("std");


pub fn getFile(io: std.Io, path: [:0]const u8) std.Io.File.OpenError!std.Io.File {
    const file = std.Io.Dir.cwd().openFile(io, path, .{ .mode = .read_only, .allow_directory = false }) catch | err | switch (err) {
        error.FileNotFound => return error.FileNotFound, // TODO: Makes no sense atm, but just as a reminder in case we extend this in the future
        else => return err,
    };
    return file;
}

pub fn copyFileToWriter(io: std.Io, file: std.Io.File, writer_interface: *std.Io.Writer) !void {
    var reader = file.reader(io, &.{}); // No read-ahead buffer.
    const reader_interface = &reader.interface;

    try copyReaderToWriter(reader_interface, writer_interface);
}

pub fn copyReaderToWriter(reader_interface: *std.Io.Reader, writer_interface: *std.Io.Writer) !void {
    var chunk: [4096]u8 = undefined;

    while (true) {
        const bytes_read = try reader_interface.readSliceShort(&chunk);

        if (bytes_read == 0) break;

        try writer_interface.writeAll(chunk[0..bytes_read]);
    }
}
