import tkinter, random

t = tkinter.Tk()
# nepytajte sa preco -5, canvas je divny :D
c = tkinter.Canvas(width=50 * 13 - 5, height=50 * 13 - 5, bg="white")
c.pack()

maze = [
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1],
    [1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1],
    [1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1],
    [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
    [1, 0, 1, 0, 1, 1, 0, 1, 1, 0, 1, 0, 1],
    [1, 0, 1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1],
    [1, 0, 0, 0, 1, 1, 0, 1, 1, 0, 0, 0, 1],
    [1, 0, 1, 0, 0, 1, 0, 1, 0, 0, 1, 0, 1],
    [1, 0, 1, 1, 0, 1, 0, 1, 0, 1, 1, 0, 1],
    [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
    [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
]

players_turn = True
started = False


class Player:
    def __init__(self, canvas, maze, balls) -> None:
        self.grid_x = random.randint(0, 12)
        self.grid_y = random.randint(0, 12)
        self.size = 50
        self.id = None
        self.canvas = canvas
        self.maze = maze
        self.balls = balls
        self.balls_collected = 0

    def draw(self, canvas, maze):
        while maze[self.grid_y][self.grid_x] == 1:
            self.grid_x = random.randint(0, 12)
            self.grid_y = random.randint(0, 12)
        self.id = canvas.create_oval(
            self.grid_x * self.size,
            self.grid_y * self.size,
            self.grid_x * self.size + self.size,
            self.grid_y * self.size + self.size,
            fill="yellow",
        )

    def move(self, x, y, balls):
        if self.maze[self.grid_y + y][self.grid_x + x] == 0:
            self.grid_x += x
            self.grid_y += y
            self.canvas.move(self.id, x * self.size, y * self.size)
            self.check_collision(balls)
        print(self.balls_collected)

    def check_collision(self, balls):
        player_coords = self.canvas.coords(self.id)
        for ball in balls:
            if (
                abs(player_coords[0] - ball.canvas.coords(ball.id)[0]) < 30
                and abs(player_coords[1] - ball.canvas.coords(ball.id)[1]) < 30
            ):
                self.balls_collected += 1
                ball.respawn()
                break


class Ball:
    def __init__(self, canvas, maze, player) -> None:
        self.grid_x = random.randint(0, 12)
        self.grid_y = random.randint(0, 12)
        self.grid_size = 50
        self.size = 30
        self.id = None
        self.canvas = canvas
        self.maze = maze
        self.player = player

    def draw(self):
        while self.maze[self.grid_y][self.grid_x] == 1 or (
            self.grid_x == self.player.grid_x and self.grid_y == self.player.grid_y
        ):
            self.grid_x = random.randint(0, 12)
            self.grid_y = random.randint(0, 12)
        self.id = self.canvas.create_oval(
            self.grid_x * self.grid_size + 10,
            self.grid_y * self.grid_size + 10,
            self.grid_x * self.grid_size + self.grid_size - 10,
            self.grid_y * self.grid_size + self.grid_size - 10,
            fill="white",
        )

    def delete(self):
        self.canvas.delete(self.id)

    def respawn(self):
        self.delete()
        self.old_grid_x = self.grid_x
        self.old_grid_y = self.grid_y
        self.grid_x = random.randint(0, 12)
        self.grid_y = random.randint(0, 12)
        while (
            self.maze[self.grid_y][self.grid_x] == 1
            or (self.grid_x == self.player.grid_x and self.grid_y == self.player.grid_y)
            or (self.grid_x == self.old_grid_x and self.grid_y == self.old_grid_y)
        ):
            self.grid_x = random.randint(0, 12)
            self.grid_y = random.randint(0, 12)
        self.id = self.canvas.create_oval(
            self.grid_x * self.grid_size + 10,
            self.grid_y * self.grid_size + 10,
            self.grid_x * self.grid_size + self.grid_size - 10,
            self.grid_y * self.grid_size + self.grid_size - 10,
            fill="white",
        )


class Enemy:
    def __init__(self, canvas, maze, player, balls) -> None:
        self.grid_x = random.randint(0, 12)
        self.grid_y = random.randint(0, 12)
        self.size = 50
        self.id = None
        self.canvas = canvas
        self.maze = maze
        self.player = player
        self.balls = balls
        self.visited = []

    def draw(self):
        while (
            self.maze[self.grid_y][self.grid_x] == 1
            or (self.grid_x == self.player.grid_x and self.grid_y == self.player.grid_y)
            or any(
                [
                    self.grid_x == ball.grid_x and self.grid_y == ball.grid_y
                    for ball in self.balls
                ]
            )
        ):
            self.grid_x = random.randint(0, 12)
            self.grid_y = random.randint(0, 12)
        self.id = self.canvas.create_oval(
            self.grid_x * self.size,
            self.grid_y * self.size,
            self.grid_x * self.size + self.size,
            self.grid_y * self.size + self.size,
            fill="red",
        )
        self.move()

    def move(self):
        directions = [(0, -1), (0, 1), (-1, 0), (1, 0)]
        tries = 0

        while tries < 4:
            x, y = random.choice(directions)
            new_x = self.grid_x + x
            new_y = self.grid_y + y

            if not (0 <= new_x < len(self.maze[0]) and 0 <= new_y < len(self.maze)):
                tries += 1
                continue

            if (
                self.maze[new_y][new_x] == 1
                or (new_x == self.player.grid_x and new_y == self.player.grid_y)
                or (new_x, new_y) in self.visited
            ):
                tries += 1
                continue

            self.grid_x = new_x
            self.grid_y = new_y
            self.visited.append((self.grid_x, self.grid_y))
            self.canvas.move(self.id, x * self.size, y * self.size)
            break

        if tries >= 4:
            self.visited = []
        self.canvas.after(1000, self.move)


def draw_maze():
    for y in range(13):
        for x in range(13):
            if maze[y][x] == 1:
                c.create_rectangle(
                    x * 50, y * 50, x * 50 + 50, y * 50 + 50, fill="blue"
                )
            else:
                c.create_rectangle(
                    x * 50, y * 50, x * 50 + 50, y * 50 + 50, fill="black"
                )


def draw_balls():
    global balls
    balls = []
    for i in range(10):
        ball = Ball(c, maze, player)
        ball.draw()
        balls.append(ball)


def draw_enemy():
    global enemies
    enemies = []
    for i in range(3):
        enemy = Enemy(c, maze, player, balls)
        enemy.draw()
        enemies.append(enemy)


def move_player(event):
    global players_turn
    if not players_turn:
        return
    x, y = 0, 0
    if event.keysym == "Up":
        y = -50
    elif event.keysym == "Down":
        y = 50
    elif event.keysym == "Left":
        x = -50
    elif event.keysym == "Right":
        x = 50
    player.move(x // 50, y // 50, balls)


def game(event):
    global started
    if started:
        return
    draw_maze()
    player.draw(c, maze)
    draw_balls()
    draw_enemy()
    started = True


balls = []
player = Player(c, maze, balls)

t.bind("<space>", game)
t.bind("<KeyPress>", move_player)
t.mainloop()
