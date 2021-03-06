{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes#-}
{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}
{-# LANGUAGE RankNTypes #-}

{-# OPTIONS_GHC -Wno-unused-top-binds #-}
module Handler.Manifestation
    (    getManHomeR
        ,getManUserR
        ,getManDetailsR
        ,postManUserR
    ) where

import Import
import Model.Types
import Data.Maybe (fromJust)
import qualified Data.Text as T
import Database.Persist.Sql ( rawSql, Single (unSingle) )
import qualified Data.Char as C
import Data.Text.ICU

{-
    Type for accepting data, entered by the user.
-}
data ManFilter = ManFilter
    {
        filterCity      :: Maybe T.Text
       ,filterSearch    :: Maybe T.Text
    }
    deriving Show


-- Handler functions

{- 
    Get just preview of all manifestations.
-}
getManHomeR :: Handler Html
getManHomeR = do
    ms <- runDB getAllMan

    defaultLayout $ do
        setTitle "Home manifestations"
        $(widgetFile "man-home")

{- 
    User is logged in.
    Show all manifestations with filter options.
-}
getManUserR :: Handler Html
getManUserR = do
    (_, user) <- requireAuthPair
    ms <- runDB getAllMan
    let cats = getAllCat
    cities <- getUniqueCity

    defaultLayout $ do
        setTitle "User manifestations"
        $(widgetFile "man-user")

{- 
    Apply filters and get data from fields.
    Show filtered manifestations in same template "man-user".
-}
postManUserR :: Handler Html
postManUserR = do
    (_, user) <- requireAuthPair
    let toBool = isJust
    let cats = getAllCat
    cities <- getUniqueCity
    emans <- runDB getAllMan
    categories <- flip filterM cats $ \cat -> toBool <$> runInputPost (iopt textField $ toPathPiece $ show cat)
    filters <- runInputPost $ ManFilter
        <$>iopt textField "City"
        <*>iopt textField "Search"
    let f man = do
            city <- getCityFromMan man
            pure $ applyFilters filters (man :: Entity Manifestation) city categories
    ms <- filterM f emans

    defaultLayout $ do
        setTitle "User manifestations"
        $(widgetFile "man-user")

{- 
    Take manifestation id.
    Show details about one manifestation.
    Show comment section.
-}
getManDetailsR :: ManifestationId -> Handler Html
getManDetailsR mid = do
    (ui, user) <- requireAuthPair
    md <- runDB $ get404 mid
    loc <- runDB $ get404 $ manifestationLocation md
    ads <- runDB $ get404 $ locationAddress loc

    cs <- runDB $ getComFromMan mid
    comments <- forM cs getCommentWriter

    defaultLayout $ do
        setTitle "Manifestation details"
        $(widgetFile "man-details")


-- Helper functions

applyFilters :: ManFilter -> Entity Manifestation -> Text -> [Category] -> Bool
applyFilters f man city' cats = do
    and
        [ go name filterSearch
        , go city filterCity
        , goC cat cats
        ]
  where
      go :: (z -> Bool) -> (ManFilter -> Maybe z) -> Bool
      go x y =
        case y f of
            Nothing -> True
            Just z -> x z
      goC :: ([Category] -> Bool) -> [Category] -> Bool
      goC x y =
          case y of
              [] -> True
              (c:_) -> x y
      norm = T.filter validChar . T.map C.toLower . normalize NFKD
      validChar = not . C.isMark
      name x = norm x `T.isInfixOf` norm (manifestationName (entityVal man))
      city x = norm x == norm city'
      cat xs = fromJust(manifestationCategory (entityVal man)) `elem` xs

getComFromMan :: ManifestationId -> DB [Entity ManComment]
getComFromMan manid = selectList [ManCommentManId ==. manid] []

getUniqueCity :: Handler [Text]
getUniqueCity = do
            c <- runDB $ rawSql "SELECT DISTINCT city FROM address" [] :: Handler [Single Text]
            return $ map unSingle c

getAllMan :: DB [Entity Manifestation]
getAllMan = selectList [] [Asc ManifestationName]

getCommentWriter :: Entity ManComment -> Handler (Entity ManComment, Text)
getCommentWriter mc = do
            user <- runDB $ get404 $ fromJust $ manCommentWriter (entityVal mc)
            let username = userIdent user
            return (mc, username)

getAllCat :: [Category]
getAllCat = [(minBound :: Category) ..]

getCityFromMan :: Entity Manifestation -> Handler Text
getCityFromMan man = do
            loc <- runDB $ get404 $ manifestationLocation $ entityVal man
            ads <- runDB $ get404 $ locationAddress loc
            let city = addressCity ads
            return city