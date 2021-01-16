{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes#-}
module Handler.Proba where

import Import

getProbaR :: Handler Html
getProbaR = do
    defaultLayout $ do
        setTitle "Probaaa"
        [whamlet|<p>Hello this is Probaa!!!|] 