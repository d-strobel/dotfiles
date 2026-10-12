/**
 * Custom Header Extension
 *
 * Responsive startup header, boxed in the same color as the pi symbol:
 *
 *   ╭────────────────────────────────────────────────────────────╮
 *   │                                                            │
 *   │  ██████████████████╗  pi v1.1.0   ~/project                │
 *   │  ╚═████╔═════████╔═╝                                       │
 *   │    ████║     ████║    Providers   GitHub Copilot (login)   │
 *   │    ████║     ████║    Skills      btw, council-mode, …     │
 *   │    ████║     ████║    Prompts     /council, /review-loop,  │
 *   │  ████████╗ ████████╗              /parallel-review         │
 *   │  ╚═══════╝ ╚═══════╝  Extensions  btw, fff, guardrails     │
 *   ╰────────────────────────────────────────────────────────────╯
 *
 * - The box always spans the full terminal width.
 * - Lists wrap onto as many rows as needed; the box grows downwards.
 * - Layouts (picked from the available width on every render):
 *     wide:   large logo + info column
 *     medium: small logo + info column
 *     narrow: info column only (still boxed)
 *     tiny:   plain lines, no box
 *
 * Tip: `"quietStartup": "header"` in settings.json hides the built-in
 * loaded-resource listing, since this header already shows it.
 *
 * Usage: edit this file and run /reload in pi.
 * To restore the built-in header: /builtin-header
 */

import * as os from "node:os";
import * as path from "node:path";
import type { ExtensionAPI, Theme } from "@earendil-works/pi-coding-agent";
import { VERSION } from "@earendil-works/pi-coding-agent";
import { truncateToWidth, visibleWidth } from "@earendil-works/pi-tui";

// ── Logos ─────────────────────────────────────────────────────────────────────

const LOGO_LARGE = [
	"██████████████████╗",
	"╚═████╔═════████╔═╝",
	"  ████║     ████║  ",
	"  ████║     ████║  ",
	"  ████║     ████║  ",
	"████████╗ ████████╗",
	"╚═══════╝ ╚═══════╝",
];

const LOGO_SMALL = [
	"▄▄▄▄▄▄▄▄▄",
	" ██   ██ ",
	" ██   ██ ",
	"▀▀▀▀ ▀▀▀▀",
];

// ── Layout constants ──────────────────────────────────────────────────────────

const PAD_X = 2; // space between border and content
const GAP = 2; // space between logo and info column
const LABEL_W = 12; // width of the "Extensions  " label column
const MIN_INFO_W = 34; // minimum info column width before dropping/shrinking the logo
const MIN_BOX_W = 24; // below this, render without a box

// ── Data ──────────────────────────────────────────────────────────────────────

type Item = { name: string; note?: string; dim?: boolean };

type Info = {
	skills: Item[];
	prompts: Item[];
	extensions: Item[];
};

