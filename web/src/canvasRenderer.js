export const GRID_SIZE = 42;
export const CELL_SIZE = 16;
const LIVE_CELL_COLOR = "#0079f1";

export class CanvasRenderer {
  constructor(canvas, gridSize = GRID_SIZE, cellSize = CELL_SIZE) {
    const context = canvas.getContext("2d");
    if (context === null) {
      throw new Error("Canvas 2D indisponible");
    }

    this.canvas = canvas;
    this.gridSize = gridSize;
    this.cellSize = cellSize;
    this.context = context;
    this.frame = this.createEmptyFrame();
    this.cursorRow = 0;
    this.cursorCol = 0;
    this.canvas.width = this.gridSize * this.cellSize;
    this.canvas.height = this.gridSize * this.cellSize;
    this.clearFrame();
    this.draw();
  }

  printCell(value) {
    if (this.cursorRow >= this.gridSize || this.cursorCol >= this.gridSize) {
      return;
    }

    this.frame[this.cursorRow][this.cursorCol] = value === 0 ? 0 : 1;
    this.cursorCol += 1;
  }

  newline() {
    this.cursorRow += 1;
    this.cursorCol = 0;
  }

  clearScreen() {
    this.draw();
    this.clearFrame();
  }

  reset() {
    this.clearFrame();
    this.draw();
  }

  clearFrame() {
    for (let row = 0; row < this.gridSize; row += 1) {
      this.frame[row].fill(0);
    }

    this.cursorRow = 0;
    this.cursorCol = 0;
  }

  createEmptyFrame() {
    return Array.from({ length: this.gridSize }, () =>
      Array(this.gridSize).fill(0)
    );
  }

  draw() {
    const width = this.gridSize * this.cellSize;
    const height = this.gridSize * this.cellSize;

    this.context.fillStyle = "#e4e4e4";
    this.context.fillRect(0, 0, width, height);

    for (let row = 0; row < this.gridSize; row += 1) {
      for (let col = 0; col < this.gridSize; col += 1) {
        if (this.frame[row][col] === 1) {
          this.drawLiveCell(row, col);
        }
      }
    }

    this.drawGrid(width, height);
  }

  drawLiveCell(row, col) {
    const x = col * this.cellSize;
    const y = row * this.cellSize;

    this.context.fillStyle = LIVE_CELL_COLOR;
    this.context.fillRect(x, y, this.cellSize, this.cellSize);
  }

  drawGrid(width, height) {
    this.context.strokeStyle = "#c0c0c0";
    this.context.lineWidth = 1;
    this.context.beginPath();

    for (let index = 0; index <= this.gridSize; index += 1) {
      const position = index * this.cellSize + 0.5;
      this.context.moveTo(position, 0);
      this.context.lineTo(position, height);
      this.context.moveTo(0, position);
      this.context.lineTo(width, position);
    }

    this.context.stroke();
  }
}
