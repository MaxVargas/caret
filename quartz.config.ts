import { QuartzConfig } from "./quartz/cfg"
import * as Plugin from "./quartz/plugins"

/**
 * Quartz 4 Configuration
 *
 * See https://quartz.jzhao.xyz/configuration for more information.
 */
const config: QuartzConfig = {
  configuration: {
    pageTitle: "How do you think?",
    pageTitleSuffix: "",
    enableSPA: true,
    enablePopovers: true,
    analytics: {
      provider: "plausible",
    },
    locale: "en-US",
    baseUrl: "MaxVargas.github.io/caret",
    ignorePatterns: ["private", "templates", ".obsidian"],
    defaultDateType: "modified",
    theme: {
      fontOrigin: "local",
      // cdnCaching: true,
      typography: {
        title: "Sixgun", // "Raleway",
        header: "Euler", // "Schibsted Grotesk",
        body: "Aporetic", // "Source Sans Pro", 
        code: "Fantasque", //"IBM Plex Mono",
      },
      colors: {
        lightMode: {
          light: "#d5ccba",
          lightgray: "#b2b1b0",
          gray: "#6d6d6d",
          darkgray: "#705341",
          dark: "#97522c",
          secondary: "#4c602c",
          tertiary: "#989a9c",
          highlight: "#c9bfab",
          textHighlight: "#c9c0af",
        },
        darkMode: {
          light: "#1e1e0e",
          lightgray: "#302f11",
          gray: "#646464",
          darkgray: "#a08c78",
          dark: "#c19a6b",
          secondary: "#CC5500",
          tertiary: "#fffdd0",
          highlight: "#262612",
          textHighlight: "#262612",
        },
      },
    },
  },
  plugins: {
    transformers: [
      Plugin.FrontMatter(),
      Plugin.CreatedModifiedDate({
        priority: ["frontmatter", "git", "filesystem"],
      }),
      Plugin.SyntaxHighlighting({
        theme: {
          light: "github-light",
          dark: "github-dark",
        },
        keepBackground: false,
      }),
      Plugin.ObsidianFlavoredMarkdown({ enableInHtmlEmbed: false }),
      Plugin.GitHubFlavoredMarkdown(),
      Plugin.TableOfContents(),
      Plugin.CrawlLinks({ markdownLinkResolution: "shortest" }),
      Plugin.Description(),
      Plugin.Latex({ renderEngine: "katex" }),
    ],
    filters: [Plugin.RemoveDrafts()],
    emitters: [
      Plugin.AliasRedirects(),
      Plugin.ComponentResources(),
      Plugin.ContentPage(),
      Plugin.FolderPage(),
      Plugin.TagPage(),
      Plugin.ContentIndex({
        enableSiteMap: true,
        enableRSS: true,
      }),
      Plugin.Assets(),
      Plugin.Static(),
      Plugin.Favicon(),
      Plugin.NotFoundPage(),
      // Comment out CustomOgImages to speed up build time
      // Plugin.CustomOgImages(),
    ],
  },
}

export default config
