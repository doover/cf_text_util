<cfscript>
/*
    Description: A collection of common utilities to clean up user entered text
*/

/** stripWord
 *
 * given a string, replace and strip many of the freaky MS Word codes.
 *
 * This function is used mostly by the cleanText() function, but is provided
 * as a separate function for optional use during saves
 * This function converts weird MS Word to 'normal' text, then eliminates
 * anything else weird left over (outside of English ASCII range)
 *
 * 	Codes stripped:
 * 				ANSII 8220 - #chr(8220)# - left quotes
 * 				ANSII 8221 - #chr(8221)# - right quotes
 * 				ANSII 8216 - #chr(8216)# - left quote
 * 				ANSII 8217 - #chr(8217)# - right quote
 * 				ANSII 8211 - #chr(8211)# - en dash
 * 				ANSII 8212 - #chr(8212)# - em dash
 * 				ANSII 8226 - #chr(8226)# - bullet
 * 				ANSII 8230 - #chr(8230)# - ellipsis
 *
 * @text	string to strip
 * @returns	String stripped of all freak MSWord escape characters
 */
string function stripWord(required string text)
        hint="given a string, replace and strip many of the freaky MS Word codes.<br />
            This function is used mostly by the cleanText() function, but is provided as a separate function for optional use during saves<br />
            This function converts weird MS Word to 'normal' text, then eliminates anything else weird left over (outside of English ASCII range)<br />
            Codes stripped:<br />
            ANSII 8220 - #chr(8220)# - left quotes<br />
            ANSII 8221 - #chr(8221)# - right quotes<br />
            ANSII 8216 - #chr(8216)# - left quote<br />
            ANSII 8217 - #chr(8217)# - right quote<br />
            ANSII 8211 - #chr(8211)# - en dash<br />
            ANSII 8212 - #chr(8212)# - em dash<br />
            ANSII 8226 - #chr(8226)# - bullet<br />
            ANSII 8230 - #chr(8230)# - ellipsis"	 {

        var returnValue = trim(arguments.text);

        //
        returnValue = replace(returnValue, chr(8220), '"', 'all');		// left quotes
        returnValue = replace(returnValue, chr(8221), '"', 'all');		// right quotes
        returnValue = replace(returnValue, chr(8216), "'", 'all');		// left '
        returnValue = replace(returnValue, chr(8217), "'", 'all');		// right '
        returnValue = replace(returnValue, chr(8211), "-", 'all');		// en dash
        returnValue = replace(returnValue, chr(8212), "-", 'all');		// em dash
        returnValue = replace(returnValue, chr(8226), "*", 'all');		// bullet
        returnValue = replace(returnValue, chr(8230), "...", 'all');		// ellipsis

        // now strip everything outside of "normal ASCII" range
        returnValue = ReReplace(returnValue, '[^\x00-\x7F]', "", 'all');		// all non ASCII 0 - 128

        return trim(returnValue);
} // stripWord


/**
 * cleanText
 *
 * Clean and format a string for display on the page.
 *
 *  First runs stripWord() to remove MS Word characters.
 *
 *  Then optionally trim the string to maxLength characters. If the string is trimmed,
 *  append &amp;hellip;' &hellip;' to the end.
 *
 *  Then run the CF function <i>encodeForHTML(string)</i> to remove HTML and other special
 *  characters and replace them with their escaped values
 *
 * 	After the encodeForHTML(), the string will contian only screen-ready clean text and
 *  escaped special characters.
 *
 *  At this point, we want to go back to the string and replace some of the escaped HTML
 *  characters and	replace them with real HTML	to allow the user to have some formatting
 *  options.
 *
 *	Replace escaped strong, em, u, s, sup, sub, blockquote, ol, ul, and li with their html
 *	equivalents
 *
 * 	@text		String to clean
 *  @maxLength	If set, trim to this maxlength size and append '...'
 *  @returns	Encoded and re-coded string
 */
