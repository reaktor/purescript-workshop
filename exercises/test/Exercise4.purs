module Test.Exercise4 where

import Prelude

import Control.Monad.Eff (Eff)
import Test.Unit (TestSuite, suite, suiteSkip, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (run, runTestWith)
import Test.Unit.Output.TAP (runTest)

main :: Eff _ Unit
main = run (runTestWith runTest tests)

tests :: TestSuite _
tests = do
  suiteSkip "Ex 4 (type classes)" do
    test "1 use type classes" do
      Assert.equal 1 0
