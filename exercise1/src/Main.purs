module Main where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Maybe (Maybe(Just,Nothing))
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
      , HH.div [HP.class_ (H.ClassName "content")] [ HH.div_ (map storyItem stories) ]]

  eval :: forall a. Query a -> H.ComponentDSL State Query Void m a
  eval query = case query of
    DoNothing next -> pure next

storyItem :: forall i. Story -> H.ComponentHTML i
storyItem story =
  HH.div [HP.class_ (H.ClassName "storyItem")]
    [ HH.text story.objectID ]

main :: Eff _ Unit
main = HA.runHalogenAff do
  body <- HA.awaitBody
  runUI (appComponent hackerNewsStories) unit body
