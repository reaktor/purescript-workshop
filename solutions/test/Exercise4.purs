module Test.Exercise4 where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Data.Either (Either(Left, Right))
import Data.Foreign (MultipleErrors)
import Network.HTTP.Affjax as Affjax
import Simple.JSON as SimpleJSON
import Simple.JSON as SimpleJson
import Test.Unit (TestSuite, suite, suiteSkip, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (run, runTestWith)
import Test.Unit.Output.TAP (runTest)

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

main :: Eff _ Unit
main = run (runTestWith runTest tests)

tests :: TestSuite _
tests = do
  suite "Ex 4 (network)" do
    test "parse the author of the first PureScript commit" do
      Assert.equal
        (Right "Phil Freeman")
        (parseAuthor firstPureScriptCommit)
    test "parse the SHA commit hash for first PureScript commit" do
      Assert.equal
        (Right "291a6d4ddd88c65a8a0c5368441c1b7c639ca854")
        (parseCommitHash firstPureScriptCommit)
    test "find the date of the first commit to the public PureScript repo" do
      commit <- fetchGitHubCommit
      Assert.equal (Right "asdf2013-09-30T05:29:23Z") (_.commit.author.date <$> commit)
      
parseAuthor :: String -> Either MultipleErrors String
parseAuthor commitStr = do
  (parsed :: { commit :: { author :: { name :: String } } }) <- SimpleJSON.readJSON commitStr
  pure parsed.commit.author.name

parseCommitHash :: String -> Either MultipleErrors String
parseCommitHash commitStr = do
  (parsed :: { url :: String }) <- SimpleJSON.readJSON commitStr
  pure parsed.url

gitHubApiUrl :: String
gitHubApiUrl = "https://api.github.com/repos/purescript/purescript/commits/291a6d4ddd88c65a8a0c5368441c1b7c639ca854"

type GitHubCommit = {
  commit :: {
    author :: { date :: String }
  }
} 

fetchGitHubCommit :: Aff _ (Either MultipleErrors GitHubCommit)
fetchGitHubCommit = do
  result <- Affjax.get gitHubApiUrl
  pure (SimpleJson.readJSON result.response)
