{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes#-}
{-# OPTIONS_GHC -Wno-unused-matches #-}
{-# OPTIONS_GHC -Wno-name-shadowing #-}

module Handler.Manifestation where

import Import
import Model.Types
import Data.Maybe (fromJust)
import qualified Data.Text as T
import Database.Persist.Sql ( rawSql, Single (unSingle) )
import qualified Data.Char as C
import Data.Text.ICU

data ManFilter = ManFilter
    {                                           -- filterCat :: [Category] -- getting categories out of this data
        filterCity      :: Maybe T.Text,
        filterSearch    :: Maybe T.Text
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
    categories <- flip filterM getAllCat $ \cid -> toBool <$> runInputPost (iopt textField $ toPathPiece $ show cid)
    filters <- runInputPost $ ManFilter
        <$>iopt textField "City"
        <*>iopt textField "Search"
    ms <- filterM (applyFilters filters) emans
    
    defaultLayout $ do
        setTitle "User manifestations"
        $(widgetFile "man-user")

{- 
    Take manifestation id.
    Show details about one manifestation.
-}
getManDetailsR :: ManifestationId -> Handler Html
getManDetailsR mid = do
    (_, user) <- requireAuthPair
    md <- runDB $ get404 mid
    loc <- runDB $ get404 $ manifestationLocation md
    ads <- runDB $ get404 $ locationAddress loc

    defaultLayout $ do
        setTitle "Manifestation details"
        $(widgetFile "man-details")


-- Helper functions

{- filterManifestations :: [Category] -> Maybe T.Text -> Maybe T.Text -> Handler [Entity Manifestation]
filterManifestations cat city src = do
    let city' = fromMaybe city
        src' = fromMaybe src
    runDB $ selectList [ManifestationName <-. cat] [] -}

applyFilters :: ManFilter -> Entity Manifestation -> Handler Bool
applyFilters f man = do
    city' <- getCityFromMan $ entityVal man
    let city x = norm x == norm city'
    pure $ and
        [ go name filterSearch
        , go city filterCity
        ]
  where
      go :: (z -> Bool) -> (ManFilter -> Maybe z) -> Bool
      go x y =
        case y f of
            Nothing -> True
            Just z -> x z
      norm = T.filter validChar . T.map C.toLower . normalize NFKD
      validChar = not . C.isMark
      name x = norm x `T.isInfixOf` norm (manifestationName (entityVal man))

getAllMan :: DB [Entity Manifestation]
getAllMan = selectList [] [Desc ManifestationName]

getAllAddress :: DB [Entity Address]
getAllAddress = selectList [] [Desc AddressCity]

getAllCat :: [Category]
getAllCat = [(minBound :: Category) ..]

getCityFromMan :: Manifestation -> Handler Text
getCityFromMan man = do
            loc <- runDB $ get404 $ manifestationLocation man
            ads <- runDB $ get404 $ locationAddress loc
            let city = addressCity ads
            return city

getUniqueCity :: Handler [Text]
getUniqueCity = do
            c <- runDB $ rawSql "SELECT DISTINCT city FROM address" [] :: Handler [Single Text]
            return $ map unSingle c

dateFormat :: UTCTime -> String
dateFormat = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S"