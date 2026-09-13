{-# LANGUAGE OverloadedStrings #-}

module Main where

import Hakyll
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import System.FilePath (takeBaseName)
import System.Process
import System.Exit
import System.IO

main :: IO ()
main = hakyll $ do

  -- Everything in roam/ is copied into _site/
  -- Start with .html files
  match "roam/**.html" $ do
    route $ gsubRoute "^roam/" (const "")
    compile $ do
      body <- getResourceBody
      rendered <- unsafeCompiler $
        replaceMath (T.pack (itemBody body))
      makeItem (T.unpack rendered)
        >>= loadAndApplyTemplate "templates/default.html" defaultContext

  -- Copy all other files
  match "templates/*" $ compile templateBodyCompiler

  match "roam/**" $ do
    route $ gsubRoute "^roam/" (const "")
    compile $ copyFileCompiler

  match "fonts/**" $ do
    route $ idRoute
    compile $ copyFileCompiler

  match "scss/style.scss" $ do
    route $ constRoute "css/style.css"
    compile compileSass

  match "scss/katex.min.css" $ do
    route $ constRoute "css/katex.min.css"
    compile copyFileCompiler

renderKatex :: Bool -> T.Text -> IO T.Text
renderKatex display math = do
  let args =
        if display
        then ["-F", "html", "-d", "-t"]
        else ["-F", "html", "-t"]

  (Just hin, Just hout, _, ph) <-
    createProcess
      (proc "katex" args)
        { std_in  = CreatePipe
        , std_out = CreatePipe
        }

  TIO.hPutStr hin math
  hClose hin

  result <- TIO.hGetContents hout
  _ <- waitForProcess ph

  pure result

replaceMath :: T.Text -> IO T.Text
replaceMath = go
  where
    go text =
      case findNext text of
        Nothing -> pure text
        Just (before, display, math, after) -> do
          rendered <- renderKatex display math
          rest <- go after
          pure $ before <> rendered <> rest

    findNext text =
      case (T.breakOn "\\(" text, T.breakOn "\\[" text) of
        ((beforeInline, inlineRest),
         (beforeDisplay, displayRest))
          | T.null inlineRest && T.null displayRest ->
            Nothing
          | T.null inlineRest ->
            findDisplay beforeDisplay displayRest
          | T.null displayRest ->
            findInline beforeDisplay displayRest
          | T.length beforeInline <= T.length beforeDisplay ->
            findInline beforeInline inlineRest
          | otherwise ->
            findDisplay beforeDisplay displayRest

    findInline before rest =
      let content = T.drop 2 rest
          (math, closing) = T.breakOn "\\)" content
      in
        if T.null closing
        then Nothing
        else
          Just
            ( before
            , False
            , math
            , T.drop 2 closing
            )

    findDisplay before rest =
      let content = T.drop 2 rest
          (math, closing) = T.breakOn "\\]" content
      in
        if T.null closing
        then Nothing
        else
          Just
            ( before
            , True
            , math
            , T.drop 2 closing
            )

compileSass :: Compiler (Item String)
compileSass = do
  css <- unsafeCompiler $ do
    (exitCode, stdout, stderr) <-
      readProcessWithExitCode
        "sass"
        [ "--no-source-map"
        , "--style=expanded"
        , "scss/style.scss"
        ]
        ""

    case exitCode of
      ExitSuccess ->
        pure stdout
      ExitFailure n ->
        error $
          "sass failed with exit code "
          ++ show n
          ++ ":\n"
          ++ stderr

  makeItem css
