const path = require('path');
const { execSync } = require("child_process");
const glob  = require('glob').sync

if (!process.env.THEME) {
  throw "tailwind.config.js: missing process.env.THEME"
  process.exit(1)
}
  
const themeConfigFile = execSync(`bundle exec bin/theme tailwind-config ${process.env.THEME}`).toString().trim()
let themeConfig = require(themeConfigFile)

// *** Uncomment these if required for your overrides ***

// const defaultTheme = require('tailwindcss/defaultTheme')
// const colors = require('tailwindcss/colors')

// *** Add your own overrides here ***

// Material Design 3 color tokens for RecordDetailComponent
// Use Object.assign to MERGE into existing colors rather than replacing them
if (!themeConfig.theme.extend) themeConfig.theme.extend = {}
if (!themeConfig.theme.extend.colors) themeConfig.theme.extend.colors = {}
Object.assign(themeConfig.theme.extend.colors, {
  "md-on-secondary-container": "#3a4c83",
  "md-on-surface-variant": "#434654",
  "md-surface-container-highest": "#e0e3e5",
  "md-surface-bright": "#f7f9fb",
  "md-outline": "#737686",
  "md-surface-variant": "#e0e3e5",
  "md-background": "#f7f9fb",
  "md-on-primary-container": "#cdd7ff",
  "md-primary-fixed": "#dbe1ff",
  "md-outline-variant": "#c3c6d7",
  "md-surface-container-low": "#f2f4f6",
  "md-surface-container-high": "#e6e8ea",
  "md-on-background": "#191c1e",
  "md-surface-tint": "#0053da",
  "md-surface": "#f7f9fb",
  "md-surface-container": "#eceef0",
  "md-surface-container-lowest": "#ffffff",
  "md-inverse-on-surface": "#eff1f3",
  "md-on-surface": "#191c1e",
  "md-surface-dim": "#d8dadc",
  "md-inverse-surface": "#2d3133",
})

if (!themeConfig.theme.extend.fontFamily) themeConfig.theme.extend.fontFamily = {}
Object.assign(themeConfig.theme.extend.fontFamily, {
  "headline": ["Manrope", "sans-serif"],
  "body-text": ["Inter", "sans-serif"],
  "label": ["Inter", "sans-serif"],
})

// Unprefixed MD3 token aliases (Stitch design system naming)
// Object.assign merges — does NOT replace BT's existing color objects
Object.assign(themeConfig.theme.extend.colors, {
  "on-secondary-container": "#3a4c83",
  "on-surface-variant":     "#434654",
  "surface-container-highest": "#e0e3e5",
  "surface-bright":         "#f7f9fb",
  "outline":                "#737686",
  "surface-variant":        "#e0e3e5",
  "on-primary-container":   "#cdd7ff",
  "primary-fixed":          "#dbe1ff",
  "outline-variant":        "#c3c6d7",
  "surface-container-low":  "#f2f4f6",
  "surface-container-high": "#e6e8ea",
  "on-background":          "#191c1e",
  "surface-tint":           "#0053da",
  "surface":                "#f7f9fb",
  "surface-container":      "#eceef0",
  "surface-container-lowest": "#ffffff",
  "inverse-on-surface":     "#eff1f3",
  "on-surface":             "#191c1e",
  "surface-dim":            "#d8dadc",
  "inverse-surface":        "#2d3133",
  // primary.DEFAULT enables `text-primary` while keeping `text-primary-600` from BT
  "primary": { "DEFAULT": "#003ea7" },
})

// Ensure app/components is scanned for Tailwind classes
themeConfig.content.push('./app/components/**/*.html.erb')

module.exports = themeConfig