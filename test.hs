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
-----------------------------------------------------------------------
jsonURL :: String
jsonURL = "http://www.phoric.eu/temperature"

-- Gets the JSON object from the URL
getJSON :: IO B.ByteString
getJSON = simpleHttp jsonURL
-----------------------------------------------------------------------


-- WRITE TO FILE
-----------------------------------------------------------------------
-- Combines all the of temperature data by mapping show over the list 
-- and calling unlines on the result

cmbine :: [Data] -> String
cmbine xs = A.unlines (A.map show xs)

-- Writes all of the temperatures to file by getting
toFile :: Temperatures -> IO ()
toFile xs = writeFile "Hello.txt" $ cmbine $ temperatures xs 
-----------------------------------------------------------------------
-----------------------------------------------------------------------
main :: IO ()
main = do 
 de <- (eitherDecode <$> getJSON) :: IO (Either String Temperatures)
 case de of
  Left error   -> putStrLn error
  Right stuff -> toFile stuff
