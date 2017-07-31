module Main where

import Prelude hiding (div)

import CSS (CSS, backgroundColor, display, fontSize, inline, margin, marginBottom, marginLeft, marginRight, padding, paddingTop, px, rgb)
import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Control.Monad.Eff.Console (CONSOLE)
import Control.Monad.Eff.Exception (EXCEPTION)
import Data.Array (length, zip, (..))
import Data.Foldable (for_)
import Data.Maybe (Maybe(Just, Nothing))
import Data.Tuple (Tuple(Tuple))
import Pux (EffModel, start)
import Pux.DOM.HTML (HTML)
import Pux.DOM.HTML.Attributes (style)
import Pux.Renderer.React (renderToDOM)
import Signal (constant)
import Signal.Channel (CHANNEL)
import Text.Smolder.HTML (a, div, h1, span)
import Text.Smolder.HTML.Attributes (href)
import Text.Smolder.Markup (text, (!))

import HackerNewsApi (Story, hackerNewsStories)

data Event
  = LoadFrontPage
  | SetStories (Array Story)

type State = { stories :: Array Story }

initialState :: State
initialState = { stories: [] }

foldp :: forall eff. Event -> State -> EffModel State Event (console :: CONSOLE | eff)
foldp event@(LoadFrontPage) state = 
  { state
  , effects: [loadHackerNewsStories] }
foldp event@(SetStories stories) state =
  { state: state { stories = stories }
  , effects: [] }

loadHackerNewsStories :: forall e. Aff (console :: CONSOLE | e) (Maybe Event)
loadHackerNewsStories = do
  pure $ Just (SetStories hackerNewsStories)

view :: State -> HTML Event
view {stories} =
  div do
    h1 ! style headerStyle $ do
      text "Hacker Reader"
    div ! style contentStyle $ do
      div $ for_ storiesWithRank storyItem
  where
    headerStyle :: CSS
    headerStyle = do
      backgroundColor (rgb 255 102 0)
      margin (px 0.0) (px 0.0) (px 0.0) (px 0.0)
      padding (px 10.0) (px 10.0) (px 10.0) (px 10.0)
      
    contentStyle :: CSS
    contentStyle = do
      padding (px 10.0) (px 10.0) (px 10.0) (px 10.0)
      
    storiesWithRank = zip (1 .. (length stories + 1)) stories

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
