const std = @import("std");
const cat = @import("cat.zig");

pub fn main(init: std.process.Init) !void {
    const io = init.io;
    const args = try init.minimal.args.toSlice(init.arena.allocator());
    const path = args[1];

    try cat.copyFileToWriter(io, path);
}
 
