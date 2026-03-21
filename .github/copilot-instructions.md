# Copilot Workspace Instructions for Bullet Train Rails Project

## Overview

This workspace is a Bullet Train-based Rails application. It uses custom scripts and conventions for setup, development, and deployment. These instructions help AI agents and developers work productively and avoid common pitfalls.

## Build and Test Commands

- **Setup:**
  - `bin/configure` — Project configuration (rename remotes, update configs, etc.)
  - `bin/setup` — Installs dependencies, checks system requirements, prepares the app
- **Development:**
  - `bin/dev` — Starts the app (web, worker, JS, CSS, mailer CSS)
    - Uses Overmind or Foreman with `Procfile.dev`
- **Testing:**
  - `bin/rails test` — Runs all tests
  - `bin/rails test:system` — Runs system/browser tests

## Architecture and Conventions

- **Monorepo:** Standard Rails app structure with custom `bin/` scripts
- **Assets:** Managed via Yarn, esbuild, and Tailwind (see `app/assets`, `app/javascript`)
- **Background Jobs:** Sidekiq (see `Procfile.dev`)
- **Docker:** `docker-compose.yml` for local dev (Postgres, Redis, web)
- **Environment:**
  - Ruby version in `.ruby-version`
  - Node version in `.nvmrc`
  - Uses Homebrew for macOS dependencies

## Project-Specific Patterns

- **bin/configure** and **bin/setup** must be run before development
- **bin/dev** is the canonical way to start all services
- **README.md** is replaced by `README.example.md` after configuration
- **ngrok**: Optional, for public URLs (see `Procfile.dev` and `bin/set-ngrok-url`)

## Common Pitfalls

- Not running `bin/configure` and `bin/setup` before `bin/dev`
- Missing Homebrew, rbenv, nvm, or Yarn on macOS
- Not sourcing `~/.zshrc` after installing nvm/rbenv
- Not starting Postgres/Redis services (see Homebrew notes)
- Not updating `BASE_URL` after restarting ngrok

## Key Files and Directories

- `bin/` — Custom scripts for setup, dev, and utilities
- `Procfile.dev` — Process definitions for Overmind/Foreman
- `docker-compose.yml` — Local dev containers
- `app/` — Rails app code (MVC, assets, jobs, mailers)
- `config/` — Rails and environment configs

## Example Prompts

- "How do I start the app for development?"
- "How do I run tests?"
- "What should I do if Postgres or Redis isn't running?"
- "How do I update the app name after cloning?"

---

For more, see [Bullet Train Docs](https://bullettrain.co/docs).
