{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

import Data.Aeson
import Data.Text
import Control.Applicative
import Control.Monad.IO.Class
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import GHC.Generics
import System.IO
import Data.List as A
import Happstack.Server
import qualified Text.Blaze.Html5
import qualified Text.Blaze.Html5.Attributes

--import Data.DateTime

data Data = Data { date :: String
                   , temperature :: Int
                    } deriving (Show, Read, Generic)

data Temperatures = Temperatures { temperatures :: [Data]
                                 } deriving (Show, Generic)

instance ToJSON Temperatures
instance FromJSON Temperatures

instance ToJSON Data
instance FromJSON Data

-- GET JSON
-----------------------------------------------
jsonURL :: String
jsonURL = "http://www.phoric.eu/temperature"

-- Gets the JSON object from the URL
getJSON :: IO B.ByteString
getJSON = simpleHttp jsonURL
------------------------------------------------

respond :: IO ()
respond = simpleHTTP nullConf $ ok $ printTemps

printTemps :: IO ()
printTemps = do
				temps <- getTemps
				case temps of
					Nothing -> print ""
					Just ts -> putStrLn $ show ts

-- WRITE TO FILE
------------------------------------------------------------
-- Combines all the of temperature data
cmbine :: [Data] -> String
cmbine xs = A.unlines (A.map show xs)

-- Writes all of the temperatures to file
toFile :: Temperatures -> IO ()
toFile xs = writeFile "Hello.txt" $ cmbine $ temperatures xs 
------------------------------------------------------------

rq :: ServerPart Response
rq = maybeTempsToResponse <$> liftIO getTemps
	 where
	 	maybeTempsToResponse :: (Maybe Temperatures) -> Response
-- GET TEMPERATURES OBJECT FROM FILE
-------------------------------------------------
-- Gets the temperatures data from file
getTemps :: IO (Maybe Temperatures)
getTemps =  decode <$> getFile
		    where
			    getFile = B.readFile "Hello.txt"

{-
   Cannot convert impure to pure
   getInts :: [Int] 
   getInts =  A.map temperature $ temperatures $ getTemps
-}
-------------------------------------------------

-- DO SOME PROCESSING
-------------------------------------------------
-- Add all of the temperatures
addStuff :: [Int] -> Int
addStuff (x:xs) = x + addStuff xs
-------------------------------------------------
main :: IO ()
main = do 
 de <- (eitherDecode <$> getJSON) :: IO (Either String Temperatures)
 case de of
  Left error   -> putStrLn error
  Right stuff -> toFile stuff
