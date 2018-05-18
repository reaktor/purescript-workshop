module HackerReader.Main where

import Prelude hiding (div)

import CSS (marginBottom, px)
import Control.Monad.Aff (Aff)
import Control.Monad.Aff.Console (log)
import Control.Monad.Eff (Eff)
import Data.Array as Array
import Data.Either (Either(Left,Right))
import Data.Foldable (for_)
import Data.Maybe (Maybe(Just, Nothing))
import Data.String as Str
import HackerReader.HackerNewsApi (Story, fetchHackerNewsStories)
import HackerReader.Styles as Styles
import Pux as Pux
import Pux.DOM.Events (onClick, onInput, targetValue)
import Pux.DOM.HTML (HTML)
import Pux.DOM.HTML.Attributes (key, style)
import Pux.Renderer.React (renderToDOM)
import Signal (constant)
import Text.Smolder.HTML (a, div, h1, input, span)
import Text.Smolder.HTML.Attributes (href, value)
import Text.Smolder.Markup (text, (!), (#!))

data Event
  = LoadFrontPage
  | SetStories (Array Story)
  | SetSortBy SortBy

data SortBy = ByScore | ByTime

type State =
  { selectedSort :: SortBy
  , stories :: Array Story }

foreign import formatTime :: String -> String

initialState :: State
initialState =
  { selectedSort: ByScore
  , stories: [] }

foldp :: Event -> State -> { state :: State, effects :: Array (Aff _ (Maybe Event)) }
foldp (LoadFrontPage) state = { state, effects: [loadHackerNewsStories] }
foldp (SetStories stories) state = { state: newState, effects: [] }
  where newState = state { stories = stories }
foldp (SetSortBy newSort) state = { state: newState, effects: [] }
  where newState = state { selectedSort = newSort }

loadHackerNewsStories :: Aff _ (Maybe Event)
loadHackerNewsStories = do
  storiesResult <- fetchHackerNewsStories
  case storiesResult of
    Left errors -> do
      log $ "Error decoding JSON: " <> show errors
      pure Nothing
    Right stories -> pure $ Just (SetStories stories)

view :: State -> HTML Event
view {selectedSort, stories} = do
  div ! style Styles.header $ do
    h1
      ! style Styles.headerTitle
      $ text "Hacker Reader"
    div ! style Styles.sort $ do
      div ! style (sortItemStyle ByScore)
        #! onClick (\_ -> SetSortBy ByScore)
        $ text "Sort by score"
      div ! style (sortItemStyle ByTime)
        #! onClick (\_ -> SetSortBy ByTime)
        $ text "Sort by date"
  div ! style Styles.content $ do
    for_ sortedStories storyItem
  where
    sortedStories = Array.sortBy (storySort selectedSort) stories
    sortItemStyle sort =
      if isSortSelected selectedSort sort
         then Styles.selected
         else Styles.unselected
      
isSortSelected :: SortBy -> SortBy -> Boolean
isSortSelected ByTime ByTime = true
isSortSelected ByScore ByScore = true
isSortSelected _ _ = false

storySort :: SortBy -> Story -> Story -> Ordering
storySort ByTime {created_at: time1} {created_at: time2} = time2 `compare` time1
storySort ByScore {points: points1} {points: points2} = points2 `compare` points1

storyItem :: Story -> HTML Event
storyItem story =
  div ! style (marginBottom (px 5.0)) ! key story.objectID $ do
    a ! href story.url $ text story.title
    div do
      div ! style Styles.points $ text (show story.points <> " points")
      divider
      div ! style Styles.author $ text story.author
      divider
      div ! style Styles.numComments $ text (show story.num_comments <> " comments")
      divider
      div ! style Styles.date $ text (formatTime story.created_at)

divider :: HTML Event
divider = span ! style Styles.divider $ text "|"
  
main :: Eff _ Unit
main = do
  app <- Pux.start
    { initialState
    , view
    , foldp
    , inputs: [constant LoadFrontPage]
    }
  renderToDOM "#app" app.markup app.input
