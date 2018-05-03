module Test.Main where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Array as Array
import Data.Foldable (all)
import Data.Record (class EqualFields)
import Data.Record as Record
import Data.Tuple (Tuple(..))
import HackerNewsApi (Story, hackerNewsStories)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Type.Row (class RowToList)

main :: forall e. Eff _ Unit
main = runTest $ do
  suite "Basic functional transformations" do
    test "list the authors of the sample Hacker News stories" do
      Assert.equal
        ["bpierre", "pka", "sharkdp", "paf31", "dstronczak", "purescript"]
        (listAuthors hackerNewsStories)
    
    -- test "list the IDs of stories with more than 100 points" do
    --   Assert.equal
    --     ["8351981", "13551404", "9644324"]
    --     (listHighPointStoryIds hackerNewsStories)
    
    -- test "find the stories shared by author \"paf31\" (Phil Freeman - the original author of PureScript)" do
    --   Assert.assert
    --     "you did not find Phil's links"
    --     (eqRecordArrays
    --       [{created_at: "2013-11-01T03:09:13.000Z",
    --         title: "PureScript",
    --         url: "http://github.com/paf31/purescript",
    --         author: "paf31",
    --         points: 59,
    --         num_comments: 17,
    --         objectID: "6651572"}]
    --       (philStories hackerNewsStories))

listAuthors :: Array Story -> Array String
listAuthors stories = []

listHighPointStoryIds :: Array Story -> Array String
listHighPointStoryIds stories = []

philStories :: Array Story -> Array Story
philStories stories = []

-- Helpers
eqRecordArrays :: forall r rs
                  . RowToList r rs
                  => EqualFields rs r
                  => Array { | r } -> Array { | r } -> Boolean
eqRecordArrays arr1 arr2 | Array.length arr1 /= Array.length arr2 = false
eqRecordArrays arr1 arr2 = all (\(Tuple r1 r2) -> Record.equal r1 r2) $ Array.zip arr1 arr2
