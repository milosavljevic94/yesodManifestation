{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}
{-# LANGUAGE RankNTypes #-}
{-# OPTIONS_GHC -Wno-unused-do-bind #-}

module Handler.ManComment where

import Import


{- 
    Handler for adding a new comment.
-}
postManCommentR :: ManifestationId -> Handler()
postManCommentR mid = do
    (uid, user) <- requireAuthPair
    maybeText <- runInputPost (iopt textField "Comment")
    case maybeText of
        Just text -> do
            now <- liftIO getCurrentTime
            comId <- runDB $ insert $ ManComment text now (Just uid) mid
            setMessage "Comment succesfully added"
            redirect $ ManDetailsR mid
        Nothing -> do
            setMessage "Error while adding comment"
            return ()


{- 
    Handler for removing comment.
-}
postDeleteManCommentR :: ManifestationId -> ManCommentId -> Handler ()
postDeleteManCommentR mid cid = do
    (uid, user) <- requireAuthPair
    comm <- runDB $ get404 cid
    unless (Just uid == manCommentWriter comm) notFound
    runDB $ delete cid
    setMessage "Comment succesfully deleted"
    redirect $ ManDetailsR mid