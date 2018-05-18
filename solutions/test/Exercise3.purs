module Test.Exercise3 where

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
  suite "Ex 3 (FFI)" do
    test "1 Format date using MomentJS" do
      Assert.equal "June 1st 2018, 7:37:15 am" (formatDate "2018-06-01 07:37:15")

foreign import momentFormatDate :: String -> String

formatDate :: String -> String
formatDate dateStr = momentFormatDate dateStr
