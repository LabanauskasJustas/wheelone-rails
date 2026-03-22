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

## Bullet Train Reference

- **Docs:** https://bullettrain.co/docs
- **i18n / Translations:** https://bullettrain.co/docs/i18n

Key Bullet Train conventions to follow:

- Use `bundle exec rails generate super_scaffold` (not `bin/super-scaffold`) for resource generation
- BT scaffold field types use partial names (`text_field`, `file_field`) — not Rails column types (`string`)
- BT theme navigation is configured in `config/initializers/theme.rb` (`:left` or `:top`)
- Locale priority per request: `current_user.locale → team.locale → browser Accept-Language → default_locale`
- `config.i18n.raise_on_missing_translations = true` is enforced — all locales must be complete
- BT fallback chain: set `config.i18n.fallbacks = [:en]` so `lt` falls through to `en` for untranslated BT gem keys
- Use `echo 'n' |` prefix when running super_scaffold to skip the interactive navbar prompt

## Slash Commands

- Always use the `/rails` skill when performing Rails-related tasks (generating code, running migrations, scaffolding, etc.)

---

For more, see [Bullet Train Docs](https://bullettrain.co/docs).

Paste this at the **top of every message** you send to Claude Code for this project:

---

> **RULES — read before doing anything:**
>
> **CSS classes — only use tokens from the Tailwind config. Never invent class names.**
> The only valid color tokens are: `surface`, `surface-dim`, `surface-bright`, `surface-container-lowest`, `surface-container-low`, `surface-container`, `surface-container-high`, `surface-container-highest`, `on-surface`, `on-surface-variant`, `outline`, `outline-variant`, `primary`, `on-primary`, `primary-container`, `on-primary-container`, `secondary`, `on-secondary`, `tertiary`, `on-tertiary`, `background`, `on-background`, `error`, `on-error`
>
> Never use: `base-*`, `md-*`, `primary-700`, `primary-600`, `primary-300`, or any numbered shade variants. Never add `dark:` variants — dark mode is not used.
>
> **Custom CSS — two classes only, always in the stylesheet:**
>
> ```css
> .glass-card {
>   background: rgba(255, 255, 255, 0.7);
>   backdrop-filter: blur(24px);
>   -webkit-backdrop-filter: blur(24px);
> }
> .primary-gradient {
>   background: linear-gradient(135deg, #0053da 0%, #346df5 100%);
> }
> ```
>
> **Fonts — three utility classes only:** `font-headline` (Manrope), `font-body` (Inter), `font-label` (Inter). Never use `font-manrope`, `font-inter`, or `font-[Manrope]`.
>
> **Icons — Material Symbols only:** `<span class="material-symbols-outlined">icon_name</span>`. Never use SVG icons or Heroicons.
>
> **Before writing any code:** read the existing file first. Never guess field names — check the model. Never guess route helpers — run `rails routes`.
>
> **Never rewrite working logic** when asked to fix styling. Surgical edits only.
