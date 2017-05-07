module Interpretter.Ptrn where

import Interpretter.Core

import Control.Monad

import qualified Ast as A
import qualified Data.Map as M

patternMatchValue :: A.Ptrn -> Value r -> IPM r (M.Map String (Value r))
patternMatchValue (A.PNamed s) v = return $ M.singleton s v
patternMatchValue (A.PVoid) v = return M.empty

patternsMatchValues :: [A.Ptrn] -> [Value r] -> IPM r (M.Map String (Value r))
patternsMatchValues ps vs = do
  foldM (\a (p,v) -> do { d <- patternMatchValue p v; return $ d `M.union` a})
    M.empty (zip ps vs)
