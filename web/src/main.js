import "./style.css";
import { CanvasRenderer, GRID_SIZE } from "./canvasRenderer.js";
import { createWasmImports, parseGolConfig } from "./wasmImports.js";

const CONFIG_FILES = [
  "glider.gol",
  "blinker.gol",
  "block.gol",
  "toad.gol",
  "beacon.gol",
  "lwss.gol",
  "pulsar.gol",
  "pentadecathlon.gol",
  "rpentomino.gol",
  "acorn.gol",
  "diehard.gol"
];

// On recup les elements dont on a besoin
const canvas = requireElement("life-canvas");
const toggleRunButton = requireElement("toggle-run");
const stepButton = requireElement("step");
const resetButton = requireElement("reset");
const configSelect = requireElement("config-select");
const speedInput = requireElement("speed");
const speedValue = requireElement("speed-value");
const generationOutput = requireElement("generation");
const statusText = requireElement("status");
const patternName = requireElement("pattern-name");
const population = requireElement("population");

const renderer = new CanvasRenderer(canvas, GRID_SIZE);

let wasmModule = null;
let configs = [];
let game = null;
let generation = 0;
let running = false;
let timerId = null;

// Listeners pour les input et interactions
toggleRunButton.addEventListener("click", () => {
  if (running) {
    pause();
  } else {
    start();
  }
});

stepButton.addEventListener("click", () => {
  pause();
  step();
});

resetButton.addEventListener("click", () => {
  resetGame().catch(showError);
});

configSelect.addEventListener("change", () => {
  resetGame().catch(showError);
});

speedInput.addEventListener("input", () => {
  updateSpeedLabel();
  if (running) {
    restartTimer();
  }
});

main().catch(showError);

async function main() {
  updateSpeedLabel();
  setStatus("Chargement");
  wasmModule = await loadWasmModule();
  configs = await loadConfigs();
  populateConfigSelect(configs);
  await resetGame();
  setControlsEnabled(true);
}

async function loadWasmModule() {
  const response = await fetch("/game_of_life.wasm");
  if (!response.ok) {
    throw new Error(`Impossible de charger game_of_life.wasm (${response.status})`);
  }

  return WebAssembly.compile(await response.arrayBuffer());
}

async function loadConfigs() {
  const loadedConfigs = await Promise.all(
    CONFIG_FILES.map(async (fileName) => {
      const response = await fetch(`/configs/${fileName}`);
      if (!response.ok) {
        throw new Error(`Impossible de charger ${fileName} (${response.status})`);
      }

      return parseGolConfig(fileName, await response.text());
    })
  );

  return loadedConfigs;
}

function populateConfigSelect(availableConfigs) {
  configSelect.replaceChildren();

  for (const config of availableConfigs) {
    const option = document.createElement("option");
    option.value = config.fileName;
    option.textContent = config.name;
    configSelect.append(option);
  }

  configSelect.value = "glider.gol";
}

async function resetGame() {
  const module = wasmModule;
  const config = selectedConfig();
  if (module === null || config === null) {
    return;
  }

  pause();
  renderer.reset();
  generation = 0;
  const wasmImports = createWasmImports(config, renderer, { gridSize: GRID_SIZE });
  const instance = await WebAssembly.instantiate(module, wasmImports);
  game = assertGameExports(instance.exports);
  game.display_board();
  updateDetails(config);
  updateGeneration();
  setStatus("Pret");
}

function selectedConfig() {
  const fileName = configSelect.value || "glider.gol";
  return configs.find((config) => config.fileName === fileName) ?? configs[0] ?? null;
}

function assertGameExports(exports) {
  const expected = ["display_board", "iteration", "alternate"];
  for (const name of expected) {
    if (typeof exports[name] !== "function") {
      throw new Error(`Export Wasm manquant: ${name}`);
    }
  }

  return exports;
}

function start() {
  if (game === null || running) {
    return;
  }

  running = true;
  toggleRunButton.textContent = "Pause";
  setStatus("En cours");
  restartTimer();
}

function pause() {
  if (timerId !== null) {
    window.clearInterval(timerId);
    timerId = null;
  }

  running = false;
  toggleRunButton.textContent = "Start";
  if (game !== null) {
    setStatus("Pret");
  }
}

function restartTimer() {
  if (!running) {
    return;
  }

  if (timerId !== null) {
    window.clearInterval(timerId);
  }

  timerId = window.setInterval(step, speedDelay());
}

function step() {
  if (game === null) {
    return;
  }

  game.iteration();
  game.alternate();
  game.display_board();
  generation += 1;
  updateGeneration();
}

function speedDelay() {
  return Number.parseInt(speedInput.value, 10);
}

function updateSpeedLabel() {
  speedValue.value = `${speedDelay()} ms`;
  speedValue.textContent = `${speedDelay()} ms`;
}

function updateGeneration() {
  generationOutput.value = String(generation);
  generationOutput.textContent = String(generation);
}

function updateDetails(config) {
  patternName.textContent = config.name;
  population.textContent = String(config.aliveCells.length);
}

function setControlsEnabled(enabled) {
  toggleRunButton.disabled = !enabled;
  stepButton.disabled = !enabled;
  resetButton.disabled = !enabled;
  configSelect.disabled = !enabled;
}

function setStatus(status) {
  statusText.textContent = status;
}

function showError(error) {
  pause();
  setStatus("Erreur");
  console.error(error);
  const message = error instanceof Error ? error.message : String(error);
  statusText.textContent = message;
}

function requireElement(id) {
  const element = document.getElementById(id);
  if (element === null) {
    throw new Error(`Element #${id} introuvable`);
  }

  return element;
}
