/**
 * File Icons
 *
 * Fills the file explorer's leading slot with a coloured icon per file type.
 * Slots are keyed by exact path, so every path in the workspace is listed up
 * front: `git ls-files` inside a repo (matching the explorer's gitignore
 * handling), a bounded directory walk elsewhere.
 *
 * Icon set: "nerd" needs a Nerd Font in the terminal; "unicode" draws a
 * coloured dot that any font can show; "auto" follows editor.nerd_font_icons.
 *
 * Only the leading slot is set, so this composes with git_explorer's badges
 * and name colours (each slot field resolves independently).
 */
const editor = getEditor();

const NAMESPACE = "file-icons";
const PRIORITY = 10;
const WALK_MAX_DEPTH = 8;
const WALK_MAX_ENTRIES = 20000;
const WALK_SKIP = new Set([".git", "node_modules", "bin", "obj", "target", "dist", ".venv", "__pycache__"]);

type RGB = [number, number, number];
type Icon = [string, RGB];

editor.defineConfigEnum("iconSet", {
  values: ["auto", "nerd", "unicode"] as const,
  default: "auto",
  description: "Glyphs to use: nerd (needs a Nerd Font), unicode (coloured dot), or auto (follow editor.nerd_font_icons)",
});
editor.defineConfigBoolean("folderIcons", {
  default: true,
  description: "Show icons on directories too",
});

const C = {
  blue: [81, 154, 186] as RGB,
  tsBlue: [49, 120, 198] as RGB,
  yellow: [203, 203, 65] as RGB,
  orange: [227, 121, 51] as RGB,
  red: [204, 62, 68] as RGB,
  green: [141, 193, 73] as RGB,
  purple: [160, 116, 196] as RGB,
  csPurple: [104, 33, 122] as RGB,
  pink: [246, 116, 167] as RGB,
  cyan: [97, 218, 251] as RGB,
  grey: [109, 128, 134] as RGB,
  white: [212, 215, 214] as RGB,
  folder: [144, 164, 174] as RGB,
};

const DEFAULT_FILE: Icon = ["", C.white];
const DEFAULT_DIR: Icon = ["", C.folder];

// Exact file names win over extensions.
const BY_NAME: Record<string, Icon> = {
  "package.json": ["", C.red],
  "package-lock.json": ["", C.grey],
  "pnpm-lock.yaml": ["", C.grey],
  "yarn.lock": ["", C.grey],
  "bun.lockb": ["", C.grey],
  "tsconfig.json": ["", C.tsBlue],
  "jsconfig.json": ["", C.yellow],
  ".gitignore": ["", C.orange],
  ".gitattributes": ["", C.orange],
  ".gitmodules": ["", C.orange],
  ".editorconfig": ["", C.white],
  ".npmrc": ["", C.red],
  ".env": ["", C.yellow],
  "dockerfile": ["", C.blue],
  "docker-compose.yml": ["", C.blue],
  "docker-compose.yaml": ["", C.blue],
  "compose.yml": ["", C.blue],
  "compose.yaml": ["", C.blue],
  "makefile": ["", C.grey],
  "license": ["", C.yellow],
  "license.md": ["", C.yellow],
  "readme.md": ["", C.blue],
  "claude.md": ["", C.orange],
  "nuget.config": ["", C.blue],
  "global.json": ["", C.csPurple],
  "directory.build.props": ["", C.csPurple],
  "directory.packages.props": ["", C.csPurple],
};

