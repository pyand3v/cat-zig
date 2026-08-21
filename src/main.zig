const std = @import("std");
const cat = @import("cat.zig");
const error_handler = @import("error_handler.zig");
const utils = @import("utils.zig");

const errorMessage = error_handler.errorMessage;
const printError = utils.printError;

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const paths = args[1..];

    var writer = std.Io.File.Writer.init(.stdout(), io, &.{}); // No write buffer.
    const writer_interface = &writer.interface;

    for (paths) |file_path| {
        if (std.mem.eql(u8, file_path, "-")) {
            try cat.copyFileToWriter(io, std.Io.File.stdin(), writer_interface);
            break;
        }

        const opened_file = cat.getFile(io, file_path) catch |err| {
            try printError(io, errorMessage(err));
            continue;
        };
        defer opened_file.close(io);

        try cat.copyFileToWriter(io, opened_file, writer_interface);
    }
}
