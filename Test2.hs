{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

module Test2 where 

import Data.Aeson
import Data.Text
import Control.Applicative
import Control.Monad
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import GHC.Generics
import System.IO
--import Data.DateTime
data Data = Data { date :: String
                   , temperature :: Int
                    } deriving (Show, Read, Generic)

data Temperatures = Temperatures { temperatures :: [Data]
                                 } deriving (Show, Generic)


main :: IO ()
main = do leStuff

leStuff :: IO Temperatures
leStuff  = decode getFile
	where
		getFile = B.readFile "Hello.txt"
