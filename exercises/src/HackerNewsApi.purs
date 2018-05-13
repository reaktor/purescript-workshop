module HackerReader.HackerNewsApi where

import Prelude

import Control.Monad.Aff (Aff)
import Data.Either (Either)
import Data.Foreign (MultipleErrors)
import Data.String as Str
import Network.HTTP.Affjax (AJAX)
import Network.HTTP.Affjax as Affjax
import Simple.JSON as SimpleJson

type QueryResult = 
  { hits :: Array Story }

type Story = 
  { author :: String
  , created_at :: String
  , objectID :: String
  , num_comments :: Int
  , points :: Int
  , title :: String
  , url :: String }

hackerNewsApi :: String
hackerNewsApi = "https://hn.algolia.com/api/v1/search"

hackerNewsStoryIds :: Array Int
hackerNewsStoryIds = [14701199, 4289910, 11174806, 7943303, 12429681, 12571904, 5098981, 7160242, 13577486, 10930298, 11097514, 9503580, 10640478]

storiesUrl :: Array Int -> String
storiesUrl storyIds = hackerNewsApi <> "?tags=story,(" <> storyTags <> ")"
  where storyTags = Str.joinWith "," (mkStoryTag <$> storyIds)

mkStoryTag :: Int -> String
mkStoryTag id = "story_" <> show id

fetchHackerNewsStories :: forall e. Aff (ajax :: AJAX | e) (Either MultipleErrors (Array Story))
fetchHackerNewsStories = do
  result <- Affjax.get $ storiesUrl hackerNewsStoryIds
  let (decoded :: Either MultipleErrors QueryResult) = SimpleJson.readJSON result.response
  pure $ map _.hits decoded
