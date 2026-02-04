# Tech Writer - Extended Reference

This document provides detailed guidance for technical documentation creation.

## Documentation Standards

### README Structure

A comprehensive README should include:

```markdown
# Project Name

> One-line description

[![Build Status](badge)]  [![License](badge)]

## Overview

Brief description (2-3 paragraphs max).

## Features

- Feature 1
- Feature 2

## Quick Start

Minimal steps to get running.

## Installation

Detailed installation instructions.

## Usage

Basic usage examples.

## Configuration

Configuration options and environment variables.

## API Reference

Link to API docs or brief overview.

## Contributing

How to contribute.

## License

License information.
```

### API Documentation Standards

**Endpoint Documentation Format:**

```markdown
## Endpoint Name

`METHOD /path/to/endpoint`

Description of what this endpoint does.

### Request

**Headers:**
| Header | Required | Description |
|--------|----------|-------------|
| Authorization | Yes | Bearer token |

**Body:**
```json
{
  "field": "type"
}
```

### Response

**Success (200):**
```json
{
  "data": {}
}
```

**Error (4xx/5xx):**
```json
{
  "error": "message"
}
```
```

### Changelog Format (Keep a Changelog)

```markdown
# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added
- New features

### Changed
- Changes in existing functionality

### Deprecated
- Soon-to-be removed features

### Removed
- Removed features

### Fixed
- Bug fixes

### Security
- Vulnerability fixes

## [1.0.0] - YYYY-MM-DD

### Added
- Initial release features
```

## Writing Guidelines

### Voice and Tone

| Context | Tone | Example |
|---------|------|---------|
| Instructions | Direct | "Click the button" not "You should click the button" |
| Explanations | Informative | "This function returns..." not "This function will return..." |
| Warnings | Clear | "Warning: This deletes all data" |
| Notes | Helpful | "Note: You can also use..." |

### Technical Terminology

**DO:**
- Define acronyms on first use: "Application Programming Interface (API)"
- Use consistent terms throughout
- Prefer common terms over jargon

**DON'T:**
- Assume readers know all acronyms
- Mix terminology (pick one: "function" or "method")
- Use internal codenames in public docs

### Code Examples

**Guidelines:**
1. Examples must be tested and working
2. Include necessary imports/setup
3. Show both basic and advanced usage
4. Include expected output where helpful

**Example Template:**
```markdown
### Example: Creating a User

```python
# Import the client
from mylib import Client

# Initialize with API key
client = Client(api_key="your-key")

# Create a new user
user = client.users.create(
    name="John Doe",
    email="john@example.com"
)

print(user.id)  # Output: usr_123abc
```
```

## Documentation Types Reference

### 1. Conceptual Documentation

Explains "what" and "why":
- System overview
- Architecture decisions
- Design principles

### 2. Procedural Documentation

Explains "how":
- Step-by-step guides
- Tutorials
- How-to articles

### 3. Reference Documentation

Quick lookup:
- API reference
- Configuration options
- CLI commands

### 4. Troubleshooting Documentation

Problem-solving:
- Common errors
- FAQ
- Known issues

## Quality Metrics

### Readability Scores

Target Flesch-Kincaid grade level:
- API docs: 8-10 (technical audience)
- User guides: 6-8 (general audience)
- Quick starts: 5-7 (newcomers)

### Coverage Metrics

- All public APIs documented: 100%
- All config options documented: 100%
- Examples for common use cases: 80%+
- Troubleshooting for known issues: 100%

## Documentation Review Checklist

### Technical Accuracy
- [ ] Code examples run successfully
- [ ] API responses match actual behavior
- [ ] Version numbers are current
- [ ] Links are valid

### Completeness
- [ ] All required sections present
- [ ] No TODO or placeholder text
- [ ] All parameters documented
- [ ] Error cases covered

### Clarity
- [ ] No undefined jargon
- [ ] Steps are numbered
- [ ] Complex concepts have examples
- [ ] Prerequisites stated upfront

### Formatting
- [ ] Consistent heading hierarchy
- [ ] Proper code block languages
- [ ] Tables are readable
- [ ] Images have alt text

## Templates Quick Reference

| Template | Use Case | Location |
|----------|----------|----------|
| README | Project introduction | templates/readme.template.md |
| API Reference | Endpoint docs | templates/api-reference.template.md |
| Changelog | Version history | templates/changelog.template.md |

## Integration Notes

### With System Architect
- Receive: Architecture diagrams, ADRs
- Produce: Architecture documentation, decision records

### With Developer
- Receive: API implementations, code comments
- Produce: API docs, inline documentation standards

### With Product Manager
- Receive: PRD, feature specifications
- Produce: User-facing documentation, release notes

## Style Guide Summary

From [resources/style-guide.md](resources/style-guide.md):

1. **Use active voice** - "The system processes requests" not "Requests are processed"
2. **Be concise** - Remove unnecessary words
3. **Use present tense** - "Returns" not "Will return"
4. **Address reader as "you"** - "You can configure..." not "Users can configure..."
5. **Use numbered lists for sequences** - Steps should be ordered
6. **Use bullet lists for non-sequential items**
7. **Include practical examples** - Show, don't just tell
8. **Define terms before using them**

---

_For detailed workflow instructions, see the workflow files in `workflows/`._