const BY_EXT: Record<string, Icon> = {
  ts: ["", C.tsBlue],
  mts: ["", C.tsBlue],
  cts: ["", C.tsBlue],
  tsx: ["", C.cyan],
  js: ["", C.yellow],
  mjs: ["", C.yellow],
  cjs: ["", C.yellow],
  jsx: ["", C.cyan],
  json: ["", C.yellow],
  jsonc: ["", C.yellow],
  cs: ["\u{f031b}", C.csPurple],
  csx: ["\u{f031b}", C.csPurple],
  razor: ["\u{f031b}", C.purple],
  cshtml: ["\u{f031b}", C.purple],
  csproj: ["", C.csPurple],
  sln: ["", C.csPurple],
  slnx: ["", C.csPurple],
  props: ["", C.csPurple],
  targets: ["", C.csPurple],
  fs: ["", C.blue],
  md: ["", C.blue],
  mdx: ["", C.orange],
  html: ["", C.orange],
  htm: ["", C.orange],
  css: ["", C.blue],
  scss: ["", C.pink],
  sass: ["", C.pink],
  less: ["", C.blue],
  vue: ["", C.green],
  svelte: ["", C.orange],
  yml: ["", C.purple],
  yaml: ["", C.purple],
  toml: ["", C.grey],
  xml: ["\u{f05c0}", C.orange],
  sql: ["", C.pink],
  db: ["", C.grey],
  sqlite: ["", C.grey],
  sh: ["", C.green],
  bash: ["", C.green],
  zsh: ["", C.green],
  fish: ["", C.green],
  ps1: ["", C.blue],
  py: ["", C.yellow],
  rs: ["", C.orange],
  go: ["", C.cyan],
  java: ["", C.red],
  kt: ["", C.purple],
  c: ["", C.blue],
  h: ["", C.purple],
  cpp: ["", C.blue],
  hpp: ["", C.purple],
  rb: ["", C.red],
  php: ["", C.purple],
  lua: ["", C.blue],
  swift: ["", C.orange],
  dart: ["", C.blue],
  graphql: ["", C.pink],
  gql: ["", C.pink],
  proto: ["", C.grey],
  lock: ["", C.grey],
  env: ["", C.yellow],
  txt: ["", C.white],
  log: ["", C.grey],
  pdf: ["", C.red],
  png: ["", C.purple],
  jpg: ["", C.purple],
  jpeg: ["", C.purple],
  gif: ["", C.purple],
  webp: ["", C.purple],
  ico: ["", C.yellow],
  svg: ["\u{f0721}", C.orange],
  zip: ["", C.grey],
  gz: ["", C.grey],
  tar: ["", C.grey],
  wasm: ["", C.purple],
  diff: ["", C.orange],
  patch: ["", C.orange],
};

// Compound suffixes checked before the plain extension.
const BY_SUFFIX: Array<[string, Icon]> = [
  [".d.ts", ["", C.grey]],
  [".test.ts", ["", C.tsBlue]],
  [".spec.ts", ["", C.tsBlue]],
  [".test.tsx", ["", C.cyan]],
  [".spec.tsx", ["", C.cyan]],
  [".test.js", ["", C.yellow]],
  [".spec.js", ["", C.yellow]],
  [".tests.cs", ["", C.csPurple]],
];

const BY_DIR_NAME: Record<string, Icon> = {
  ".git": ["", C.orange],
  ".github": ["", C.white],
  ".vscode": ["", C.blue],
  ".claude": ["", C.orange],
  "node_modules": ["", C.green],
  "src": ["", C.blue],
  "test": ["", C.green],
  "tests": ["", C.green],
  "docs": ["", C.blue],
};

function iconForFile(name: string): Icon {
  const lower = name.toLowerCase();
  const exact = BY_NAME[lower];
  if (exact) return exact;
  if (lower.startsWith(".env")) return BY_NAME[".env"];
  if (lower.startsWith("dockerfile")) return BY_NAME["dockerfile"];
  for (const [suffix, icon] of BY_SUFFIX) {
    if (lower.endsWith(suffix)) return icon;
  }
  const dot = lower.lastIndexOf(".");
  if (dot >= 0) {
    const byExt = BY_EXT[lower.slice(dot + 1)];
    if (byExt) return byExt;
  }
  return DEFAULT_FILE;
}

function iconForDir(name: string): Icon {
  return BY_DIR_NAME[name.toLowerCase()] ?? DEFAULT_DIR;
}