function collectInfo(pi: ExtensionAPI): Info {
	const commands = pi.getCommands();
	const tools = pi.getAllTools();

	const sorted = (xs: Iterable<string>): Item[] =>
		[...new Set(xs)].sort((a, b) => a.localeCompare(b)).map((name) => ({ name }));

	const skills = commands.filter((c) => c.source === "skill").map((c) => c.name.replace(/^skill:/, ""));
	const prompts = commands.filter((c) => c.source === "prompt").map((c) => `/${c.name}`);

	// Extensions: derive from where extension commands & tools were registered.
	const extensions = new Set<string>();
	const addSource = (info: { path: string; source: string; origin: string } | undefined) => {
		if (!info || info.path.startsWith("builtin:") || info.path.startsWith("<")) return;
		if (info.origin === "package") {
			extensions.add(info.source.replace(/^(npm|git|jsr):/, "").replace(/^@[^/]+\//, "").replace(/^pi-/, ""));
		} else {
			extensions.add(path.basename(info.path).replace(/\.(ts|js|mjs|cjs)$/, ""));
		}
	};
	for (const c of commands) if (c.source === "extension") addSource(c.sourceInfo);
	for (const t of tools) addSource(t.sourceInfo);

	return {
		skills: sorted(skills),
		prompts: sorted(prompts),
		extensions: sorted(extensions),
	};
}

function shortCwd(): string {
	const cwd = process.cwd();
	const home = os.homedir();
	return cwd === home ? "~" : cwd.startsWith(home + path.sep) ? `~${cwd.slice(home.length)}` : cwd;
}

// ── Rendering ─────────────────────────────────────────────────────────────────

/** Pad/truncate a (possibly styled) string to exactly `width` visible cells. */
function fit(text: string, width: number): string {
	if (width <= 0) return "";
	return truncateToWidth(text, width, "…", true);
}

/** Wrap a comma separated list into rows of at most `width` cells. */
function wrapItems(theme: Theme, items: Item[], width: number): string[] {
	if (items.length === 0) return [theme.fg("dim", "none")];
	const rows: string[] = [];
	let row = "";
	let rowW = 0;
	items.forEach((item, i) => {
		const comma = i < items.length - 1 ? "," : "";
		const note = item.note ? ` (${item.note})` : "";
		const text = item.name + note + comma;
		const w = visibleWidth(text);
		const sep = rowW > 0 ? 1 : 0;
		if (rowW > 0 && rowW + sep + w > width) {
			rows.push(row);
			row = "";
			rowW = 0;
		}
		const styled =
			w > width
				? theme.fg(item.dim ? "dim" : "muted", truncateToWidth(text, width, "…"))
				: theme.fg(item.dim ? "dim" : "muted", item.name) + theme.fg("dim", note) + theme.fg("muted", comma);
		row += (rowW > 0 ? " " : "") + styled;
		rowW += (rowW > 0 ? 1 : 0) + Math.min(w, width);
	});
	if (rowW > 0) rows.push(row);
	return rows;
}

function infoLines(theme: Theme, info: Info, width: number, providers: Item[]): string[] {
	const title = titleLine(theme);

	// Very narrow: stack label above values instead of side by side.
	const stacked = width < LABEL_W + 16;
	const valueW = stacked ? width : width - LABEL_W;

	const section = (label: string, items: Item[]): string[] => {
		const rows = wrapItems(theme, items, valueW);
		const head = theme.fg("accent", label);
		if (stacked) return [head, ...rows];
		const indent = " ".repeat(LABEL_W);
		return rows.map((r, i) => (i === 0 ? theme.fg("accent", label.padEnd(LABEL_W)) : indent) + r);
	};

	return [
		title,
		"",
		...section("Providers", providers),
		...section("Skills", info.skills),
		...section("Prompts", info.prompts),
		...section("Extensions", info.extensions),
	];
}

/** Title row: "pi vX.Y.Z" padded to the label column, followed by the cwd. */
function titleLine(theme: Theme): string {
	const name = `pi v${VERSION}`;
	const namePad = " ".repeat(Math.max(1, LABEL_W - name.length));
	return theme.bold(theme.fg("accent", "pi")) + theme.fg("dim", ` v${VERSION}`) + namePad + theme.fg("muted", shortCwd());
}

/**
 * Big box: logo on the left, `buildRows(infoWidth)` on the right.
 * The box spans the full width and grows downwards as needed.
 */
function renderBox(theme: Theme, width: number, buildRows: (infoW: number) => string[]): string[] {
	const color = (s: string) => theme.bold(theme.fg("success", s));

	// Tiny terminal: no box, just the essentials.
	if (width < MIN_BOX_W) {
		return buildRows(width).map((l) => fit(l, width));
	}

	const inner = width - 2 - PAD_X * 2; // content width inside the border

	// Pick the largest logo that still leaves room for the info column.
	let logo: string[] = [];
	for (const candidate of [LOGO_LARGE, LOGO_SMALL]) {
		if (inner - visibleWidth(candidate[0]) - GAP >= MIN_INFO_W) {
			logo = candidate;
			break;
		}
	}

	const logoW = logo.length > 0 ? visibleWidth(logo[0]) : 0;
	const offset = logoW > 0 ? logoW + GAP : 0;
	const infoW = inner - offset;
	const rows = buildRows(infoW);
	const height = Math.max(logo.length, rows.length);

	const pad = " ".repeat(PAD_X);
	const line = (content: string) => color("│") + pad + fit(content, inner) + pad + color("│");

	const lines: string[] = [];
	lines.push(color(`╭${"─".repeat(width - 2)}╮`));
	lines.push(line(""));
	for (let i = 0; i < height; i++) {
		let content = "";
		if (logoW > 0) {
			const logoLine = logo[i];
			content += (logoLine !== undefined ? color(logoLine) : " ".repeat(logoW)) + " ".repeat(GAP);
		}
		content += fit(rows[i] ?? "", infoW);
		lines.push(line(content));
	}
	lines.push(color(`╰${"─".repeat(width - 2)}╯`));
	return lines;
}

// ── Extension ─────────────────────────────────────────────────────────────────

/** Providers with credentials: OAuth logins, stored API keys and env vars. */
function collectProviders(registry: any): Item[] {
	const ids = new Set<string>([
		...(registry.getRegisteredProviderIds?.() ?? []),
		...registry.getAll().map((m: any) => m.provider),
	]);
	const items: Item[] = [];
	for (const id of ids) {
		const status = registry.getProviderAuthStatus(id);
		if (!status?.configured) continue;
		const model = registry.getAll().find((m: any) => m.provider === id);
		const note =
			model && registry.isUsingOAuth(model)
				? "login"
				: status.source === "environment"
					? (status.label ?? "env")
					: "API key";
		items.push({ name: registry.getProviderDisplayName?.(id) ?? id, note });
	}
	return items.sort((a, b) => a.name.localeCompare(b.name));
}

export default function (pi: ExtensionAPI) {
	let providers: Item[] = [];
	let requestRender: (() => void) | undefined;

	pi.on("session_start", async (_event, ctx) => {
		if (ctx.mode !== "tui") return;
		providers = collectProviders(ctx.modelRegistry);

		ctx.ui.setHeader((tui, theme) => {
			requestRender = () => tui.requestRender();
			return {
				render(width: number): string[] {
					return renderBox(theme, width, (w) => infoLines(theme, collectInfo(pi), w, providers));
				},
				invalidate() {},
			};
		});
	});

	// Re-check credentials on model switch (e.g. after a fresh /login).
	pi.on("model_select", async (_event, ctx) => {
		providers = collectProviders(ctx.modelRegistry);
		requestRender?.();
	});

	// Command to restore the built-in header
	pi.registerCommand("builtin-header", {
		description: "Restore the built-in startup header",
		handler: async (_args, ctx) => {
			ctx.ui.setHeader(undefined);
			ctx.ui.notify("Built-in header restored", "info");
		},
	});
}
