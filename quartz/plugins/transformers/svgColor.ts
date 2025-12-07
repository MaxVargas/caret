import { QuartzTransformerPlugin } from "../types"

export interface Options {
  renderEngine: str
}

// Hacky way to get SVGs to render with appropriate coloring
// Basically find and replace all images in markdown syntax
// with an appropriate CSS item. The CSS item just gets sent through
// as is with the specified rendering.
const mdImageSVGRegex = /!\[TikZ SVG]*\]\(([^\s]+[.](png|svg|jpeg))\)/g

export const TikZSVG: QuartzTransformerPlugin<Partial<Options>> = (userOpts) => {
  const ops = { ...userOpts }
  return {
    name: "TikZSVG",
    textTransform(_ctx, src) {
      src = src.toString()
      src = src.replaceAll(mdImageSVGRegex, (value, ...capture) => {
        console.log(value.slice(12,-1))
        const cssData = "<img src=\"../"+value.slice(12,-1)+"\" alt=\"TikZ SVG\" class=\"tikz-color\">\n"
        return cssData
      })
      return src
    }
  }
}
