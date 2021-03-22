{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes#-}
{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}
{-# LANGUAGE RankNTypes #-}

module Handler.ManComment where

import Import
{- import Model.Types
import Data.Maybe (fromJust)
import qualified Data.Text as T
import qualified Data.Char as C -}

postManCommentR :: ManifestationId -> Handler()
postManCommentR mid = do
    setMessage "Comment succesfully added"
    redirect $ ManDetailsR mid

postDeleteManCommentR :: ManifestationId -> ManCommentId -> Handler ()
postDeleteManCommentR mid cid = do
    setMessage "Comment succesfully deleted"
    redirect $ ManDetailsR mid