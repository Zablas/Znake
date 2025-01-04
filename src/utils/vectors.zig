const std = @import("std");
const rl = @import("raylib");

pub fn isElementInDeque(element: rl.Vector2, node: ?*std.DoublyLinkedList(rl.Vector2).Node) bool {
    var curr = node;

    while (curr != null) {
        if (rl.math.vector2Equals(element, curr.?.data) == 1) {
            return true;
        }
        curr = curr.?.prev;
    }

    return false;
}