string function cleanText(required string text hint="Text to clean",
                            numeric maxLength = 0 hint="if non-0, trim to this length and append '...'")
        hint="Clean and format a string for display on the page.<br />
            <br />
            First runs stripWord() to remove MS Word characters.<br />
            <br />
            Then optionally trim the string to maxLength characters. If the string is trimmed, append &amp;hellip;' &hellip;' to the end.<br />
            <br />
            Then run the CF function <i>canonicalize(string)</i> to remove HTML and other special characters and replace them with their escaped values<br />
            <br />
            After the canonicalize(), the string will contian only screen-ready clean text and escaped special characters.<br />
            <br />
            At this point, we want to go back to the string and replace some of the escaped HTML characters and replace them with real HTML to allow the user to have some formatting options.<br />
            <br />
            Replace escaped strong, em, u, s, sup, sub, blockquote, ol, ul, and li with their htmlequivalents" {
    var returnValue = trim(arguments.text);
    var dotrimlength = false;


    // strip out stoopid word characters for ", ' and others
    returnValue = stripWord(returnValue);


    // trim string before further processing. make note we need to add ... later
    if (    arguments.maxLength GT 0
        AND len(returnValue) GT arguments.maxLength) {
        returnValue = left(returnValue, arguments.maxLength -1);
        dotrimlength = true;
    }

    // now "clean" the string
    returnValue = encodeForHTML(returnValue, true);	// encode

    // start decoding select strings
    returnValue = REReplace(returnValue, "&##x9;", "    ", "all");	    // replace escaped tabs
    returnValue = REReplace(returnValue, "&amp;nbsp&##x3b;", "&nbsp;", "all");	    // replace the escaped NBSP with unescaped NBSP

    // replace character returns (&##xd;&##xa; = \r\n) with BRs
    returnValue = REReplace(returnValue, "(&##xd;&##xa;|&##xa;)" , "<br />
    ", "all");																					// replace character returns

    // We replaced \n above, so remove any dangling escaped BRs
    returnValue = REReplaceNoCase(returnValue, "&lt;br &##x2f;&gt;", "", "all");

    // Replace tags escaped with unescaped versions of the tag
    // whitelist tags
    returnValue = findAndReplaceEscapedTag(returnValue, 'p');			// paragraph
    returnValue = findAndReplaceEscapedTag(returnValue, 'strong');      // bolding
    returnValue = findAndReplaceEscapedTag(returnValue, 'em');          // italics
    returnValue = findAndReplaceEscapedTag(returnValue, 'u');           // underline
    returnValue = findAndReplaceEscapedTag(returnValue, 's');           // strikethru
    returnValue = findAndReplaceEscapedTag(returnValue, 'sup');         // superscript
    returnValue = findAndReplaceEscapedTag(returnValue, 'sub');         // subscript
    returnValue = findAndReplaceEscapedTag(returnValue, 'blockquote');  // blockquote
    returnValue = findAndReplaceEscapedTag(returnValue, 'ol');          // OL
    returnValue = findAndReplaceEscapedTag(returnValue, 'ul');          // UL
    returnValue = findAndReplaceEscapedTag(returnValue, 'li');          // LI

    // clean up weird cases
    /* 	The earlier \n -> <br /> creates weird effects
        In most text blocks, after a block element (div, UL, OL, LI), the
        text will include a line feed.

        But the \n -> <br /> will cause a BR to be put after a block element
        causing a usually unwanted extra line-feed.

        So we need to go back and remove spurious BRs after block elements.

        code hint: XX> so it matches <xx> and </xx>
    */
    returnValue = REReplace(returnValue, "ul><br />", "ul>", "all");
    returnValue = REReplace(returnValue, "ol><br />", "ol>", "all");
    returnValue = REReplace(returnValue, "li><br />", "li>", "all");
    returnValue = REReplace(returnValue, "blockquote><br />", "blockquote>", "all");

    // if we trimmed earlier, add the trailing ...
    if (dotrimlength) {
        returnValue = returnValue & '&hellip;';
    }

    return returnValue;
}	// cleanText


/**
 *  findAndReplaceTags
 *
 *	private function used by cleanText
 *
 *  @hint Given an HTML tag, find and replace all escaped versions of the opening and closing elements of the tag
 *
 * @testString		String to fix
 * @testElement		element to look for in testString
 *
 * @CFLintIgnore VAR_IS_TEMPORARY,ARGUMENT_IS_TEMPORARY
 */
private string function findAndReplaceEscapedTag(required string testString, required string testElement) {

    // find opening tags
    testString = REReplaceNoCase(testString, "&lt;#testElement#&gt;", "<#testElement#>", "all");

    // find closing tags  &##x2f; = /
    testString = REReplaceNoCase(testString, "&lt;&##x2f;#testElement#&gt;", "</#testElement#>", "all");

    // make sure all opens are closed
    // NOTE, looking for <tag (match either followed by space or closing angle so "s" does not match "strong" - to capture all variations
    // Count number of open elemerts, then number of closed elements, and add any extra closings
    var testMatch = arrayLen(REMatch("<#testElement#[ >]", testString)) - arrayLen(REMatch("</#testElement#>", testString));
    if (testMatch GT 0) {   // if missmatch, add more closing elements
        testString = testString & repeatString("</#testElement#>", testMatch);
    }
    return testString;
}
</cfscript>
