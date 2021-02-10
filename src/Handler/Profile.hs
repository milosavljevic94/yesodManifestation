{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# OPTIONS_GHC -Wno-unused-imports #-}
module Handler.Profile where

import Import
import Data.Time

getProfileR :: Handler Html
getProfileR = do
    (_, user) <- requireAuthPair
    time <- liftIO getCurrentTime
    let now = dateFormat time
    defaultLayout $ do
        setTitle . toHtml $ userIdent user <> "'s User page"
        $(widgetFile "profile")

dateFormat :: UTCTime -> [Char]
dateFormat = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S"