/**
 * Syncs CHANGELOG.md (release-please format) into the Changes section of index.bs.liquid.
 *
 * - Flattens category subsections (Features, Bug Fixes, etc.) into a single list per version.
 * - Strips commit/PR reference links from bullet items.
 * - Outputs Bikeshed-compatible markup between <!-- CHANGELOG-START --> and <!-- CHANGELOG-END --> markers.
 */

import { readFileSync, writeFileSync } from 'node:fs';

const changelogPath = 'CHANGELOG.md';
const specPath = 'index.bs.liquid';

const START_MARKER = '<!-- CHANGELOG-START -->';
const END_MARKER = '<!-- CHANGELOG-END -->';

const changelog = readFileSync(changelogPath, 'utf-8');
const spec = readFileSync(specPath, 'utf-8');

// Parse version sections from CHANGELOG.md.
// Format: ## [1.1.0](https://github.com/…/compare/v1.0.0...v1.1.0) (2026-02-20)
// or:     ## 1.1.0 (2026-02-20)
const versionPattern = /^## \[?(\d+\.\d+\.\d+)\]?(?:\([^)]*\))? \((\d{4}-\d{2}-\d{2})\)/;

const versions = [];
let currentVersion = null;

for (const line of changelog.split('\n')) {
  const versionMatch = line.match(versionPattern);
  if (versionMatch) {
    currentVersion = { version: versionMatch[1], date: versionMatch[2], items: [] };
    versions.push(currentVersion);
    continue;
  }

  // Skip category headings (### Features, ### Bug Fixes, etc.)
  if (line.startsWith('### ')) continue;

  // Collect bullet items.
  if (currentVersion && line.startsWith('* ')) {
    let item = line.slice(2);

    // Strip all trailing commit/PR links like ([abc1234](https://…)) or ([#42](https://…)).
    item = item.replace(/(\s*\(\[[\w#]+\]\([^)]*\)\))+$/g, '');

    // Strip inline links but keep link text: [text](url) → text.
    item = item.replace(/\[([^\]]+)\]\([^)]*\)/g, '$1');

    // Strip residual parenthesized issue/PR references like (#73).
    item = item.replace(/\s*\(#\d+\)/g, '');

    // Strip leading **scope:** bold prefix that release-please adds.
    item = item.replace(/^\*\*[^*]+:\*\*\s*/, '');

    // Capitalise the first letter.
    item = item.charAt(0).toUpperCase() + item.slice(1);

    // Ensure trailing period.
    if (!/[.!?]$/.test(item)) item += '.';

    currentVersion.items.push(item);
  }
}

// Format a date as "20 February 2026".
function formatDate(isoDate) {
  const [year, month, day] = isoDate.split('-');
  const months = [
    'January', 'February', 'March', 'April', 'May', 'June',
    'July', 'August', 'September', 'October', 'November', 'December',
  ];
  return `${parseInt(day)} ${months[parseInt(month) - 1]} ${year}`;
}

// Build Bikeshed markup.
const sections = versions.map(({ version, date, items }) => {
  const lines = [];
  lines.push(`Version ${version} (${formatDate(date)}) {#v${version}}`);
  lines.push('----------');
  lines.push('');
  for (const item of items) {
    lines.push(`- ${item}`);
  }
  return lines.join('\n');
});

const changelogMarkup = sections.join('\n\n');

// Insert between markers.
const startIdx = spec.indexOf(START_MARKER);
const endIdx = spec.indexOf(END_MARKER);

if (startIdx === -1 || endIdx === -1) {
  console.error('Could not find CHANGELOG markers in', specPath);
  process.exit(1);
}

const before = spec.slice(0, startIdx + START_MARKER.length);
const after = spec.slice(endIdx);

const updated = before + '\n' + changelogMarkup + '\n' + after;

writeFileSync(specPath, updated);
console.log(`Synced ${versions.length} version(s) to ${specPath}.`);
