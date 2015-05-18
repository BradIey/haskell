# haskell
Haskell Work


Hello.txt is the file that stores the parsed JSON object as a string from the provided URL, it needs to be in the same directory as the two other files in order for the code to run correctly. 

'test.hs' contains the code to take the JSON object and write it to file.
'WS.hs' has the code to extract a Temperatures object from file and attempts to serve it up.

I successfully managed to read the JSON object from the URL and store the result into a file. However, whilst attempting to develop the code to read from this file and serve up a parsed result to localhost it was realised that my getTemps function was returning nothing. My guess is that decode isnt correctly decoding the hello.txt file because the JSON in the file doesn't accurately match the types I have declared.

{"temperatures":[
	{"date":"2015-02-28T20:16:12+00:00", "temperature":0},
	{"date":"2015-01-01T21:46:55+00:00", "temperature":2}, 
	{"date":"2015-04-08T21:46:53+00:00", "temperature":3},
	{"date":"2015-04-09T21:46:01+00:00", "temperature":4},
	{"date":"2015-04-10T21:46:40+00:00", "temperature":5},
	{"date":"2015-04-11T21:46:36+00:00", "temperature":6},
	{"date":"2015-04-12T20:36:25+00:00", "temperature":7}
]}

Compared to whats in the file:

Data {date = "2015-02-28T20:16:12+00:00", temperature = 0}
Data {date = "2015-01-01T21:46:55+00:00", temperature = 2}
Data {date = "2015-04-08T21:46:53+00:00", temperature = 3}
Data {date = "2015-04-09T21:46:01+00:00", temperature = 4}
Data {date = "2015-04-10T21:46:40+00:00", temperature = 5}
Data {date = "2015-04-11T21:46:36+00:00", temperature = 6}
Data {date = "2015-04-12T20:36:25+00:00", temperature = 7}

I spent the vast majority of my time whilst working on the serving part of the assignment trying to get a (Maybe Temperatures) into a Response. Because if I did this I could simply serve it up and be happy. I tried to find examples online of how people were converting their custom types into the Response type so I could emulate the logic and apply it to my type Temperatures. 

I saw that users were not directly converting their types into Responses, but extracting the useful information and using the instances of ToMessage declared to form a response.

I had to create an instance for ToMessage with an Int as there was only a declaration for Integer.
Source: http://happstack.com/docs/happstack-server-7.0.1/doc/html/happstack-server/src/Happstack-Server-Response.html#toResponse

I did use an unsafePerformIO, I only did this so that I could test whether my serving up code worked or not. And because of this I realised that my getTemps function doesn't decode the file properly! (Though I'm pretty sure it's because of the format the JSON is in, in Hello.txt and not the logic of the function)

I managed to get WS.hs to compile by instead of trying to serve up Temperatures, serve up a parsed (Maybe Temperatures) in the form of an Int (all of the temperature readings added together).

The only error I get is each time you you load localhost:8000 in the browser you get this response in the terminal:

HTTP request failed with: Maybe.fromJust: Nothing

This is very indicative of a decode error not a logical error with my serving up code, which is encouraging!

Although I made some progress in ALMOST serving up some arbitrary number using the temperature data from file 
(It would serve up if getTemps actually returned a (Maybe Temperatures)!) I'd like to agree to the viva because it gives me a chance to explain my progress and thoughts behind how I went about trying to complete the assignment.


