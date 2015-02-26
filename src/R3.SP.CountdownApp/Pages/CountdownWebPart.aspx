<%@ Page language="C#" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<WebPartPages:AllowFraming ID="AllowFraming" runat="server" />

<html>
<head>
    <title>Countdown</title>

    <script type="text/javascript" src="/_layouts/15/MicrosoftAjax.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.runtime.js"></script>
    <script type="text/javascript" src="/_layouts/15/sp.js"></script>
    
    <script type="text/javascript" src="../Scripts/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-ui-1.11.3.min.js"></script>
    <link type="text/css" href="../Content/themes/base/all.css" rel="stylesheet" />

    <script type="text/javascript" src="../Scripts/moment.min.js"></script>
    <script type="text/javascript" src="../Scripts/twix.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery-extensions.js"></script>
    <script type="text/javascript" src="../Scripts/jquery.plugin.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery.countdown.min.js"></script>

    <link type="text/css" href="../Content/jquery.countdown.css" rel="stylesheet" />

    <script type="text/javascript">
        // Set the style of the client web part page to be consistent with the host web.
        (function () {
            'use strict';

            var hostUrl = '';
            if (document.URL.indexOf('?') != -1) {
                var params = document.URL.split('?')[1].split('&');
                for (var i = 0; i < params.length; i++) {
                    var p = decodeURIComponent(params[i]);
                    if (/^SPHostUrl=/i.test(p)) {
                        hostUrl = p.split('=')[1];
                        document.write('<link rel="stylesheet" href="' + hostUrl + '/_layouts/15/defaultcss.ashx" />');
                        break;
                    }
                }
            }
            if (hostUrl == '') {
                document.write('<link rel="stylesheet" href="/_layouts/15/1033/styles/themable/corev15.css" />');
            }
        })();

        var queryStringItems, countdownTo;

        $(document).ready(function() {
            queryStringItems = $.getQueryStringValues();
            showCountdown();
            resizePart();
        });

        function showCountdown() {
            // show helper in edit mode
            if (queryStringItems && queryStringItems.editmode == 1) {
                $('#helperDiv').show();

                $('#txtDate').datepicker({
                    minDate: 0,
                    formatDate: "mm/dd/yy"
                }).change(checkValues);

                $('#txtTime').change(checkValues);
            }

            // check for error
            if (!queryStringItems || !queryStringItems.countdownTo) {
                $('#countdownDiv').html('<h3>Configuration Error</h3><p>The app part is not configured correctly. Please see the help page for more info.</p>');
                return;
            }

            // get js date
            countdownTo = moment(unescape(queryStringItems.countdownTo));

            // default style
            var countdownConfig;

            // prepend digits for days in LED styles
            var digits = moment().twix(countdownTo).count('days').toString().length;
            if (digits === 3 || digits === 4) {
                var hundreds = '<span class="image{d100}"></span>';
                $('#greenLed').prepend(hundreds);
                $('#blueLed').prepend(hundreds);
            }
            if (digits === 4) {
                var thousands = '<span class="image{d1000}"></span>';
                $('#greenLed').prepend(thousands);
                $('#blueLed').prepend(thousands);
            }

            // LED styles
            switch (queryStringItems.countdownStyle) {
                case "green":
                    countdownConfig = {
                        until: countdownTo.toDate(),
                        compact: true,
                        layout: $('#greenLed').html()
                    };
                    $('#greenLed').countdown(countdownConfig).show();
                    break;
                case "blue":
                    countdownConfig = {
                        until: countdownTo.toDate(),
                        compact: true,
                        layout: $('#blueLed').html()
                    };
                    $('#blueLed').countdown(countdownConfig).show();
                    break;
                default:
                    countdownConfig = {until: countdownTo.toDate()};
                    $('#countdownDiv').countdown(countdownConfig).show();
            }
            
        }

        function checkValues() {
            var isValid;

            var dateTest = /^\d{2}\/\d{2}\/\d{4}$/;
            var timeTest = new RegExp('([0-1][0-9]|2[0-3]):([0-5][0-9]):([0-5][0-9])');

            var $date = $('#txtDate').val();
            var $time = $('#txtTime').val();
            var $div = $('#dateValue');

            isValid = (dateTest.test($date) && timeTest.test($time));

            if (isValid) {
                var timeString = $date.toString() + ' ' + $time.toString();
                var m = moment(timeString, 'MM-DD-YYYY HH:mm:ss');
                if (m.isValid) {
                    $('#isoDate').val(m.format('YYYY-MM-DDTHH:mm:ss'));
                    $div.show();
                    resizePart();
                } else $div.hide();
            } else {
                $div.hide();
            }
        }

        function resizePart() {
            var step = 30,
                newHeight,
                contentHeight = $('#webPartContent').height(),
                resizeMessage = '<message senderId={Sender_ID}>resize({Width}, {Height})</message>';

            // overrides for LED styles (difficult to detect)
            if (queryStringItems.countdownStyle === "green" && queryStringItems.editmode != 1) {
                contentHeight = 21;
            }
            else if (queryStringItems.countdownStyle === "blue" && queryStringItems.editmode != 1) {
                contentHeight = 50;
            }

            newHeight = (step - (contentHeight % step)) + contentHeight;

            if (queryStringItems && queryStringItems.editmode == 1) {
                newHeight = newHeight * 2; // double for edit mode to show flyout calendar, etc.
            }

            resizeMessage = resizeMessage.replace("{Sender_ID}", queryStringItems.SenderId);
            resizeMessage = resizeMessage.replace("{Height}", newHeight);
            resizeMessage = resizeMessage.replace("{Width}", "100%");

            window.parent.postMessage(resizeMessage, "*");
        }
    </script>
