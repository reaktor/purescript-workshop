module HackerReader.Main where

import Prelude hiding (div)

import Control.Monad.Eff.Console (log)
import Control.Monad.Eff (Eff)
  
main :: Eff _ Unit
main = do
  log "Hello! This exercise is in the test/ directory"