function useNerdGlyphs(iconSet: string): boolean {
  if (iconSet === "nerd") return true;
  if (iconSet === "unicode") return false;
  const cfg = editor.getConfig() as { editor?: { nerd_font_icons?: boolean } } | null;
  return cfg?.editor?.nerd_font_icons === true;
}

async function listRepoFiles(root: string): Promise<string[] | null> {
  const result = await editor.spawnProcess(
    "git",
    ["ls-files", "--cached", "--others", "--exclude-standard", "-z"],
    root
  );
  if (result.exit_code !== 0) return null;
  return result.stdout.split("\0").filter((p) => p.length > 0);
}

function walkFiles(root: string): string[] {
  const out: string[] = [];
  const visit = (dir: string, rel: string, depth: number) => {
    if (depth > WALK_MAX_DEPTH || out.length >= WALK_MAX_ENTRIES) return;
    let entries: DirEntry[];
    try {
      entries = editor.readDir(dir);
    } catch {
      return;
    }
    for (const entry of entries) {
      if (out.length >= WALK_MAX_ENTRIES) return;
      const childRel = rel ? `${rel}/${entry.name}` : entry.name;
      if (entry.is_dir) {
        if (WALK_SKIP.has(entry.name)) continue;
        visit(editor.pathJoin(dir, entry.name), childRel, depth + 1);
      } else {
        out.push(childRel);
      }
    }
  };
  visit(root, "", 0);
  return out;
}

function buildSlots(root: string, files: string[], nerd: boolean, folderIcons: boolean) {
  const slots: Array<{ path: string; leading: { text: string; color: RGB; minWidth: number }; priority: number }> = [];
  const dirs = new Set<string>();
  for (const rel of files) {
    const parts = rel.split("/");
    const [glyph, color] = iconForFile(parts[parts.length - 1]);
    slots.push({
      path: editor.pathJoin(root, rel),
      leading: { text: nerd ? glyph : "●", color, minWidth: 2 },
      priority: PRIORITY,
    });
    for (let i = 1; i < parts.length; i++) {
      dirs.add(parts.slice(0, i).join("/"));
    }
  }
  if (folderIcons && nerd) {
    for (const rel of dirs) {
      const [glyph, color] = iconForDir(rel.slice(rel.lastIndexOf("/") + 1));
      slots.push({
        path: editor.pathJoin(root, rel),
        leading: { text: glyph, color, minWidth: 2 },
        priority: PRIORITY,
      });
    }
  }
  return slots;
}

let refreshInFlight = false;
let refreshPending = false;

async function refreshFileIcons(): Promise<void> {
  if (refreshInFlight) {
    refreshPending = true;
    return;
  }
  refreshInFlight = true;
  try {
    const cfg = (editor.getPluginConfig() ?? {}) as { iconSet?: string; folderIcons?: boolean };
    const root = editor.getCwd();
    const files = (await listRepoFiles(root)) ?? walkFiles(root);
    const slots = buildSlots(root, files, useNerdGlyphs(cfg.iconSet ?? "auto"), cfg.folderIcons !== false);
    if (slots.length === 0) {
      editor.clearFileExplorerSlots(NAMESPACE);
    } else {
      editor.setFileExplorerSlots(NAMESPACE, slots);
    }
  } catch (err) {
    editor.debug(`file-icons: refresh failed: ${err}`);
  } finally {
    refreshInFlight = false;
    if (refreshPending) {
      refreshPending = false;
      void refreshFileIcons();
    }
  }
}

registerHandler("file_icons_refresh", () => {
  void refreshFileIcons();
});

for (const event of [
  "editor_initialized",
  "after_file_save",
  "after_file_explorer_change",
  "focus_gained",
  "config_changed",
]) {
  editor.on(event, "file_icons_refresh");
}

editor.registerCommand("File Icons: Refresh", "Rebuild file explorer icons", "file_icons_refresh", null);

void refreshFileIcons();
