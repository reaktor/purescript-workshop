module Test.Helpers where

import Prelude

import Control.Monad.Aff (catchError, error, throwError)
import Control.Monad.Eff.Exception as Error
import Data.Array as Array
import Data.Foldable (all)
import Data.Record (class EqualFields)
import Data.Record as Record
import Data.Traversable (sequence)
import Data.Tuple (Tuple(..))
import Simple.JSON as SimpleJSON
import Test.Unit (Test, failure, success)
import Type.Row (class RowToList)

eqRecordArrays :: forall r rs
                  . RowToList r rs
                  => EqualFields rs r
                  => Array { | r } -> Array { | r } -> Boolean
eqRecordArrays arr1 arr2 | Array.length arr1 /= Array.length arr2 = false
eqRecordArrays arr1 arr2 = all (\(Tuple r1 r2) -> Record.equal r1 r2) $ Array.zip arr1 arr2

assertRecordArrayEqual :: forall r rs e
                  . RowToList r rs
                  => EqualFields rs r
                  => SimpleJSON.WriteForeign (Record r)
                  => Array (Record r) -> Array (Record r) -> Test e
assertRecordArrayEqual expected actual | Array.length expected /= Array.length actual =
  failure $ "Expected array with length " <> show (Array.length expected) <> ", but received array with length " <> show (Array.length actual)
assertRecordArrayEqual expected actual =
  let
    zippedArrays = Array.zip expected actual
    comparisons = map (\(Tuple r1 r2) -> assertRecordEqual r1 r2) zippedArrays
    formatAndThrow e = throwError (error $ "Record arrays contain unequal value:\n" <> Error.message e)
  in
   catchError (sequence comparisons) formatAndThrow *> pure unit

assertRecordEqual :: forall r rs e
               . RowToList r rs
               => SimpleJSON.WriteForeign (Record r)
               => EqualFields rs r
               => Record r -> Record r -> Test e
assertRecordEqual expected actual | Record.equal expected actual = success
assertRecordEqual expected actual = failure $
  "\n  Expected: " <> SimpleJSON.writeJSON expected <>
  "\n  Received: " <> SimpleJSON.writeJSON actual
