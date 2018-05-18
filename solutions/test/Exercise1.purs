module Test.Exercise1 where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Array as Array
import Data.Foldable (all, sum)
import Data.Record (class EqualFields)
import Data.Record as Record
import Data.Tuple (Tuple(Tuple))
import Test.Unit (TestSuite, suite, test, testSkip)
import Test.Unit.Assert as Assert
import Test.Unit.Main (run, runTestWith)
import Test.Unit.Output.TAP (runTest)
import Type.Row (class RowToList)

type Story = 
  { author :: String
  , created_at :: String
  , objectID :: String
  , num_comments :: Int
  , points :: Int
  , title :: String
  , url :: String }

hackerNewsStories :: Array Story
hackerNewsStories = [
  {
    created_at: "2014-09-22T19:04:49.000Z",
    title: "PureScript: a statically typed language which compiles to JavaScript",
    url: "https://github.com/purescript/purescript",
    author: "bpierre",
    points: 175,
    num_comments: 78,
    objectID: "8351981"
  },
  {
    created_at: "2017-02-02T15:58:22.000Z",
    title: "Introducing PureScript Erlang back end",
    url: "http://nwolverson.uk/devlog/2016/08/01/introducing-purescript-erlang.html",
    author: "pka",
    points: 174,
    num_comments: 31,
    objectID: "13551404"
  },
  {
    created_at: "2015-06-02T06:59:03.000Z",
    title: "Show HN: A puzzle game inspired by functional programming, written in PureScript",
    url: "http://david-peter.de/cube-composer",
    author: "sharkdp",
    points: 121,
    num_comments: 49,
    objectID: "9644324"
  },
  {
    created_at: "2013-11-01T03:09:13.000Z",
    title: "PureScript",
    url: "http://github.com/paf31/purescript",
    author: "paf31",
    points: 59,
    num_comments: 17,
    objectID: "6651572"
  },
  {
    created_at: "2015-05-27T10:14:57.000Z",
    title: "Purescript will make you purr like a kitten",
    url: "http://blog.sigmapoint.pl/purescript-will-make-you-purr-like-a-kitten/",
    author: "dstronczak",
    points: 17,
    num_comments: 0,
    objectID: "9610375"
  },
  {
    created_at: "2015-04-07T17:49:15.000Z",
    title: "purescript-halogen – A declarative, type-safe UI library for PureScript",
    url: "https://github.com/slamdata/purescript-halogen",
    author: "purescript",
    points: 13,
    num_comments: 0,
    objectID: "9335761"
  }
]

main :: Eff _ Unit
main = run (runTestWith runTest tests)

tests :: TestSuite _
tests =
  suite "Ex 1 (types)" $ do
    test "1 Record: get field" do
      Assert.equal
        "123 Barry St"
        (getStreet { street: "123 Barry St", city: "P-town" })

    test "2 Record: update field" do
      Assert.assert
        "Records are not equal"
        (Record.equal
            { street: "127 Barry St", city: "P-town" }
            (updateStreet "127 Barry St" { street: "123 Barry St", city: "P-town" }))

    test "3 Record: print fields to string" do
      Assert.equal
        "123 Barry St, P-town"
        (showAddress { street: "123 Barry St", city: "P-town" })

    test "4 Functions: sum numbers" do
      Assert.equal
        203
        (sumNumbers [3, 7, 5, 12, 176])

    test "5 List the authors of the sample Hacker News stories" do
      Assert.equal
        ["bpierre", "pka", "sharkdp", "paf31", "dstronczak", "purescript"]
        (listAuthors hackerNewsStories)

    test "6 List the IDs of stories with more than 100 points" do
      Assert.equal
        ["8351981", "13551404", "9644324"]
        (listHighPointStoryIds hackerNewsStories)

    test "7 Find the stories shared by author \"paf31\"" do
      Assert.assert
        "You did not find Phil's links"
        (eqRecordArrays
        [{created_at: "2013-11-01T03:09:13.000Z",
            title: "PureScript",
            url: "http://github.com/paf31/purescript",
            author: "paf31",
            points: 59,
            num_comments: 17,
            objectID: "6651572"}]
        (philStories hackerNewsStories))
      
type Address = { street :: String, city :: String }

getStreet :: Address -> String
getStreet address = address.street

updateStreet :: String -> Address -> Address
updateStreet newStreet address = address { street = newStreet }

showAddress :: Address -> String
showAddress address = address.street <> ", " <> address.city

sumNumbers :: Array Int -> Int
sumNumbers nums = sum nums

listAuthors :: Array Story -> Array String
listAuthors stories = map (\story -> story.author) stories
-- Or equivalently
-- listAuthors stories = map _.author stories

listHighPointStoryIds :: Array Story -> Array String
-- listHighPointStoryIds stories =
--   map (\story -> story.objectID) $
--   Array.filter (\story -> story.points > 100) stories

-- Or more succinctly:
-- listHighPointStoryIds stories =
--   map _.objectID $
--   Array.filter (\{points} -> points > 100) stories

-- Or using "pipe" style
-- listHighPointStoryIds stories = stories
--   # Array.filter (\story -> story.points > 100)
--   # map _.objectID

-- Or adding local variables:
listHighPointStoryIds stories = stories
  # Array.filter hasHighPoints
  # map _.objectID
  where
    hasHighPoints story = story.points > 100

philStories :: Array Story -> Array Story
philStories stories = Array.filter (\story -> story.author == "paf31") stories

-- Helpers
eqRecordArrays :: forall r rs
                  . RowToList r rs
                  => EqualFields rs r
                  => Array { | r } -> Array { | r } -> Boolean
eqRecordArrays arr1 arr2 | Array.length arr1 /= Array.length arr2 = false
eqRecordArrays arr1 arr2 = all (\(Tuple r1 r2) -> Record.equal r1 r2) $ Array.zip arr1 arr2
