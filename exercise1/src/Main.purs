module Main where

import Prelude hiding (div)

import CSS (CSS, backgroundColor, margin, marginBottom, padding, px, rgb)
import Control.Monad.Aff (Aff)
import Control.Monad.Eff (Eff)
import Data.Array (length, zip, (..))
import Data.Foldable (for_)
import Data.Maybe (Maybe(Just, Nothing))
import Pux (EffModel, start)
import Pux.DOM.HTML (HTML)
import Pux.DOM.HTML.Attributes (style)
import Pux.Renderer.React (renderToDOM)
import Signal (constant)
import Signal.Channel (CHANNEL)
import Text.Smolder.HTML (div, h1)
import Text.Smolder.Markup (text, (!))

import HackerNewsApi (Story, hackerNewsStories)

data Event
  = LoadFrontPage
  | SetStories (Array Story)

type State = { stories :: Array Story }

initialState :: State
initialState = { stories: [] }

foldp :: Event -> State -> EffModel State Event _
foldp LoadFrontPage state = 
  { state
  , effects: [loadHackerNewsStories] }
foldp (SetStories stories) state =
  { state: state { stories = stories }
  , effects: [] }

loadHackerNewsStories :: forall e. Aff _ (Maybe Event)
loadHackerNewsStories = do
  pure $ Just (SetStories hackerNewsStories)

view :: State -> HTML Event
view {stories} =
  div do
    h1 ! style headerStyle $ do
      text "Hacker Reader"
    div ! style contentStyle $ do
      div $ for_ stories storyItem
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

storyItem :: Story -> HTML Event
storyItem story =
  div ! style (marginBottom (px 5.0)) $ do
    div $ text story.objectID
  
main :: Eff _ Unit
main = do
  app <- start
    { initialState
    , view
    , foldp
    , inputs: [constant LoadFrontPage]
    }
  renderToDOM "#app" app.markup app.input
