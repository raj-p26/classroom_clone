const plugin = require("tailwindcss/plugin")
const fs = require("fs")
const path = require("path")

module.exports = {
  darkMode: "selector",
  content: [
    "./js/**/*.js",
    "../lib/classroom_clone_web.ex",
    "../lib/classroom_clone_web/**/*.*ex"
  ],
  theme: {
    extend: {
      colors: {
          // Light mode colorscheme
          "primary": "#006874",
          "on-primary": "#ffffff",
          "primary-container": "#9eeffd",
          "on-primary-container": "#004f58",

          "secondary": "#4a6267",
          "on-secondary": "#ffffff",
          "secondary-container": "#cde7ec",
          "on-secondary-container": "#334b4f",

          "tertiary": "#525e7d",
          "on-tertiary": "#ffffff",
          "tertiary-container": "#dae2ff",
          "on-tertiary-container": "#3b4664",

          "error": "#ba1a1a",
          "on-error": "#ffffff",
          "error-container": "#ffdad6",
          "on-error-container": "#93000a",

          "inverse-surface": "#2b3133",
          "inverse-on-surface": "#ecf2f3",
          "inverse-primary": "#82d3e1",

          "surface-dim": "#d5dbdc",
          "surface": "#f5fafb",
          "on-surface": "#171d1e",
          "on-surface-variant": "#3f484a",
          "surface-container-lowest": "#ffffff",
          "surface-container-low": "#eff5f6",
          "surface-container": "#e9eff0",
          "surface-container-high": "#e3e9ea",
          "surface-container-highest": "#dee3e5",

          "outline": "#6f797a",
          "outline-variant": "#bfc8ca",

          // Dark mode colorscheme
          "primary-dark": "#82d3e0",
          "on-primary-dark": "#00363d",
          "primary-container-dark": "#004f58",
          "on-primary-container-dark": "#9eeffd",

          "secondary-dark": "#b1cbd0",
          "on-secondary-dark": "#1c3438",
          "secondary-container-dark": "#334b4f",
          "on-secondary-container-dark": "#cde7ec",

          "tertiary-dark": "#bac6ea",
          "on-tertiary-dark": "#24304d",
          "tertiary-container-dark": "#3b4664",
          "on-tertiary-container-dark": "#dae2ff",

          "error-dark": "#ffb4ab",
          "on-error-dark": "#690005",
          "error-container-dark": "#93000a",
          "on-error-container-dark": "#ffdad6",

          "surface-dark": "#0e1415",
          "on-surface-dark": "#dee3e5",
          "on-surface-variant-dark": "#bfc8ca",
          "surface-dark-bright": "#343a3b",
          "surface-container-lowest-dark": "#090f10",
          "surface-container-low-dark": "#171d1e",
          "surface-container-dark": "#1b2122",
          "surface-container-high-dark": "#252b2c",
          "surface-container-highest-dark": "#303637",

          "outline-dark": "#899294",
          "outline-variant-dark": "#3f484a",

          "inverse-surface-dark": "#dee3e5",
          "inverse-on-surface-dark": "#2b3133",
          "inverse-primary-dark": "#006874",

          "scrim": "#000000"
      }
    },
  },
  plugins: [
    require("@tailwindcss/forms"),
    // Allows prefixing tailwind classes with LiveView classes to add rules
    // only when LiveView classes are applied, for example:
    //
    //     <div class="phx-click-loading:animate-ping">
    //
    plugin(({addVariant}) => addVariant("phx-click-loading", [".phx-click-loading&", ".phx-click-loading &"])),
    plugin(({addVariant}) => addVariant("phx-submit-loading", [".phx-submit-loading&", ".phx-submit-loading &"])),
    plugin(({addVariant}) => addVariant("phx-change-loading", [".phx-change-loading&", ".phx-change-loading &"])),

    // Embeds Heroicons (https://heroicons.com) into your app.css bundle
    // See your `CoreComponents.icon/1` for more information.
    //
    plugin(function({matchComponents, theme}) {
      let iconsDir = path.join(__dirname, "../deps/heroicons/optimized")
      let values = {}
      let icons = [
        ["", "/24/outline"],
        ["-solid", "/24/solid"],
        ["-mini", "/20/solid"],
        ["-micro", "/16/solid"]
      ]
      icons.forEach(([suffix, dir]) => {
        fs.readdirSync(path.join(iconsDir, dir)).forEach(file => {
          let name = path.basename(file, ".svg") + suffix
          values[name] = {name, fullPath: path.join(iconsDir, dir, file)}
        })
      })
      matchComponents({
        "hero": ({name, fullPath}) => {
          let content = fs.readFileSync(fullPath).toString().replace(/\r?\n|\r/g, "")
          let size = theme("spacing.6")
          if (name.endsWith("-mini")) {
            size = theme("spacing.5")
          } else if (name.endsWith("-micro")) {
            size = theme("spacing.4")
          }
          return {
            [`--hero-${name}`]: `url('data:image/svg+xml;utf8,${content}')`,
            "-webkit-mask": `var(--hero-${name})`,
            "mask": `var(--hero-${name})`,
            "mask-repeat": "no-repeat",
            "background-color": "currentColor",
            "vertical-align": "middle",
            "display": "inline-block",
            "width": size,
            "height": size
          }
        }
      }, {values})
    })
  ]
}
