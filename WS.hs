{-# LANGUAGE OverloadedStrings, DeriveGeneric #-}

import Data.Aeson
import Data.Text
import Control.Applicative
import Control.Monad.IO.Class
import qualified Data.ByteString as L         
import qualified Data.ByteString.Lazy as B
import Network.HTTP.Conduit (simpleHttp)
import GHC.Generics
import System.IO
import Data.List as A
import Happstack.Server
import qualified Text.Blaze.Html5
import qualified Text.Blaze.Html5.Attributes
import System.IO.Unsafe
import Data.Maybe

data Data = Data { date :: String
                   , temperature :: Int
                    } deriving (Show, Read, Generic)

data Temperatures = Temperatures { temperatures :: [Data]
                                 } deriving (Show, Generic)

instance ToJSON Temperatures
instance FromJSON Temperatures

instance ToJSON Data
instance FromJSON Data
 
-- ToMessage for Int as an instance is only defined for Integer
----------------------------------------------------------------
instance ToMessage Int where
	toMessage = toMessage . show
----------------------------------------------------------------


-- SERVE UP A RESPONSE @ localhost:8000
----------------------------------------------------------------
main :: IO ()
main = simpleHTTP nullConf $ ok $ addStuff $ getInts
----------------------------------------------------------------


-- Meaningless number to serve as a test
----------------------------------------------------------------
addStuff :: [Int] -> Int
addStuff (x:xs) = x + addStuff xs
----------------------------------------------------------------


-- GET TEMPERATURES OBJECT FROM FILE
----------------------------------------------------------------
-- Gets the temperatures data from file
getTemps :: IO (Maybe Temperatures)
getTemps =  decode <$> getFile
		    where
			    getFile = B.readFile "Hello.txt"

-- Gets all of the temperature readings from the file
getInts :: [Int] 
getInts =  A.map temperature $ temperatures $ fromJust $ hack
----------------------------------------------------------------


-- A DIRTY HACK (SORRY! This allowed me to ignore an error and work on
-- the code to serve up a response)
----------------------------------------------------------------
hack :: Maybe Temperatures
hack = unsafePerformIO getTemps
----------------------------------------------------------------


-- Attempts to understand certain problems
----------------------------------------------------------------
{-
printTemps :: IO ()
printTemps = do 
				temps <- getTemps
				case temps of
					Nothing -> print ""
					Just ts -> putStrLn A.unlines $ show ts

rq :: ServerPart Response
rq = liftIO getTemps

rq :: ServerPart Response
rq = do
		temps <- liftIO getTemps
-}

