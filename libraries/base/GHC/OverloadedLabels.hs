{-# LANGUAGE AllowAmbiguousTypes
           , DataKinds
           , FlexibleInstances
           , KindSignatures
           , MultiParamTypeClasses
           , NoImplicitPrelude
           , ScopedTypeVariables
           , TypeApplications
  #-}

-----------------------------------------------------------------------------
-- |
-- Module      :  GHC.OverloadedLabels
-- Copyright   :  (c) Adam Gundry 2015
-- License     :  see libraries/base/LICENSE
--
-- Maintainer  :  cvs-ghc@haskell.org
-- Stability   :  internal
-- Portability :  non-portable (GHC extensions)
--
-- This module defines the `IsLabel` class is used by the
-- OverloadedLabels extension.  See the
-- <https://ghc.haskell.org/trac/ghc/wiki/Records/OverloadedRecordFields/OverloadedLabels wiki page>
-- for more details.
--
-- The key idea is that when GHC sees an occurrence of the new
-- overloaded label syntax @#foo@, it is replaced with
--
-- > fromLabel @"foo" :: alpha
--
-- plus a wanted constraint @IsLabel "foo" alpha@.
--
-----------------------------------------------------------------------------

-- Note [Overloaded labels]
-- ~~~~~~~~~~~~~~~~~~~~~~~~
-- An overloaded label is represented by the 'HsOverLabel' constructor
-- of 'HsExpr', which stores a 'FastString'.  It is passed through
-- unchanged by the renamer, and the type-checker transforms it into a
-- call to 'fromLabel'.  See Note [Type-checking overloaded labels] in
-- TcExpr for more details in how type-checking works.

module GHC.OverloadedLabels
       ( IsLabel(..)
       ) where

import GHC.Base ( Symbol )
import qualified GHC.Records

class IsLabel (x :: Symbol) a where
  fromLabel :: a

instance GHC.Records.HasField x r a => IsLabel x (r -> a) where
  fromLabel = GHC.Records.fromLabel @x
