import tex2svg from 'node-tikzjax';
import { QuartzTransformerPlugin } from "../types"

interface Options {
  renderEngine: "tikzjax"
  customMacros: MacroType
}

interface MacroType {
  [key: string]: string
}

const tikzRegex = new RegExp(```tikz([\s\S]*?)```)

export const TikZ: QuartzTransformerPlugin<Partial<Options>> = (opts) => {
  const engine = opts?.renderEngine ?? "tikzjax"
  const macros = opts?.customMacros ?? {}
  return {
    name: "TikZ",
    textTransform(_ctx, src) {
      // Just want to replace markdown comments ```tikz BLAH``` with html tags
      src = src.toString()
      src = src.replaceAll(predefinedHeadingIdRegex, (value, ...capture) => {
        const [headingText] = capture
        return headingText
      })
    }
    externalResources() {
      return {
        css: [
          // base css
          "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.16.9/katex.min.css",
        ],
        js: [
          {
            // fix copy behaviour: https://github.com/KaTeX/KaTeX/blob/main/contrib/copy-tex/README.md
            src: "https://cdnjs.cloudflare.com/ajax/libs/KaTeX/0.16.9/contrib/copy-tex.min.js",
            loadTime: "afterDOMReady",
            contentType: "external",
          },
        ],
      }
    },
  }
}
