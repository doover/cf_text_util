<cfsavecontent variable="text">
    <strong>Lorem ipsum dolor sit amet</strong>, consectetur adipiscing elit. Nullam eget mollis mauris. Donec eget mi quis justo feugiat congue sit amet a tortor. <em>Duis euismod luctus lacinia</em>. Aenean ipsum dolor, vestibulum auctor porttitor vel, tempor ut felis. Nullam dictum nulla quis augue varius volutpat. Aliquam tincidunt blandit placerat. Aenean fermentum sagittis nunc vel aliquam. Aenean commodo eu justo nec malesuada. Fusce sed consectetur ante. Pellentesque tincidunt urna augue, eu venenatis elit tincidunt eget. Vivamus volutpat fermentum fermentum. Pellentesque condimentum faucibus nisi, in viverra turpis tincidunt ut. Phasellus ut sagittis turpis, a bibendum lectus. Sed varius lectus convallis malesuada aliquet. Fusce lacinia, enim non aliquet ultrices, nisi nisi consectetur lectus, id lobortis lacus nulla sit amet erat. Integer nibh ipsum, aliquet nec porttitor a, faucibus ut ex.

    <script>alert("Hello, injection!");</script>

    <ul>
        <li>In porta est in interdum luctus.</li>
        <li>Interdum et malesuada fames ac ante ipsum primis in faucibus.</li>
        <li>In commodo semper ipsum, a aliquam turpis sollicitudin vitae.</li>
    </ul>

    Suspendisse diam augue, fringilla sit amet magna in, bibendum mattis sem. Sed enim eros, blandit at mattis eget, finibus quis orci. Aliquam euismod suscipit placerat. Curabitur pellentesque finibus risus, vel euismod risus rhoncus et. Interdum et malesuada fames ac ante ipsum primis in faucibus. Nulla facilisi. Phasellus congue, leo et dignissim ultricies, dui risus porta lectus, sit amet interdum augue metus semper neque. Nam egestas erat pretium purus dictum mollis. Morbi bibendum ligula dolor, sit amet consequat velit malesuada vel. Pellentesque non egestas tortor, vel scelerisque ipsum. Nunc pulvinar felis id imperdiet posuere. In eget venenatis enim. Nunc ac pharetra erat, eu pretium ipsum. Donec sed metus arcu.


</cfsavecontent>



<cfoutput>#encodeForHTML(text)#

<br />
<br />
<hr />
<br />
<cfinclude template="text_util.cfm" />
#cleanText(text)#</cfoutput>
