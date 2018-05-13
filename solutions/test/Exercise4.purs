module Test.Exercise4 where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Array as Array
import Data.Foldable (all)
import Data.Record (class EqualFields)
import Data.Record as Record
import Data.Tuple (Tuple(Tuple))
import HackerNewsApi (Story, hackerNewsStories)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Type.Row (class RowToList)

main :: Eff _ Unit
main = runTest $ do
  suite "Type classes" do
    test "use type classes" do
      Assert.equal 1 0
