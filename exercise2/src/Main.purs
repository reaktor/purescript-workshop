module Main where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Array as Array
import Data.Maybe (Maybe(Just, Nothing))
import Data.Tuple (Tuple(..))
import HackerNewsApi (Story, hackerNewsStories)
import Halogen as H
import Halogen.Aff as HA
import Halogen.HTML as HH
import Halogen.HTML.Properties as HP
import Halogen.VDom.Driver (runUI)

type State = { stories :: Array Story }

data Query a = DoNothing a

appComponent :: forall m. Array Story -> H.Component HH.HTML Query Unit Void m
appComponent initialStories = H.component
  { initialState: const initialState
  , render
  , eval
  , receiver: const Nothing
  }
  where

  initialState :: State
  initialState = { stories: initialStories }

  render :: State -> H.ComponentHTML Query
  render {stories} =
    HH.div_
      [ HH.div [HP.class_ (H.ClassName "header")] [HH.text "Hacker Reader"]
      , HH.div [HP.class_ (H.ClassName "content")] [ HH.div_ (map storyItem storiesWithRank) ]]
    where
      storiesWithRank = Array.zip (Array.range 1 (Array.length stories + 1)) stories

  eval :: forall a. Query a -> H.ComponentDSL State Query Void m a
  eval query = case query of
    DoNothing next -> pure next

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
      , HH.div [HP.class_ (H.ClassName "createdAt")] [HH.text story.created_at]]]
      
divider :: forall p i. H.HTML p i
divider = HH.span [HP.class_ (H.ClassName "divider")] [HH.text "|"]

main :: Eff _ Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI (appComponent hackerNewsStories) unit body
