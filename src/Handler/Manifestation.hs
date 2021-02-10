{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes#-}
module Handler.Manifestation where

import Import
import Model.Types

-- Get all manifestations
getManHomeR :: Handler Html
getManHomeR = do
    ms <- runDB getAllMan
    defaultLayout $ do
        setTitle "Home manifestations"
        $(widgetFile "man-home")

--Get all maifestation logged user
getManUserR :: Handler Html
getManUserR = do
    (_, user) <- requireAuthPair
    ms <- runDB getAllMan
    let cats = getAllCat
    print $ show cats
    defaultLayout $ do
        setTitle "User manifestations"
        $(widgetFile "man-user")

--Get manifestation details
getManDetailsR :: Handler Html
getManDetailsR = defaultLayout $ do
    setTitle "Manifestation details"
    $(widgetFile "man-details")

-- Helper function
getAllMan :: DB [Entity Manifestation]
getAllMan = selectList [] [Desc ManifestationName]

getAllCat :: [Category]
getAllCat = [(minBound :: Category) ..]

dateFormat :: UTCTime -> String
dateFormat = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S"