module Test.Exercise4 where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Data.Either (Either(Left, Right))
import Data.Foreign (MultipleErrors)
import Data.Maybe (Maybe(..))
import Network.HTTP.Affjax as Affjax
import Simple.JSON as SimpleJson
import Test.Unit (TestSuite, suite, suiteSkip, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (run, runTestWith)
import Test.Unit.Output.TAP (runTest)

main :: Eff _ Unit
main = run (runTestWith runTest tests)

tests :: TestSuite _
tests = do
  suite "Ex 4 (type classes)" do
    test "1 joining strings together" do
      Assert.equal
        "Hey there, Matti Meikäläinen!"
        (sayHi { firstName: "Matti", lastName: "Meikäläinen" })

    test "2 concatenating arrays" do
      Assert.equal
        [2, 5, 7, 3, 6, 8]
        (mergeUserIds [2, 5, 7] [3, 6, 8])

    test "3 merging optional results" do
      Assert.equal
        (Just [1, 2, 3, 4, 5])
        (mergeOptionalResults (Just [1, 2]) Nothing (Just [3, 4, 5]))
    
    test "4 adds ten to each value in the array" do
      Assert.equal
        [15, 25, 35]
        (addTenToArrayValues [5, 15, 25])
        
    test "5 does nothing if array is empty" do
      Assert.equal
        []
        (addTenToArrayValues [])
        
    test "6 adds ten to a maybe value, if there is a value" do
      Assert.equal
        (Just 110)
        (addTenToMaybeValue (Just 100))
        
    test "7 does nothing if there is no value" do
      Assert.equal
        Nothing
        (addTenToMaybeValue Nothing)
        
    test "8 adds ten to the value on the right side of an Either" do
      Assert.equal
        (Right 110)
        (addTenToEitherValue (Right 100))
    test "9 does nothing if there is an error on the left side" do
      Assert.equal
        (Left "error")
        (addTenToEitherValue (Left "error"))

    test "10 add ten to the result of an asynchronous network call" do
      result <- addTenToNetworkResponse validNetworkResponse
      Assert.equal 110 result
      
    test "11 add ten to anything you can map over (like all of the above)" do
      Assert.equal [15, 25, 35] (addTen [5, 15, 25])
      Assert.equal [] (addTen [])
      Assert.equal (Just 110) (addTen (Just 100))
      Assert.equal Nothing (addTen Nothing)
      Assert.equal (Right 110) (addTen (Right 100 :: Either String Int))
      Assert.equal (Left "error") (addTen (Left "error"))
      result <- addTen validNetworkResponse
      Assert.equal 110 result

    -- Example: encoding JSON using type classes
    test "12 encoding JSON" do
      Assert.equal "1" (SimpleJson.writeJSON 1)
      Assert.equal "[]" (SimpleJson.writeJSON ([] :: Array Int))
      Assert.equal "{\"userId\":343223}" (SimpleJson.writeJSON {userId: 343223})
      Assert.equal
        "{\"author\":{\"login\":\"paf31\",\"id\":630306}}"
        (SimpleJson.writeJSON {author: {login: "paf31", id: 630306}})
        
    test "13 decoding JSON: parse the URL of the first PureScript commit" do
      Assert.equal
        (Right "https://api.github.com/repos/purescript/purescript/commits/291a6d4ddd88c65a8a0c5368441c1b7c639ca854")
        (parseUrlFromResponse firstPureScriptCommit)
        
    test "14 parse the SHA commit hash for first PureScript commit" do
      Assert.equal
        (Right "291a6d4ddd88c65a8a0c5368441c1b7c639ca854")
        (parseCommitFromResponse firstPureScriptCommit)
        
    test "15 parse the author of the first PureScript commit" do
      Assert.equal
        (Right "Phil Freeman")
        (parseAuthorFromResponse firstPureScriptCommit)

firstPureScriptCommit :: String
firstPureScriptCommit = """
{
  "sha": "291a6d4ddd88c65a8a0c5368441c1b7c639ca854",
  "commit": {
    "author": {
      "name": "Phil Freeman",
      "email": "paf31@cantab.net",
      "date": "2013-09-30T05:29:23Z"
    },
    "committer": {
      "name": "Phil Freeman",
      "email": "paf31@cantab.net",
      "date": "2013-09-30T05:29:23Z"
    },
    "message": "Initial commit",
    "tree": {
      "sha": "2d0fa28ed4623e4300d2137cdb396bf74c8e9eef",
      "url": "https://api.github.com/repos/purescript/purescript/git/trees/2d0fa28ed4623e4300d2137cdb396bf74c8e9eef"
    },
    "url": "https://api.github.com/repos/purescript/purescript/git/commits/291a6d4ddd88c65a8a0c5368441c1b7c639ca854",
    "comment_count": 0,
    "verification": {
      "verified": false,
      "reason": "unsigned",
      "signature": null,
      "payload": null
    }
  },
  "url": "https://api.github.com/repos/purescript/purescript/commits/291a6d4ddd88c65a8a0c5368441c1b7c639ca854",
  "html_url": "https://github.com/purescript/purescript/commit/291a6d4ddd88c65a8a0c5368441c1b7c639ca854",
  "comments_url": "https://api.github.com/repos/purescript/purescript/commits/291a6d4ddd88c65a8a0c5368441c1b7c639ca854/comments",
  "author": {
    "login": "paf31",
    "id": 630306,
    "avatar_url": "https://avatars0.githubusercontent.com/u/630306?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/paf31",
    "html_url": "https://github.com/paf31",
    "followers_url": "https://api.github.com/users/paf31/followers",
    "following_url": "https://api.github.com/users/paf31/following{/other_user}",
    "gists_url": "https://api.github.com/users/paf31/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/paf31/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/paf31/subscriptions",
    "organizations_url": "https://api.github.com/users/paf31/orgs",
    "repos_url": "https://api.github.com/users/paf31/repos",
    "events_url": "https://api.github.com/users/paf31/events{/privacy}",
    "received_events_url": "https://api.github.com/users/paf31/received_events",
    "type": "User",
    "site_admin": false
  },
  "committer": {
    "login": "paf31",
    "id": 630306,
    "avatar_url": "https://avatars0.githubusercontent.com/u/630306?v=4",
    "gravatar_id": "",
    "url": "https://api.github.com/users/paf31",
    "html_url": "https://github.com/paf31",
    "followers_url": "https://api.github.com/users/paf31/followers",
    "following_url": "https://api.github.com/users/paf31/following{/other_user}",
    "gists_url": "https://api.github.com/users/paf31/gists{/gist_id}",
    "starred_url": "https://api.github.com/users/paf31/starred{/owner}{/repo}",
    "subscriptions_url": "https://api.github.com/users/paf31/subscriptions",
    "organizations_url": "https://api.github.com/users/paf31/orgs",
    "repos_url": "https://api.github.com/users/paf31/repos",
    "events_url": "https://api.github.com/users/paf31/events{/privacy}",
    "received_events_url": "https://api.github.com/users/paf31/received_events",
    "type": "User",
    "site_admin": false
  },
  "parents": [],
  "stats": {
    "total": 31,
    "additions": 31,
    "deletions": 0
  },
  "files": [
    {
      "sha": "477a3533dd451ea9889abd84b73bb4f7f8d2cfea",
      "filename": ".gitignore",
      "status": "added",
      "additions": 7,
      "deletions": 0,
      "changes": 7,
      "blob_url": "https://github.com/purescript/purescript/blob/291a6d4ddd88c65a8a0c5368441c1b7c639ca854/.gitignore",
      "raw_url": "https://github.com/purescript/purescript/raw/291a6d4ddd88c65a8a0c5368441c1b7c639ca854/.gitignore",
      "contents_url": "https://api.github.com/repos/purescript/purescript/contents/.gitignore?ref=291a6d4ddd88c65a8a0c5368441c1b7c639ca854",
      "patch": "@@ -0,0 +1,7 @@\n+dist\n+cabal-dev\n+*.o\n+*.hi\n+*.chi\n+*.chs.h\n+.virthualenv"
    },
    {
      "sha": "87b8a3c809b6d88017affe9e6c9063054189ecc7",
      "filename": "LICENSE",
      "status": "added",
      "additions": 20,
      "deletions": 0,
      "changes": 20,
      "blob_url": "https://github.com/purescript/purescript/blob/291a6d4ddd88c65a8a0c5368441c1b7c639ca854/LICENSE",
      "raw_url": "https://github.com/purescript/purescript/raw/291a6d4ddd88c65a8a0c5368441c1b7c639ca854/LICENSE",
      "contents_url": "https://api.github.com/repos/purescript/purescript/contents/LICENSE?ref=291a6d4ddd88c65a8a0c5368441c1b7c639ca854",
      "patch": "@@ -0,0 +1,20 @@\n+The MIT License (MIT)\n+\n+Copyright (c) 2013 Phil Freeman\n+\n+Permission is hereby granted, free of charge, to any person obtaining a copy of\n+this software and associated documentation files (the \"Software\"), to deal in\n+the Software without restriction, including without limitation the rights to\n+use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of\n+the Software, and to permit persons to whom the Software is furnished to do so,\n+subject to the following conditions:\n+\n+The above copyright notice and this permission notice shall be included in all\n+copies or substantial portions of the Software.\n+\n+THE SOFTWARE IS PROVIDED \"AS IS\", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR\n+IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS\n+FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR\n+COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER\n+IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN\n+CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE."
    },
    {
      "sha": "1e057f6c5bbcc6795408e3e74584beec0254c15e",
      "filename": "README.md",
      "status": "added",
      "additions": 4,
      "deletions": 0,
      "changes": 4,
      "blob_url": "https://github.com/purescript/purescript/blob/291a6d4ddd88c65a8a0c5368441c1b7c639ca854/README.md",
      "raw_url": "https://github.com/purescript/purescript/raw/291a6d4ddd88c65a8a0c5368441c1b7c639ca854/README.md",
      "contents_url": "https://api.github.com/repos/purescript/purescript/contents/README.md?ref=291a6d4ddd88c65a8a0c5368441c1b7c639ca854",
      "patch": "@@ -0,0 +1,4 @@\n+purescript\n+==========\n+\n+A small strongly, statically typed compile-to-JS language with basic extensible records and type-safe blocks"
    }
  ]
}
"""

type User =
  { firstName :: String
  , lastName :: String }

sayHi :: User -> String
sayHi {firstName, lastName} = "Hey there, " <> firstName <> " " <> lastName <> "!"

mergeUserIds :: Array Int -> Array Int -> Array Int
mergeUserIds ids1 ids2 = ids1 <> ids2

mergeOptionalResults :: Maybe (Array Int) -> Maybe (Array Int) -> Maybe (Array Int) -> Maybe (Array Int)
mergeOptionalResults a b c = a <> b <> c

addTenToArrayValues :: Array Int -> Array Int
addTenToArrayValues ints = map ((+) 10) ints

addTenToMaybeValue :: Maybe Int -> Maybe Int
addTenToMaybeValue int = map ((+) 10) int

addTenToEitherValue :: Either String Int -> Either String Int
addTenToEitherValue result = map ((+) 10) result

validNetworkResponse :: Aff _ Int
validNetworkResponse = pure 100

addTenToNetworkResponse :: Aff _ Int -> Aff _ Int
addTenToNetworkResponse response = map ((+) 10) response

addTen :: forall f. Functor f => f Int -> f Int
addTen f = map ((+) 10) f

parseUrlFromResponse :: String -> Either MultipleErrors String
parseUrlFromResponse respStr = map parseUrl (SimpleJson.readJSON respStr)
  where
    parseUrl :: { url :: String } -> String
    parseUrl resp = resp.url

parseCommitFromResponse :: String -> Either MultipleErrors String
parseCommitFromResponse respStr = map parseUrl (SimpleJson.readJSON respStr)
  where
    parseUrl :: { sha :: String } -> String
    parseUrl resp = resp.sha
      
parseAuthorFromResponse :: String -> Either MultipleErrors String
parseAuthorFromResponse respStr = map parseUrl (SimpleJson.readJSON respStr)
  where
    parseUrl :: { commit :: { author :: { name :: String } } } -> String
    parseUrl resp = resp.commit.author.name
