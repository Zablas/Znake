const std = @import("std");
const rl = @import("raylib");
const constants = @import("constants");

const DoublyLinkedList = std.DoublyLinkedList(rl.Vector2);
const Allocator = std.mem.Allocator;

pub const Snake = struct {
    deque: DoublyLinkedList,
    allocator: Allocator,

    pub fn init(allocator: Allocator) !Snake {
        var snake = Snake{
            .deque = DoublyLinkedList{},
            .allocator = allocator,
        };

        const node1 = try allocator.create(DoublyLinkedList.Node);
        node1.data = rl.Vector2{
            .x = 6,
            .y = 9,
        };
        snake.deque.append(node1);

        const node2 = try allocator.create(DoublyLinkedList.Node);
        node2.data = rl.Vector2{
            .x = 5,
            .y = 9,
        };
        snake.deque.append(node2);

        const node3 = try allocator.create(DoublyLinkedList.Node);
        node3.data = rl.Vector2{
            .x = 4,
            .y = 9,
        };
        snake.deque.append(node3);

        return snake;
    }

    pub fn deinit(self: *Snake) void {
        while (self.deque.pop()) |node| {
            self.allocator.destroy(node);
        }
    }

    pub fn draw(self: Snake) void {
        var curr = self.deque.first;
        while (curr != null) {
            const rectangle = rl.Rectangle{
                .x = curr.?.data.x * constants.grid_params.cell_size,
                .y = curr.?.data.y * constants.grid_params.cell_size,
                .height = constants.grid_params.cell_size,
                .width = constants.grid_params.cell_size,
            };
            rl.drawRectangleRounded(rectangle, 0.5, 6, constants.colors.dark_green);

            curr = curr.?.next;
        }
    }
};
