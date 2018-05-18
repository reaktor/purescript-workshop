module Test.Exercise4 where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Data.Either (Either(..))
import Simple.JSON as SimpleJson
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
      Assert.equal "{ \"foo\": \"bar\" }" (SimpleJson.writeJSON { foo: "bar" })
    test "find the date of the first commit to the public PureScript repo" do
      Assert.equal "2013-09-30T05:29:23Z" "a"

type GitHubCommit = {
  commit :: {
    author :: { date :: String }
  }
} 

gitHubApiUrl :: String
gitHubApiUrl = "https://api.github.com/repos/purescript/purescript/commits/291a6d4ddd88c65a8a0c5368441c1b7c639ca854"

fetchGitHubCommit :: Aff _ (Either MultipleErrors GitHubCommit)
fetchGitHubCommit = do
  result <- Affjax.get gitHubApiUrl
  let (decoded :: Either MultipleErrors QueryResult) = SimpleJson.readJSON result.response
  pure $ map _.hits decoded
