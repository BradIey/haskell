{-# LANGUAGE OverloadedStrings #-}

module Main where

import Happstack.Server
import Data.Aeson
import Data.Text
import Control.Applicative
import Control.Monad.IO.Class
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import GHC.Generics
import System.IO
import Data.List as A
import qualified Text.Blaze.Html5
import qualified Text.Blaze.Html5.Attributes

data Data = Data { date :: String
                   , temperature :: Int
                    } deriving (Show, Read)

data Temperatures = Temperatures { temperatures :: [Data]
                                 } deriving (Show)

instance FromJSON Temperatures
instance FromJSON Data                                 

main :: IO ()
main = simpleHTTP nullConf $ ok (toResponse getTemps)

rq :: ServerPart Response 
rq = do 
	  temps <- liftIO getTemps

-- GET TEMPERATURES OBJECT FROM FILE
-------------------------------------------------
-- Gets the temperatures data from file
getTemps :: IO (Maybe Temperatures)
getTemps =  decode <$> getFile
		    where
			    getFile = B.readFile "Hello.txt"
-------------------------------------------------