module Main where

import Prelude hiding (div)

import CSS (CSS, backgroundColor, display, fontSize, inline, margin, marginBottom, marginLeft, marginRight, padding, paddingTop, px, rgb, white, width)
import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Class (liftEff)
import Control.Monad.Eff.Console (CONSOLE, log)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Array (filter, length, sortBy, zip, (..))
import Data.Either (Either(..))
import Data.Foldable (for_)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)
import Data.Maybe (Maybe(Just, Nothing))
import Data.String (Pattern(Pattern), contains, toLower)
import Data.Tuple (Tuple(Tuple))
import Network.HTTP.Affjax (AJAX)
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

import HackerNewsApi (Story(Story), fetchHackerNewsStories)

foreign import formatTime :: String -> String

data Event
  = LoadFrontPage
  | SetStories (Array Story)
  | SetSortBy SortBy
  | SetFilter String

derive instance genericEvent :: Generic Event _
instance showEvent :: Show Event where
  show = genericShow

data SortBy = ByScore | ByTime

derive instance genericSortBy :: Generic SortBy _
instance showSortBy :: Show SortBy where
  show = genericShow

newtype State = State
  { filterText :: String
  , selectedSort :: SortBy
  , stories :: Array Story }

derive instance genericState :: Generic State _
instance showState :: Show State where
  show = genericShow

initialState :: State
initialState = State
  { filterText: ""
  , selectedSort: ByScore
  , stories: [] }

foldp :: forall eff. Event -> State -> EffModel State Event (ajax :: AJAX, console :: CONSOLE | eff)
foldp event@(LoadFrontPage) state = 
  { state
  , effects: [
    do
      _ <- logEvent event state
      loadHackerNewsStories] }
foldp event@(SetStories stories) (State state) =
  { state: State $ state { stories = stories }
  , effects: [logEvent event (State state)] }
foldp event@(SetSortBy newSort) (State state) =
  { state: State $ state { selectedSort = newSort }
  , effects: [logEvent event (State state)] }
foldp event@(SetFilter filterText) (State state) =
  { state: State $ state { filterText = filterText }
  , effects: [logEvent event (State state)] }

loadHackerNewsStories :: forall e. Aff (ajax :: AJAX, console :: CONSOLE | e) (Maybe Event)
loadHackerNewsStories = do
  storiesResult <- fetchHackerNewsStories
  case storiesResult of
    Left errors -> do
      liftEff (log $ "Error decoding JSON: " <> show errors)
      pure Nothing
    Right stories -> pure $ Just (SetStories stories)

logEvent :: forall e. Event -> State -> Aff (console :: CONSOLE | e) (Maybe Event)
logEvent event state = do
  liftEff $ log (show event)
  liftEff $ log (show state)
  pure Nothing

view :: State -> HTML Event
view (State {filterText, selectedSort, stories}) =
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
storyContainsText filterText (Story {title}) = contains (Pattern filterText) (toLower title)

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
    sortItem sortBy ByTime "Sort by time"
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
storySort ByTime (Tuple _ (Story {created_at: time1})) (Tuple _ (Story {created_at: time2})) = time2 `compare` time1
storySort ByScore (Tuple _ (Story {points: points1})) (Tuple _ (Story {points: points2})) = points2 `compare` points1

storyItem :: Tuple Int Story -> HTML Event
storyItem (Tuple rank (Story story)) =
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
      div ! style numCommentsStyle $ text (formatTime story.created_at)

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
  
main :: forall eff. Eff (ajax :: AJAX, channel :: CHANNEL, console :: CONSOLE, exception :: EXCEPTION | eff) Unit
main = do
  app <- start
    { initialState
    , view
    , foldp
    , inputs: [constant LoadFrontPage]
    }
  renderToDOM "#app" app.markup app.input
