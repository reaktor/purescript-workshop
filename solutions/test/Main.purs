module Test.Main where

import Prelude

import Effect (Effect)
import Test.Exercise1 as Exercise1
import Test.Exercise2 as Exercise2
import Test.Exercise3 as Exercise3
import Test.Exercise4 as Exercise4
import Test.Unit.Main (run, runTestWith)
import Test.Unit.Output.TAP (runTest)

main :: Effect Unit
main = run $ runTestWith runTest $ do
  Exercise1.tests
  Exercise2.tests
  Exercise3.tests
  Exercise4.tests
