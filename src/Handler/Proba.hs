{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes#-}
module Handler.Proba where

import Import


{- 
getProbaR :: Text -> Handler Html
getProbaR name = do
    defaultLayout $ do
        setTitle "Probaaa"
        [whamlet|<p>Hello this is Probaa by #{name}!!!|]  
-}

{- 
getProbaR :: Text -> Handler Value
getProbaR name = pure $ object ["name" .= name] 
-}


getProbaR :: Text -> Handler TypedContent   -- visestruka reprezentacija, Json i Html.
getProbaR name = selectRep $ do
    provideRep $ pure $ object ["name" .= name]
    provideRep $ defaultLayout $ do
        setTitle "Probaaa"
        [whamlet|<p>Hello this is Probaa by #{name}!!!|]

getPrikazR :: Handler Html  
getPrikazR = do
    sveLokacije <- runDB getAllLocations
    putStrLn "Ispis svih lokacija: "
    print sveLokacije
    sveAdrese <- runDB getAllAddress
    sveManifestacije <- runDB getAllMan
    defaultLayout $ do
        setTitle "Prikaz iz baze"
        [whamlet|
            <h4>This is all locations from database:
                <div>
                    <ul>
                        $forall Entity id l <- sveLokacije
                            <li>#{toPathPiece id}
                            <li>#{locationName l}
            <h4>This is all address from database:
                <div>
                    <ul>
                        $forall Entity id a <- sveAdrese
                            <li>#{toPathPiece id}
                            <li>#{show $ a}
            <h4>This is all Manifestations from database:
                <div>
                    <ul>
                        $forall Entity id m <- sveManifestacije
                            <li>#{toPathPiece id}
                            <li>#{show $ m}
                            
        |]

getAllLocations :: DB [Entity Location]
getAllLocations = selectList [][]

getAllAddress :: DB [Entity Address]
getAllAddress = selectList [] []

getAllMan :: DB [Entity Manifestation]
getAllMan = selectList [] []