</head>
    <body>
        <div id="webPartContent">
            <div id="countdownDiv"style="display: none"></div>
            <span id="greenLed" style="display: none"> 
                <span class="image{d10}"></span> 
                <span class="image{d1}"></span> 
                <span class="imageDay"></span> 
                <span class="imageSpace"></span> 
                <span class="image{h10}"></span> 
                <span class="image{h1}"></span> 
                <span class="imageSep"></span> 
                <span class="image{m10}"></span> 
                <span class="image{m1}"></span> 
                <span class="imageSep"></span> 
                <span class="image{s10}"></span> 
                <span class="image{s1}"></span> 
            </span>
            <div id="blueLed" style="display: none">
	            <span class="image{d10}"></span>
	            <span class="image{d1}"></span>
	            <span class="imageDay"></span>
	            <span class="imageSpace"></span>
	            <span class="image{h10}"></span>
	            <span class="image{h1}"></span>
	            <span class="imageSep"></span>
	            <span class="image{m10}"></span>
	            <span class="image{m1}"></span>
	            <span class="imageSep"></span>
	            <span class="image{s10}"></span>
	            <span class="image{s1}"></span>
            </div>
            <div id="helperDiv" style="display: none">
                <p><br/>If you need help building an <a target="_blank" href="https://xkcd.com/1179/">ISO-8601 formatted</a> date and time, use this helper and copy/paste the value below into the Configuration section of the web part configuration.</p>
                <div><p>Select or enter a date in MM/DD/YYYY format.</p><input title="Date" type="text" id="txtDate" required/></div>
                <div><p>Enter the time in the format of HH:MM:SS using a 24-hour clock (e.g. 13 = 1 PM).<br/>Use 00:00:00 for midnight (12:00 AM).</p>
                    <input title="Time" type="text" id="txtTime" required/>
                </div>
                <div id="dateValue" style="display: none">
                    <p><br/>Valid date and time. Copy/paste this into your web part configuration:</p>
                    <input type="text" id="isoDate"/>
                </div>
            </div>
        </div>
    </body>
</html>
