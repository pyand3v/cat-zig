const std = @import("std");

pub fn getFile(io: std.Io, path: [:0]const u8) std.Io.File.OpenError!std.Io.File {
    return std.Io.Dir.cwd().openFile(io, path, .{ .mode = .read_only, .allow_directory = false });
}

pub fn copyFileToWriter(io: std.Io, file: std.Io.File, writer_interface: *std.Io.Writer) !void {
    var reader = file.reader(io, &.{}); // No read-ahead buffer.
    const reader_interface = &reader.interface;

    try copyReaderToWriter(reader_interface, writer_interface);
}

pub fn copyReaderToWriter(reader_interface: *std.Io.Reader, writer_interface: *std.Io.Writer) !void {
    var chunk: [4096]u8 = undefined;
    var buffers: [1][]u8 = .{&chunk};

    while (true) {
        const bytes_read = reader_interface.readVec(&buffers) catch |err| switch (err) {
            error.EndOfStream => break,
            else => return err,
        };

        if (bytes_read == 0) continue;

        try writer_interface.writeAll(chunk[0..bytes_read]);
    }
}
