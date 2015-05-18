{-# LANGUAGE OverloadedStrings #-}

import Control.Monad (forM_)
import Text.Blaze.Html5 as H
import Text.Blaze.Html5.Attributes as A

webstuff :: String -> Html
webstuff w = docTypeHtml $ do
	H.head $ do
		H.title "Test"
	body $ do
		p "Hello"
		ul $ forM_ [1...n] (li . toHtml)