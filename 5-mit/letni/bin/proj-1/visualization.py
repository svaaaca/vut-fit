#!/usr/bin/env python3

__file__ = "visualization.py"
__author__ = "David Kvaček (xkvace00@stud.fit.vutbr.cz)"
__spec__ = "Pygame visualization module for displaying cellular automaton evolution."
__date__ = "2026-05-12"

import pygame

from automaton import CellularAutomaton
from config import BACKGROUND_COLOR, DEFAULT_STATE, FPS, GENERATIONS, GRID_COLOR, LAST_STEPS, POPULATION_SIZE, SIMULATION_STEPS, SPEED, SPEED_MAXIMUM, SPEED_MINIMUM, STATES, TILE_SIZE, WINDOW_HEIGHT, WINDOW_WIDTH


class PygameVisualizer:
    """Handles pygame visualization of the automaton and evolution."""

    def __init__(self: 'PygameVisualizer', cellular_automaton: CellularAutomaton, width: int = WINDOW_WIDTH, height: int = WINDOW_HEIGHT, tile_size: int = TILE_SIZE) -> None:
        """
        Initialize the pygame visualizer.

        Args:
            self (PygameVisualizer): The pygame visualizer instance.
            cellular_automaton (CellularAutomaton): The cellular automaton to visualize.
            width (int, optional): The width of the display window. Defaults to WINDOW_WIDTH.
            height (int, optional): The height of the display window. Defaults to WINDOW_HEIGHT.
            tile_size (int, optional): The size of each tile in the grid. Defaults to TILE_SIZE.
        """

        # initialize pygame and set up the display
        pygame.init()
        pygame.display.set_caption("Multi-state Cellular Automaton")

        self.screen = pygame.display.set_mode((width, height))
        self.cellular_automaton = cellular_automaton
        self.clock = pygame.time.Clock()
        self.speed = SPEED
        self.genome = None
        self.running = False
        self.tile_size = tile_size
        self.time = pygame.time.get_ticks()
        self.visualize = True


    def draw_grid(self: 'PygameVisualizer') -> None:
        """
        Draw the cellular automaton grid on the screen.

        Args:
            self (PygameVisualizer): The pygame visualizer instance.
        """

        # fill the background with a dark color
        self.screen.fill(BACKGROUND_COLOR)

        # draw each cell in the grid with its corresponding color based on its state
        for i in range(self.cellular_automaton.height):
            for j in range(self.cellular_automaton.width):
                state = self.cellular_automaton.grid[i, j]
                color = STATES.get(state, DEFAULT_STATE)
                pygame.draw.rect(self.screen, color, (j * self.tile_size, i * self.tile_size, self.tile_size, self.tile_size))

        # draw horizontal grid lines
        for i in range(self.cellular_automaton.height + 1):
            pygame.draw.line(self.screen, GRID_COLOR, (0, i * self.tile_size), (self.cellular_automaton.width * self.tile_size, i * self.tile_size), 1)

        # draw vertical grid lines
        for j in range(self.cellular_automaton.width + 1):
            pygame.draw.line(self.screen, GRID_COLOR, (j * self.tile_size, 0), (j * self.tile_size, self.cellular_automaton.height * self.tile_size), 1)


    def handle_events(self: 'PygameVisualizer') -> bool:
        """
        Handle pygame events for user interaction.

        Args:
            self (PygameVisualizer): The pygame visualizer instance.

        Returns:
            boolean (bool): True if the visualization should continue, False otherwise.
        """

        # process all pygame events (keyboard, mouse, quit)
        for event in pygame.event.get():

            # stop the visualization loop
            if event.type == pygame.QUIT:
                return False

            # handle keyboard events for controlling the simulation
            if event.type == pygame.KEYDOWN:

                # toggle running state when spacebar is pressed
                if event.key == pygame.K_SPACE:
                    self.running = not self.running

                # reset the cellular automaton to a new random state when 'R' is pressed
                if event.key == pygame.K_r:
                    self.cellular_automaton.reset()

                # clear the grid when 'C' is pressed
                if event.key == pygame.K_c:
                    self.cellular_automaton.grid.fill(0)

                # speed up the animation when up arrow is pressed
                if event.key == pygame.K_UP:
                    self.speed = max(SPEED_MINIMUM, self.speed - 60)

                # slow down the animation when down arrow is pressed
                if event.key == pygame.K_DOWN:
                    self.speed = min(SPEED_MAXIMUM, self.speed + 60)

                # step forward one generation when 'N' is pressed (only if paused and genome is set)
                if event.key == pygame.K_n and not self.running and self.genome:
                    self.cellular_automaton.step(self.genome)

            # allow cycling cell states by clicking on the grid (only if paused)
            if event.type == pygame.MOUSEBUTTONDOWN and not self.running:

                # determine which cell was clicked and cycle its state
                x, y = event.pos
                col = x // self.tile_size
                row = y // self.tile_size

                # ensure the clicked position is within the grid bounds before updating the cell state
                if 0 <= row < self.cellular_automaton.height and 0 <= col < self.cellular_automaton.width:
                    self.cellular_automaton.grid[row, col] = (self.cellular_automaton.grid[row, col] + 1) % self.cellular_automaton.states

        return True


    def run(self: 'PygameVisualizer') -> None:
        """
        Run the visualization loop.

        Args:
            self (PygameVisualizer): The pygame visualizer instance.
        """

        # run the visualization loop
        while self.visualize:
            self.visualize = self.handle_events()
            self.update()

        # quit pygame when the loop ends
        pygame.quit()


    def set_genome(self: 'PygameVisualizer', genome) -> None:
        """
        Set the genome for the cellular automaton and reset the grid.

        Args:
            self (PygameVisualizer): The pygame visualizer instance.
            genome (Genome): The genome to use for updates.
        """

        # set the genome for the cellular automaton and reset the grid to start fresh with the new rules
        self.genome = genome
        self.cellular_automaton.reset()


    def update(self: 'PygameVisualizer') -> None:
        """
        Update the cellular automaton and redraw the grid.

        Args:
            self (PygameVisualizer): The pygame visualizer instance.
        """

        # step the cellular automaton according to the genome's rules at the specified speed interval
        current = pygame.time.get_ticks()
        if self.genome and self.running:
            if current - self.time >= self.speed:
                self.cellular_automaton.step(self.genome)
                self.time = current

        # draw the updated grid and display the genetic algorithm information in the window title
        self.draw_grid()
        pygame.display.set_caption(f"PygameVisualizer ({'Running' if self.running else 'Paused'}) | Generations: {GENERATIONS} | Population Size: {POPULATION_SIZE} | Shannon Entropy: {self.cellular_automaton.calculate_entropy():.4f} | Simulation Steps: {SIMULATION_STEPS} (using the last {LAST_STEPS} steps) | Speed: {1000 / self.speed:.2f} steps/sec | States: {len(STATES)} | Step: {len(self.cellular_automaton.history)}")
        pygame.display.update()
        self.clock.tick(FPS)
