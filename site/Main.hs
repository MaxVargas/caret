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

  match "roam/index.html" $ do
    route $ gsubRoute "^roam/" (const "")
    compile $ do
      body <- getResourceBody
      rendered <- recompilingUnsafeCompiler $
        replaceMath (T.pack (itemBody body))
      subbed <- recompilingUnsafeCompiler $
        substituteHrefs (rendered)
      makeItem (T.unpack subbed)
        >>= loadAndApplyTemplate "templates/default.html" defaultContext

  mvDir "NixOS" "notes/"
  mvDir "Functional" "notes/"
  mvDir "" ""

  -- Copy all other files
  match "templates/*" $ compile templateBodyCompiler

  match "fonts/**" $ do
    route $ idRoute
    compile $ copyFileCompiler

  match "scss/style.scss" $ do
    route $ constRoute "css/style.css"
    compile compileSass

  match "scss/katex.min.css" $ do
    route $ constRoute "css/katex.min.css"
    compile copyFileCompiler

-- This isn't actually correct. But morally... needs fixing
mvDirs :: [String] -> String -> [Rules ()]
mvDirs subdirs dirname = map (\s -> mvDir s dirname) subdirs

mvDir :: String -> String -> Rules ()
mvDir subdir dirname = do
  match (fromGlob ("roam/" <> subdir <> "/**.html")) $ do
    route $ composeRoutes
      (gsubRoute "^roam/" (const dirname))
      (gsubRoute ".html$" (const "/index.html"))
    compile $ do
      body <- getResourceBody
      rendered <- recompilingUnsafeCompiler $
        replaceMath (T.pack (itemBody body))
      subbed <- recompilingUnsafeCompiler $
        substituteHrefs (rendered)
      makeItem (T.unpack subbed)
        >>= loadAndApplyTemplate "templates/default.html" defaultContext

  match (fromGlob ("roam/" <> subdir <> "/**")) $ do
    route $ gsubRoute "^roam/" (const dirname)
    compile $ copyFileCompiler

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
  css <- recompilingUnsafeCompiler $ do
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

substituteHrefs :: T.Text -> IO T.Text
substituteHrefs = go
  where
    go text =
      case findNext text of
        Nothing -> pure text
        -- ref is like href="blah"
        Just (before, ref, after) -> do
          subbed <- substituteHref ref
          rest <- go after
          pure $ before <> subbed <> rest

    findNext text =
      case (T.breakOn "href=\"" text) of
        (beforeHref, hrefOn)
          | T.null hrefOn ->
            Nothing
          | otherwise ->
            findEndQuote beforeHref hrefOn

    findEndQuote before onwards =
      let (href, content) = T.splitAt 6 onwards
          (ref, closing) = T.breakOn "\"" content
      in
        if T.null closing
        then Nothing
        else
          Just
            ( before <> href
            , ref
            , closing
            )

substituteHref :: T.Text -> IO T.Text
substituteHref ref = do
  subbed <- maybeSubbed ref
  pure subbed

  where
    maybeSubbed text =
      case (T.breakOn "http" text) of
        (before, after)
          | T.null after && T.count "Functional" before > 0
            -> pure $ ("notes/" <> fst (T.breakOn ".html" before))
          | T.null after && T.count "NixOS" before > 0
            -> pure $ ("notes/" <> fst (T.breakOn ".html" before))
          | T.null after
            -> pure $ fst (T.breakOn ".html" before)
          | otherwise
            -> pure text
