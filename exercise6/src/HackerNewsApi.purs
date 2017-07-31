module HackerNewsApi where

import Prelude

import Data.Foreign.Class (class Decode)
import Data.Foreign.Generic (defaultOptions, genericDecode)
import Data.Foreign.Generic.Types (Options)
import Data.Generic.Rep (class Generic)
import Data.Generic.Rep.Show (genericShow)

jsonDecodeOptions :: Options
jsonDecodeOptions = defaultOptions { unwrapSingleConstructors = true }

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

hackerNewsStoryIds :: Array Int
hackerNewsStoryIds = [14701199, 4289910, 11174806, 7943303, 12429681, 12571904, 5098981, 7160242, 13577486, 10930298, 11097514, 9503580, 10640478]

hackerNewsStories :: String
hackerNewsStories = """
[
    {
      "created_at": "2014-09-22T19:04:49.000Z",
      "title": "PureScript: a statically typed language which compiles to JavaScript",
      "url": "https://github.com/purescript/purescript",
      "author": "bpierre",
      "points": 175,
      "num_comments": 78,
      "objectID": "8351981"
    },
    {
      "created_at": "2017-02-02T15:58:22.000Z",
      "title": "Introducing PureScript Erlang back end",
      "url": "http://nwolverson.uk/devlog/2016/08/01/introducing-purescript-erlang.html",
      "author": "pka",
      "points": 174,
      "num_comments": 31,
      "objectID": "13551404"
    },
    {
      "created_at": "2015-06-02T06:59:03.000Z",
      "title": "Show HN: A puzzle game inspired by functional programming, written in PureScript",
      "url": "http://david-peter.de/cube-composer",
      "author": "sharkdp",
      "points": 121,
      "num_comments": 49,
      "objectID": "9644324"
    },
    {
      "created_at": "2013-11-01T03:09:13.000Z",
      "title": "PureScript",
      "url": "http://github.com/paf31/purescript",
      "author": "paf31",
      "points": 59,
      "num_comments": 17,
      "objectID": "6651572"
    },
    {
      "created_at": "2015-05-27T10:14:57.000Z",
      "title": "Purescript will make you purr like a kitten",
      "url": "http://blog.sigmapoint.pl/purescript-will-make-you-purr-like-a-kitten/",
      "author": "dstronczak",
      "points": 17,
      "num_comments": 0,
      "objectID": "9610375"
    },
    {
      "created_at": "2015-04-07T17:49:15.000Z",
      "title": "purescript-halogen – A declarative, type-safe UI library for PureScript",
      "url": "https://github.com/slamdata/purescript-halogen",
      "author": "purescript",
      "points": 13,
      "num_comments": 0,
      "objectID": "9335761"
    }
]
"""
