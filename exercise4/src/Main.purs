module Main where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Array as Array
import Data.Maybe (Maybe(Just, Nothing))
import Data.String as Str
import Data.Tuple (Tuple(..))
import HackerNewsApi (Story, hackerNewsStories)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Events as HE
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)

type State =
  { filterText :: String
  , selectedSort :: SortBy
  , stories :: Array Story }

data Query a
  = SetSortBy SortBy a
  | SetFilter String a

data SortBy = ByScore | ByTime

foreign import formatTime :: String -> String

appComponent :: forall m. Array Story -> H.Component HH.HTML Query Unit Void m
appComponent initialStories = H.component
  { initialState: const initialState
  , render
  , eval
  , receiver: const Nothing
  }
  where

  initialState :: State
  initialState =
    { filterText : ""
    , selectedSort: ByScore
    , stories: initialStories }

  render :: State -> H.ComponentHTML Query
  render {filterText, selectedSort, stories} =
    HH.div_
      [ HH.div [HP.class_ (H.ClassName "header")]
          [ HH.text "Hacker Reader"
          , HH.input
              [ HP.value filterText
              , HP.class_ (H.ClassName "filter")
              , HE.onValueInput \e -> Just (SetFilter e unit) ]
          , HH.div [HP.class_ (H.ClassName "sort")]
              [ sortItem selectedSort ByScore "Sort by score"
              , sortItem selectedSort ByTime "Sort by time" ]
          ]
      , HH.div [HP.class_ (H.ClassName "content")] [ HH.div_ (map storyItem sortedStories) ]
      ]
    where
      filteredStories = Array.filter (storyContainsText filterText) stories
      storiesWithRank = Array.zip (Array.range 1 (Array.length stories + 1)) filteredStories
      sortedStories = Array.sortBy (storySort selectedSort) storiesWithRank

  eval :: forall a. Query a -> H.ComponentDSL State Query Void m a
  eval query = case query of
    SetSortBy selectedSort next -> do
      state <- H.get
      H.put (state { selectedSort = selectedSort })
      pure next
    SetFilter filterText next -> do
      state <- H.get
      H.put (state { filterText = filterText })
      pure next

sortItem :: SortBy -> SortBy -> String -> H.ComponentHTML Query
sortItem selectedSort itemSort sortText =
  HH.div
    [ HP.classes sortItemStyles
    , HE.onClick (\_ -> Just $ SetSortBy itemSort unit)]
    [ HH.text sortText ]
  where
    sortItemStyles =
      if isSortSelected selectedSort itemSort
        then [H.ClassName "sortItem", H.ClassName "selected"]
        else [H.ClassName "sortItem"]
      
    isSortSelected :: SortBy -> SortBy -> Boolean
    isSortSelected ByTime ByTime = true
    isSortSelected ByScore ByScore = true
    isSortSelected _ _ = false

storyItem :: forall i. Tuple Int Story -> H.ComponentHTML i
storyItem (Tuple rank story) =
  HH.div [HP.class_ (H.ClassName "storyItem")]
    [ HH.div [HP.class_ (H.ClassName "rank")] [HH.text (show rank <> ".")]
    , HH.a [HP.href story.url] [HH.text story.title]
    , HH.div_
      [ HH.div [HP.class_ (H.ClassName "points")] [HH.text (show story.points <> " points")]
      , divider
      , HH.div [HP.class_ (H.ClassName "author")] [HH.text story.author]
      , divider
      , HH.div [HP.class_ (H.ClassName "numComments")] [HH.text (show story.num_comments <> " comments")]
      , divider
      , HH.div [HP.class_ (H.ClassName "createdAt")] [HH.text (formatTime story.created_at)]]]

storySort :: SortBy -> Tuple Int Story -> Tuple Int Story -> Ordering
storySort ByTime (Tuple _ {created_at: time1}) (Tuple _ {created_at: time2})
  = time2 `compare` time1
storySort ByScore (Tuple _ {points: points1}) (Tuple _ {points: points2})
  = points2 `compare` points1

storyContainsText :: String -> Story -> Boolean
storyContainsText "" _ = true
storyContainsText filterText {title} =
  Str.contains (Str.Pattern filterText) (Str.toLower title)
      
divider :: forall p i. H.HTML p i
divider = HH.span [HP.class_ (H.ClassName "divider")] [HH.text "|"]

main :: Eff _ Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI (appComponent hackerNewsStories) unit body
