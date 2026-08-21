const std = @import("std");

pub fn errorMessage(Error: anyerror) []const u8 {
    return switch (Error) {
        error.FileNotFound => "File doesn't exist",
        error.AccessDenied => "Permission denied",
        error.IsDir => "Is a directory",
        else => @errorName(Error),
    };
}
