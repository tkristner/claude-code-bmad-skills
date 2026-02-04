# Documentation Style Guide

Guidelines for writing clear, consistent technical documentation.

---

## Voice and Tone

### Use Active Voice

**Good:** "Click the Submit button to save your changes."
**Bad:** "The Submit button should be clicked to save changes."

### Be Direct

**Good:** "Install the package using npm."
**Bad:** "You might want to consider installing the package using npm."

### Address the Reader

**Good:** "You can configure settings in config.yaml."
**Bad:** "Users can configure settings in config.yaml."

### Be Professional but Approachable

**Good:** "This feature helps you manage dependencies efficiently."
**Bad:** "This awesome feature is super helpful for managing deps!"

---

## Document Structure

### Heading Hierarchy

```markdown
# Page Title (H1) - One per page

## Major Section (H2)

### Subsection (H3)

#### Detail Section (H4)
```

Never skip levels (don't go from H2 to H4).

### Paragraph Length

- Keep paragraphs to 3-5 sentences
- One idea per paragraph
- Use blank lines between paragraphs

### Lists

**Use numbered lists for:**
- Sequential steps
- Ordered items
- Procedures

**Use bullet lists for:**
- Unordered items
- Features
- Options

---

## Technical Writing

### Define Acronyms

First use: "Application Programming Interface (API)"
Subsequent uses: "API"

### Consistent Terminology

Create a glossary for the project. Use the same term throughout.

| Avoid | Use |
|-------|-----|
| Click/press/tap | Click (for desktop) |
| Directory/folder | Directory (for CLI) |
| Config/configuration | Configuration |

### Code Examples

Always test code examples before including them.

```javascript
// Good: Complete, working example
const result = await api.getData({ limit: 10 });
console.log(result);

// Bad: Incomplete, unclear
api.getData(options)
```

### Context Before Details

**Good:**
```markdown
## Installation

Before installing, ensure you have Node.js 16+ installed.

```bash
npm install package-name
```
```

**Bad:**
```markdown
## Installation

```bash
npm install package-name
```

Note: Requires Node.js 16+.
```

---

## Formatting Conventions

### File Names and Paths

Use `backticks` for file names: `config.yaml`

Use backticks for paths: `/etc/app/config.yaml`

### Commands

Use code blocks for commands:

```bash
npm install express
```

### UI Elements

Use **bold** for UI elements: Click **Settings** > **Advanced**.

### Keyboard Shortcuts

Use `backticks` with plus signs: `Ctrl+S`

### Variables and Parameters

Use `backticks` for variables: Set the `PORT` environment variable.

---

## Code Blocks

### Always Specify Language

```javascript
// JavaScript
const x = 1;
```

```bash
# Bash
npm install
```

### Include Comments

```javascript
// Initialize the client with your API key
const client = new Client({ apiKey: process.env.API_KEY });

// Fetch data from the API
const data = await client.getData();
```

### Show Output When Helpful

```bash
$ npm test
> Running tests...
> All tests passed (24/24)
```

---

## Accessibility

### Alt Text for Images

```markdown
![Diagram showing data flow from client to server](images/data-flow.png)
```

### Descriptive Links

**Good:** "See the [installation guide](docs/install.md) for details."
**Bad:** "Click [here](docs/install.md) for details."

### Don't Rely on Color Alone

Use icons or text in addition to color for status:

- ✓ Success (green)
- ✗ Error (red)
- ⚠ Warning (yellow)

---

## Common Mistakes

| Mistake | Correction |
|---------|------------|
| "In order to" | "To" |
| "Make sure to" | "Ensure" or remove |
| "Basically" | Remove |
| "Very/really" | Remove or be specific |
| "Please" | Remove (be direct) |
| "Simply" | Remove (nothing is simple to everyone) |
