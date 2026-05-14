export function parseGolConfig(fileName, content) {
  let name = readableName(fileName);
  let offsetRow = 0;
  let offsetCol = 0;
  let inPattern = false;
  const patternLines = [];

  for (const rawLine of content.split(/\r?\n/)) {
    const line = rawLine.trim();
    if (line.length === 0 || line.startsWith("#")) {
      continue;
    }

    if (!inPattern && line.startsWith("name ")) {
      name = line.slice("name ".length).trim() || name;
      continue;
    }

    if (!inPattern && line.startsWith("offset ")) {
      const [row, col] = line
        .slice("offset ".length)
        .trim()
        .split(/\s+/)
        .map((value) => Number.parseInt(value, 10));

      if (Number.isInteger(row) && Number.isInteger(col)) {
        offsetRow = row;
        offsetCol = col;
      }
      continue;
    }

    inPattern = true;
    patternLines.push(line);
  }

  const aliveCells = [];
  for (const [row, line] of patternLines.entries()) {
    for (const [col, cell] of Array.from(line).entries()) {
      if (cell === "O") {
        aliveCells.push([offsetRow + row, offsetCol + col]);
      }
    }
  }

  return {
    fileName,
    name,
    offsetRow,
    offsetCol,
    aliveCells,
    aliveSet: new Set(aliveCells.map(([row, col]) => cellKey(row, col)))
  };
}

export function createWasmImports(config, renderer, { gridSize }) {
  const dimensions = [gridSize, gridSize];
  let readIndex = 0;

  return {
    ono: {
      read_int: () => dimensions[readIndex++] ?? gridSize,
      is_alive_init: (row, col) =>
        config.aliveSet.has(cellKey(row, col)) ? 1 : 0,
      print_cell: (cell) => renderer.printCell(cell),
      newline: () => renderer.newline(),
      clear_screen: () => renderer.clearScreen(),
      sleep: () => undefined,
      get_steps: () => 0,
      get_show_latest: () => -1,
      print_i32: (value) => console.log(value)
    }
  };
}

function cellKey(row, col) {
  return `${row}:${col}`;
}

function readableName(fileName) {
  return fileName
    .replace(/\.gol$/i, "")
    .split(/[-_]/)
    .filter(Boolean)
    .map((part) => part.charAt(0).toUpperCase() + part.slice(1))
    .join(" ");
}
