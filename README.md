# cf_text_util
"Simple" ColdFusion text cleaner/encoder that selectively allows some HTML elements.

This tool is English ASCII only.

## Problem

When the user enters data we need to "clean" the data to prevent problems from XSS attacks to simply broken page formatting.

`encodeForHTML()` and `canonicalize()` both do a great job of cleaning user-entered text, but sometimes you want to allow *some* formatting options for the end user.

## Path to a "solution"

CleanText came initially from a need to allow the user to preserve line breaks in their entered text. It was expanded to allow **bold** and *italics* and later lists.

It was eventually expanded to support most of the basic editing options provided by the bare-bones CKEditor install and to allow the cleaning to be done on the server side to minimize the downloading and processing load on the client.

## Other options

We exerimented with Markdown, but it proved too confusing for our end-users to enter and was a problem for our reporting engine (the engine understood HTML, but did not have a Markdown intrepreter option).


## Components

The text_util.cfm package has two main components

### stripWord(required string text)
MS Word loves replacing basic text with fancy unicode characters. stripWord goes through and replaces many of the special characters with their basic text equivalent and then removes all non-ascii characters from the string.

stripWord() specifically replaces the following codes:
```
          ANSII 8220 - #chr(8220)# - left quotes with "
          ANSII 8221 - #chr(8221)# - right quotes with "
          ANSII 8216 - #chr(8216)# - left quote with '
          ANSII 8217 - #chr(8217)# - right quote with '
          ANSII 8211 - #chr(8211)# - en dash with -
          ANSII 8212 - #chr(8212)# - em dash with -
          ANSII 8226 - #chr(8226)# - bullet with *
          ANSII 8230 - #chr(8230)# - ellipsis with ...
```

### cleanText(required string text, numeric maxLength = 0)
Cleans and formats a string for display on the page.

cleanText first runs stripWord() to remove MS Word characters.

It then optionally trims the string to maxLength characters. If the string is trimmed, append &amp;hellip;' &hellip;' to the end.

Then run the CF function <i>encodeForHTML(string)</i> to remove HTML and other special characters and replace them with their escaped values

After the encodeForHTML(), the string will contian only screen-ready clean text and escaped special characters.

At this point, we want to go back to the string and replace some of the escaped HTML characters and	replace them with real HTML	to allow the user to have some formatting options. 

Replace escaped strong, em, u, s, sup, sub, blockquote, ol, ul, and li with their html equivalents


## Usage

Just do a `<cfinclude template="text_util.cfm" />` in your page and then call cleanText on any value you want cleaned. Use it in place of encodeForHTML() or canonicalize().


```
   <cfinclude template="./text_util.cfm" />
   <cfoutput>
       #cleanText(VARIABLE_WITH_POTENTIALLY_BAD_TEXT)#
   </cfoutput>
```

## History

cleanText() (or a close veriant of cleanText) has been in use on our Intranet based page for over 10 years with no reported problems. It has also been used on a closed access publically facing Internet page.



## Next Steps?

Well, I would love to be able to detect web and email addresses and make them clickable, but that is proving to be more trouble than I care for at this time.

