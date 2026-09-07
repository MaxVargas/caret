{-# LANGUAGE OverloadedStrings #-}

module Main where

import Hakyll
import qualified Data.Text as T
import qualified Data.Text.IO as TIO
import System.Process
import System.IO

main :: IO ()
main = hakyll $ do

  match "templates/*" $ compile templateBodyCompiler

  -- Everything in roam/ is copied into _site/
  match "roam/**/*.html" $ do
    route $ gsubRoute "^roam/" (const "")
    compile $ do
      body <- getResourceBody
      rendered <- unsafeCompiler $
        replaceMath (itemBody body)
      makeItem rendered
        >>= loadAndApplyTemplate "templates/default.html" defaultContext

  match "roam/**" $ do
    route $ gsubRoute "^roam/" (const "")
    compile $ copyFileCompiler

  -- match "css/**" $ do


renderKatex :: Bool -> String -> IO String
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

  TIO.hPutStr hin (T.pack math)
  hClose hin

  result <- TIO.hGetContents hout
  _ <- waitForProcess ph

  pure (T.unpack result)

replaceMath :: String -> IO String
replaceMath = go
  where
    go text =
      case findNext text of
        Nothing -> pure text
        Just (before, display, math, after) -> do
          rendered <- renderKatex display math
          rest <- go after
          pure $ before ++ rendered ++ rest

    findNext text =
      case (breakOn "\\(" text, breakOn "\\[" text) of
        ((beforeInline, inlineRest),
         (beforeDisplay, displayRest))
          | null inlineRest && null displayRest ->
            Nothing
          | null inlineRest ->
            findDisplay beforeDisplay displayRest
          | null displayRest ->
            findInline beforeDisplay displayRest
          | length beforeInline <= length beforeDisplay ->
            findInline beforeInline inlineRest
          | otherwise ->
            findDisplay beforeDisplay displayRest

    findInline before rest =
      let content = drop 2 rest
          (math, closing) = breakOn "\\)" content
      in
        if null closing
        then Nothing
        else
          Just
            ( before
            , False
            , math
            , drop 2 closing
            )

    findDisplay before rest =
      let content = drop 2 rest
          (math, closing) = breakOn "\\]" content
      in
        if null closing
        then Nothing
        else
          Just
            ( before
            , True
            , math
            , drop 2 closing
            )

    breakOn needle haystack =
      let (a, b) = goBreak haystack
      in  (a, b)
      where
        goBreak [] = ([], [])
        goBreak xs
          | take (length needle) xs == needle =
            ([], xs)
          | otherwise =
            let (a, b) = goBreak (tail xs)
            in (head xs : a, b)
