module Main where

import Prelude

import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (log)

main :: Eff _ Unit
main = log "Hello!"
