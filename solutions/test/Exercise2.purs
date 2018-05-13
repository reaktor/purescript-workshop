module Test.Exercise2 where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Array as Array
import Data.Foldable (all)
import Data.Record (class EqualFields)
import Data.Record as Record
import Data.Tuple (Tuple(Tuple))
import HackerNewsApi (Story, hackerNewsStories)
import Test.Unit (TestSuite, suite, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (runTest)
import Type.Row (class RowToList)

main :: Eff _ Unit
main = runTest $ do
  suite "ADTs" do
    test "print the area of the circle" do
      Assert.equal 314.0 (area (Circle (Point {x: 0.0, y: 0.0}) 10.0))
      
  --   test "print the area of the rectangle" do
  --     Assert.equal 50.0 (area (Rectangle (Point {x: 0.0, y: 0.0}) 5.0 10.0))
      
  --   test "print the area of the line" do
  --     Assert.equal 0.0 (area (Line (Point {x: 0.0, y: 0.0}) (Point {x: 1.0, y: 1.0})))
      
  -- suite "newtype" do
  --   test "get a value out of a newtype" do
  --     Assert.equal "1337" (unwrapId (Id "1337"))
      
data Shape
  = Circle Point Radius
  | Rectangle Point Width Height
  | Line Point Point
    
data Point = Point
  { x :: Number
  , y :: Number
  }
    
type Radius = Number
type Width = Number
type Height = Number

pi :: Number
pi = 3.14
      
area :: Shape -> Number
area (Circle _ r) = pi * r * r
area (Rectangle _ w h) = w * h
area (Line _ _) = 0.0

newtype Id = Id String

unwrapId :: Id -> String
unwrapId _ = ""
