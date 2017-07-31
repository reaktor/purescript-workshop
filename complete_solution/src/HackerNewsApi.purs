module HackerNewsApi where

import Prelude

import Control.Monad.Aff (Aff)
import Control.Monad.Except (runExcept)
import Data.Either (Either)
import Data.Foreign (MultipleErrors)
import Data.Foreign.Class (class Decode)
import Data.Foreign.Generic (decodeJSON, defaultOptions, genericDecode)
import Data.Foreign.Generic.Types (Options)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.String as Str
import Network.HTTP.Affjax (AJAX)
import Network.HTTP.Affjax as Affjax

jsonDecodeOptions :: Options
jsonDecodeOptions = defaultOptions { unwrapSingleConstructors = true }

newtype QueryResult = QueryResult
  { hits :: Array Story }

derive instance genericQueryResult :: Generic QueryResult _
instance showQueryResult :: Show QueryResult where
  show = genericShow
instance decodeQueryResult :: Decode QueryResult where
  decode = genericDecode jsonDecodeOptions

newtype Story = Story
  { author :: String
  , created_at :: String
  , objectID :: String
  , num_comments :: Int
  , points :: Int
  , title :: String
  , url :: String }

derive instance genericStory :: Generic Story _
instance showStory :: Show Story where
  show = genericShow
instance decodeStory :: Decode Story where
  decode = genericDecode jsonDecodeOptions

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
  let (decoded :: Either MultipleErrors QueryResult) = runExcept $ decodeJSON result.response
  pure $ (\(QueryResult {hits}) -> hits) <$> decoded
