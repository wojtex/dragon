module Interpretter.Ptrn where

import Interpretter.Core

import Control.Monad

import qualified Ast as A
import qualified Data.Map as M

patternMatchValue :: Monad m => A.Ptrn -> Value r m -> IPM r m (M.Map String (Value r m))
patternMatchValue (A.PNamed s) v = return $ M.singleton s v
patternMatchValue (A.PVoid) v = return M.empty
patternMatchValue (A.PDereference p) (VPointer l) =
  patternMatchValue p $ VLReference l

patternsMatchValues :: Monad m => [A.Ptrn] -> [Value r m] -> IPM r m (M.Map String (Value r m))
patternsMatchValues ps vs = do
  foldM (\a (p,v) -> do { d <- patternMatchValue p v; return $ d `M.union` a})
    M.empty (zip ps vs)
