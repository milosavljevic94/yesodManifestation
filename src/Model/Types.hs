{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
{-# LANGUAGE QuasiQuotes#-}
module Model.Types where

import Import.NoModel

data Category = Sport | Concert | Theater
    deriving (Show, Eq, Read, Enum, Bounded)
derivePersistField "Category"