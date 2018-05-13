module Test.Exercise2 where

import Prelude

import Control.Monad.Eff (Eff)
import Data.Array as Array
import Data.Maybe (Maybe(..))
import Test.Unit (TestSuite, suite, suiteSkip, test)
import Test.Unit.Assert as Assert
import Test.Unit.Main (run, runTestWith)
import Test.Unit.Output.TAP (runTest)

main :: Eff _ Unit
main = run (runTestWith runTest tests)

tests :: TestSuite _
tests = do
  suite "Ex 2 (ADTs)" do
    suite "1 Printing area" do
      test "of circle" do
        Assert.equal 314.0 (area (Circle (Point {x: 0.0, y: 0.0}) 10.0))
      test "of rectangle" do
        Assert.equal 50.0 (area (Rectangle (Point {x: 0.0, y: 0.0}) 5.0 10.0))
      test "of line" do
        Assert.equal 0.0 (area (Line (Point {x: 0.0, y: 0.0}) (Point {x: 1.0, y: 1.0})))
    test "2 Newtype: get value out of newtype" do
      Assert.equal "1337" (unwrapId (Id "1337"))
    suite "3 Maybe: Find largest number" do
      test "returns largest number" do
        Assert.equal
          (Just 176)
          (largestNumber [3, 7, 5, 176, 12])
      test "doesn't return a value if no numbers are given" do
        Assert.equal
          Nothing
          (largestNumber [])
      
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
unwrapId (Id s) = s

largestNumber :: Array Int -> Maybe Int
largestNumber [] = Nothing
largestNumber nums = Array.head $ Array.reverse $ Array.sort nums
