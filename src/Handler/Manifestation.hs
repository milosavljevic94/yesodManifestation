{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes#-}
module Handler.Manifestation where

import Import

-- Get all manifestations
getManHomeR :: Handler Html
getManHomeR = do
    ms <- runDB getAllMan
    defaultLayout $ do
        setTitle "ManHomeR handler"
        $(widgetFile "man-home")

-- Helper function
getAllMan :: DB [Entity Manifestation]
getAllMan = selectList [] [Desc ManifestationName]