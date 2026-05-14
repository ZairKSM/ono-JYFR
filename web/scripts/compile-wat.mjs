import fs from "node:fs/promises";
import path from "node:path";
import { fileURLToPath } from "node:url";
import wabt from "wabt";

const scriptDir = path.dirname(fileURLToPath(import.meta.url));
const webDir = path.resolve(scriptDir, "..");
const repoRoot = path.resolve(webDir, "..");
const inputPath = path.join(repoRoot, "game-of-life", "game_of_life.wat");
const outputPath = path.join(webDir, "public", "game_of_life.wasm");

const wabtModule = await wabt();
const source = await fs.readFile(inputPath, "utf8");
const wasmModule = wabtModule.parseWat(inputPath, source);


try {
  wasmModule.resolveNames();
  wasmModule.validate();
  const { buffer } = wasmModule.toBinary({
    log: false,
    write_debug_names: true
  });

  await fs.mkdir(path.dirname(outputPath), { recursive: true });
  await fs.writeFile(outputPath, Buffer.from(buffer));
  console.log(`Compiled ${path.relative(webDir, inputPath)} -> ${path.relative(webDir, outputPath)}`);
} finally {
  wasmModule.destroy();
}
