module Main where

import Prelude hiding (div)

import CSS (CSS, backgroundColor, display, fontSize, inline, margin, marginBottom, marginLeft, marginRight, padding, paddingTop, px, rgb, white, width)
import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Array (filter, length, sortBy, zip, (..))
import Data.Foldable (for_)
import Data.Maybe (Maybe(Just, Nothing))
import Data.String (Pattern(Pattern), contains, toLower)
import Data.Tuple (Tuple(Tuple))
import Pux (EffModel, start)
import Pux.DOM.Events (onClick, onInput, targetValue)
import Pux.DOM.HTML (HTML)
import Pux.DOM.HTML.Attributes (style)
import Pux.Renderer.React (renderToDOM)
import Signal (constant)
import Signal.Channel (CHANNEL)
import Text.Smolder.HTML (a, div, h1, input, span)
import Text.Smolder.HTML.Attributes (href, value)
import Text.Smolder.Markup (text, (!), (#!))

import HackerNewsApi (Story, hackerNewsStories)

data Event
  = LoadFrontPage
  | SetStories (Array Story)
  | SetSortBy SortBy
  | SetFilter String

data SortBy = ByScore | ByTime

type State = 
  { filterText :: String
  , selectedSort :: SortBy
  , stories :: Array Story }

initialState :: State
initialState = 
  { filterText: ""
  , selectedSort: ByScore
  , stories: [] }

foldp :: forall eff. Event -> State -> EffModel State Event (console :: CONSOLE | eff)
foldp event@(LoadFrontPage) state = 
  { state
  , effects: [loadHackerNewsStories] }
foldp event@(SetStories stories) state =
  { state: state { stories = stories }
  , effects: [] }
foldp event@(SetSortBy newSort) state =
  { state: state { selectedSort = newSort }
  , effects: [] }
foldp event@(SetFilter filterText) state =
  { state: state { filterText = filterText }
  , effects: [] }

loadHackerNewsStories :: forall e. Aff (console :: CONSOLE | e) (Maybe Event)
loadHackerNewsStories = do
  pure $ Just (SetStories hackerNewsStories)

view :: State -> HTML Event
view {filterText, selectedSort, stories} =
  div do
    h1 ! style headerStyle $ do
      text "Hacker Reader"
      storyFilterInput filterText
      sortButtons selectedSort
    div ! style contentStyle $ do
      div $ for_ sortedStories storyItem
  where
    headerStyle :: CSS
    headerStyle = do
      backgroundColor (rgb 255 102 0)
      margin (px 0.0) (px 0.0) (px 0.0) (px 0.0)
      padding (px 10.0) (px 10.0) (px 10.0) (px 10.0)
      
    contentStyle :: CSS
    contentStyle = do
      padding (px 10.0) (px 10.0) (px 10.0) (px 10.0)
      
    filteredStories = filter (storyContainsText filterText) stories
    storiesWithRank = zip (1 .. (length stories + 1)) filteredStories
    sortedStories = sortBy (storySort selectedSort) storiesWithRank

storyContainsText :: String -> Story -> Boolean
storyContainsText "" _ = true
storyContainsText filterText {title} = contains (Pattern filterText) (toLower title)

storyFilterInput :: String -> HTML Event
storyFilterInput filterText = input
  ! value filterText
  ! style filterStyle
  #! onInput \e -> SetFilter $ targetValue e
  where
    filterStyle = do
      marginLeft (px 20.0)
      width (px 200.0)
      fontSize (px 18.0)

sortButtons :: SortBy -> HTML Event
sortButtons sortBy =
  div ! style sortStyle $ do
    sortItem sortBy ByScore "Sort by score"
    sortItem sortBy ByTime "Sort by date"
  where
    sortStyle = do
      display inline
      fontSize (px 18.0)
      marginLeft (px 10.0)

sortItem :: SortBy -> SortBy -> String -> HTML Event
sortItem selectedSort itemSort sortText =
  div
    ! style sortItemStyle
    #! onClick (\_ -> SetSortBy itemSort)
    $ text sortText
  where
    sortItemStyle = if isSortSelected selectedSort itemSort
                      then selectedStyle
                      else unselectedStyle
                           
    selectedStyle = do
      display inline
      fontSize (px 18.0)
      marginLeft (px 10.0)
      padding (px 4.0) (px 4.0) (px 4.0) (px 4.0)
      backgroundColor white
      
    unselectedStyle = do
      display inline
      fontSize (px 18.0)
      marginLeft (px 10.0)
      
isSortSelected :: SortBy -> SortBy -> Boolean
isSortSelected ByTime ByTime = true
isSortSelected ByScore ByScore = true
isSortSelected _ _ = false

storySort :: SortBy -> Tuple Int Story -> Tuple Int Story -> Ordering
storySort ByTime (Tuple _ {created_at: time1}) (Tuple _ {created_at: time2}) = time2 `compare` time1
storySort ByScore (Tuple _ {points: points1}) (Tuple _ {points: points2}) = points2 `compare` points1

storyItem :: Tuple Int Story -> HTML Event
storyItem (Tuple rank story) =
  div ! style (marginBottom (px 5.0)) $ do
    div ! style rankStyle $ text (show rank <> ".")
    a ! href story.url $ text story.title
    div do
      div ! style pointsStyle $ text (show story.points <> " points")
      divider
      div ! style authorStyle $ text story.author
      divider
      div ! style numCommentsStyle $ text (show story.num_comments <> " comments")
      divider
      div ! style numCommentsStyle $ text (story.created_at)

rankStyle :: CSS
rankStyle = do
  display inline
  marginRight (px 4.0)

divider :: HTML Event
divider = span ! style dividerStyle $ text "|"

dividerStyle :: CSS
dividerStyle = do
  marginLeft (px 4.0)
  marginRight (px 4.0)
  
pointsStyle :: CSS
pointsStyle = do
  fontSize (px 12.0)
  paddingTop (px 2.0)
  display inline
  
authorStyle :: CSS
authorStyle = do
  fontSize (px 12.0)
  paddingTop (px 2.0)
  display inline
  
numCommentsStyle :: CSS
numCommentsStyle = do
  marginRight (px 5.0)
  fontSize (px 12.0)
  paddingTop (px 2.0)
  display inline
  
main :: forall eff. Eff (channel :: CHANNEL, console :: CONSOLE, exception :: EXCEPTION | eff) Unit
main = do
  app <- start
    { initialState
    , view
    , foldp
    , inputs: [constant LoadFrontPage]
    }
  renderToDOM "#app" app.markup app.input
