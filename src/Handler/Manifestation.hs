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
import Data.List (nub)
import qualified Data.Text as T
import Database.Persist.Sql (rawSql)

data ManFilter = ManFilter
    {
        filterCat       :: Maybe [Category],
        filterCity      :: Maybe T.Text,
        filterSearch    :: Maybe T.Text
    }
    deriving Show

-- Get all manifestations
getManHomeR :: Handler Html
getManHomeR = do
    ms <- runDB getAllMan
    defaultLayout $ do
        setTitle "Home manifestations"
        $(widgetFile "man-home")

--Get all maifestation logged user and filters
getManUserR :: Handler Html
getManUserR = do
    (_, user) <- requireAuthPair
    ms <- runDB getAllMan
    let cats = getAllCat
    --cities <- runDB getUniqueCity
    cities <- nub <$> runDB (selectList [] [Desc AddressCity])
    liftIO $ print cities
    defaultLayout $ do
        setTitle "User manifestations"
        $(widgetFile "man-user")



{- filterForm :: Form Filter
filterForm = renderDivs Filter
    <$> aopt (selectField optionsEnum) "Category" ()
    <*> areq (jqueryDayField def
        { jdsChangeYear = True -- give a year dropdown
        , jdsYearRange = "1900:-5" -- 1900 till five years ago
        }) "Birthday" Nothing
    <*> aopt textField "Favorite color" Nothing
    <*> areq emailField "Email address" Nothing
    <*> aopt urlField "Website" Nothing -}

-- dugme submit dovodi do ove funkcije. U ovoj funkciji bi se onda izvrsilo filtriranje i prikazale
-- bi se manifestacije koje su filtrirane!

postManUserR :: Handler Html
postManUserR = do
    (_, user) <- requireAuthPair
    --let toBool = maybe False (const True)
    filters <- runInputPost $ ManFilter
        <$>iopt (checkboxesFieldList cats) "Cat"
        <*>iopt (selectField cities) "City"
        <*>iopt textField "Search"
    defaultLayout [whamlet|<h1>#{show $ filters}|]
 where
  cats::[(Text, Category)]
  cats = [("Sport", Sport), ("Concert", Concert ), ("Theater", Theater)]
  cities = do
        items <- runDB $ rawSql "SELECT DISTINC city from address" []
        --items <- runDB $ rawSql "SELECT city FROM address GROUP BY city" []
       --items <- runDB $ selectList [] [Desc AddressCity]
        optionsPairs $ map (\c -> (addressCity $ entityVal c, addressCity $ entityVal c)) items

getManDetailsR :: ManifestationId -> Handler Html
getManDetailsR mid = do
    (_, user) <- requireAuthPair
    md <- runDB $ get404 mid
    loc <- runDB $ get404 $ fromJust(manifestationLocation md)
    ads <- runDB $ get404 $ fromJust(locationAddress loc)
    defaultLayout $ do
        setTitle "Manifestation details"
        $(widgetFile "man-details")

-- Helper functions
getAllMan :: DB [Entity Manifestation]
getAllMan = selectList [] [Desc ManifestationName]

getAllAddress :: DB [Entity Address]
getAllAddress = selectList [] [Desc AddressCity]

getUniqueCity :: DB [Entity Address]
getUniqueCity = rawSql "SELECT DISTINCT city FROM address" [] --rawSql "SELECT city FROM address GROUP BY city" []

getAllCat :: [Category]
getAllCat = [(minBound :: Category) ..]

dateFormat :: UTCTime -> String
dateFormat = formatTime defaultTimeLocale "%Y-%m-%d %H:%M:%S"

{- applyFilter :: ManFilter -> Manifestation  -> Bool
applyFilter f m = and
    [ go cat filterCat
    , go city filterCity
    , go name filterSearch
    ]
  where
    go :: (z -> Bool) -> (ManFilter -> Maybe z) -> Bool
    go x y =
        case y f of
            Nothing -> True
            Just z -> x z
    norm = T.filter validChar . T.map toLower . normalize NFKD
    validChar = not . isMark
    cat x = norm x `T.isInfixOf` norm (manifestationCategory m)
    city x = norm x `T.isInfixOf` norm (addressCity $ locationAddress $ manifestationLocation m)
    name x = norm x `T.isInfixOf` norm (manifestationName m) -}