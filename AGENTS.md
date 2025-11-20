# Agent Guidelines for Xidots Repository

This document outlines conventions for agentic coding in this dotfiles repository.

## 1. Build/Lint/Test Commands

- **Build/Setup:** The primary setup is running `/home/xitonight/.xidots/install.sh`.
- **Linting:**
    - **Lua:** `stylua --check <file>` (check only) or `stylua <file>` (format).
    - **Python:** Use `ruff check <file>` for linting and `black <file>` for formatting.
    - **Shell Scripts:** Use `shellcheck <file>`.
- **Testing:** No automated tests. Manual verification after setup is required.

## 2. Code Style Guidelines

- **General:** Unix line endings, consistent indentation.
- **Shell Scripts (`.sh`, `.zshrc`):**
    - `#!/usr/bin/env bash/zsh`
    - `set -euvx` (for robustness)
    - `SCREAMING_SNAKE_CASE` for global variables.
    - Use functions for modularity.
- **Lua (`.lua`):**
    - **Formatting (enforced by `stylua`):**
        - `column_width = 120`
        - `indent_type = "Spaces"`, `indent_width = 2`
        - `quote_style = "AutoPreferDouble"`
        - `call_parentheses = "None"`
    - `snake_case` for variables/functions.
- **Python (`.py`):**
    - `SCREAMING_SNAKE_CASE` for constants.
    - `snake_case` for functions/variables.
    - Imports: Standard library, then third-party, then local.
    - Error Handling: `try...except` for expected errors, `sys.exit()` for critical failures.
    - Docstrings for functions.
    - Formatting: Follow PEP 8 (typically 4 spaces indentation).
- **Configuration Files:** Adhere to the specific tool's syntax and conventions.
