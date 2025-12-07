const { default : { default : tex2svg } } = await import('node-tikzjax');
import { QuartzTransformerPlugin } from "../types"

export interface Options {
  renderEngine: str
}

const defaultOptions: Options = {
  renderEngine: "tikzjax",
}

const tikzRegex = new RegExp("\`\`\`tikz\\n([\\s\\S]*?)\\n\`\`\`", "g")

export const TikZ: QuartzTransformerPlugin<Partial<Options>> = (userOpts) => {
  const ops = { ...defaultOptions, ...userOpts }
  return {
    name: "TikZ",
    textTransform(_ctx, src) {
      src = src.toString()
      src = src.replaceAll(tikzRegex, (value, ...capture) => {
        nonAsyncTex2svg(capture[0]).then((result) => {return result;});
      })
      return src
    }
  }
}
