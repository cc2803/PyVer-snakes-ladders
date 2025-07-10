import pygame
import random
import time

pygame.init()

# Load and scale the board image
board = pygame.image.load("SNL.jpg")
image = pygame.transform.scale(board, (600, 600))

# Initialize Pygame window
window = pygame.display.set_mode((800, 520), pygame.RESIZABLE)
pygame.display.set_caption('Snakes and Ladders')

# Define colors
bg_color = (7, 10, 80)
pin_color = (0, 0, 0)  # Black for the pin

# Define grid properties
grid_size = 6
cell_size = 100  # Assuming 600x600 board divided into 6x6 grid
positions = []  # Holds the center of each cell

# Generate grid positions
for row in range(grid_size):
    for col in range(grid_size):
        x = 375 + (col * cell_size)
        y = 50 + (5 - row) * cell_size
        if row % 2 == 0:
            positions.append((x + cell_size // 2, y + cell_size // 2))
        else:
            positions.append((375 + ((5 - col) * cell_size) + cell_size // 2, y + cell_size // 2))

# Pin setup
pin_radius = 25
current_position = 0

def draw_board():
    window.fill(bg_color)
    window.blit(image, (375, 50))

def draw_pin():
    pin_x, pin_y = positions[current_position]
    pygame.draw.circle(window, pin_color, (pin_x, pin_y), pin_radius)

def write_to_file(dice_value):
    with open("dice.txt", "w") as file:
        file.write(f"{dice_value}\n")

def read_from_file():
    while True:  # Keep trying until the file is updated
        try:
            with open("player_state.txt", "r") as file:
                lines = file.read().strip()
                return int(lines)  # Read updated position
        except ValueError:
            time.sleep(0.1)  # Wait a bit before retrying

def resetPlayerpos():
    with open("player_state.txt", 'w') as file:
        file.write("0")  # Write as string


# Initialize Pygame clock
clock = pygame.time.Clock()

# Game loop
running = True
while running:
    for event in pygame.event.get():
        if event.type == pygame.QUIT:
            running = False
            write_to_file(0)
            resetPlayerpos()

        if event.type == pygame.KEYDOWN:
            if event.key == pygame.K_SPACE:

                dice_value = random.randint(1, 6)
                print(f"Dice rolled: {dice_value}")
                write_to_file(dice_value)

                time.sleep(4)   #DICE RESET TIMER/ NEW DIE ROLL ACCEPTANCE TIMER  (ideal = 4)
                current_position = read_from_file()-1
                write_to_file(0)
                
                
                if current_position == 0 and dice_value != 1:
                    print("Game requires dice roll of 1 to start!")
                    continue

    draw_board()
    draw_pin()
    pygame.display.flip()

    # Limit frame rate to 30 FPS
    clock.tick(30)

pygame.quit()
