<%@ Page language="C#" MasterPageFile="~masterurl/default.master" Inherits="Microsoft.SharePoint.WebPartPages.WebPartPage, Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="Utilities" Namespace="Microsoft.SharePoint.Utilities" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="WebPartPages" Namespace="Microsoft.SharePoint.WebPartPages" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>
<%@ Register Tagprefix="SharePoint" Namespace="Microsoft.SharePoint.WebControls" Assembly="Microsoft.SharePoint, Version=15.0.0.0, Culture=neutral, PublicKeyToken=71e9bce111e9429c" %>

<asp:Content ContentPlaceHolderId="PlaceHolderAdditionalPageHead" runat="server">
    <SharePoint:ScriptLink name="sp.js" runat="server" OnDemand="true" LoadAfterUI="true" Localizable="false" />
    
    <!--use host web css -->
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
    </script>
    
    <script type="text/javascript" src="../Scripts/jquery-1.11.2.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery.plugin.min.js"></script>
    <script type="text/javascript" src="../Scripts/jquery.countdown.min.js"></script>

    <link type="text/css" href="../Content/jquery.countdown.css" rel="stylesheet" />

    <style type="text/css">
        #countdownDiv { margin-top: 20px; }
    </style>
    
    <script type="text/javascript">
        $(document).ready(setTimer);

        function setTimer() {
            var today = new Date();
            var newYears = new Date(today.getFullYear() + 1, 0, 1);
            jQuery('#countdownDiv').countdown({
                until: newYears
            });

            jQuery('#greenLed').countdown({
                until: newYears,
                compact: true,
                layout: $('#greenLed').html()
            });

            jQuery('#blueLed').countdown({
                until: newYears,
                compact: true,
                layout: '<span class="image{d100}"></span><span class="image{d10}"></span><span class="image{d1}"></span>' +
                    '<span class="imageDay"></span><span class="imageSpace"></span>' +
                    '<span class="image{h10}"></span><span class="image{h1}"></span>' +
                    '<span class="imageSep"></span>' +
                    '<span class="image{m10}"></span><span class="image{m1}"></span>' +
                    '<span class="imageSep"></span>' +
                    '<span class="image{s10}"></span><span class="image{s1}"></span>'
            });
        }
    </script>
</asp:Content>

<asp:Content ContentPlaceHolderId="PlaceHolderMain" runat="server">
    <h1>Using Countdown</h1>
    <p>This web part is based on the <a target="_blank" href="http://keith-wood.name/countdown.html">Countdown jQuery plugin</a> by Keith Wood.</p>
    <p>To use Countdown, add the &quot;App Part&quot; called &quot;Countdown&quot; to your SharePoint pages. Edit the web part and adjust the options in the &quot;Countdown Configuration&quot; section of the web part properties.</p>
    <img src="../Images/InsertAppPart.png" alt="Insert App Part" width="303" height="135">

    <h1 style="padding-top: 20px">Examples</h1>
    
    <div style="display: table">
        <p>Counting down until January 1, Standard Style</p>
        <div id="countdownDiv"></div>
    </div>
    
    <div style="display: table">
        <p>Green LED Style</p>
        <span id="greenLed"> 
            <span class="image{d100}"></span> 
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
    </div>
    
    <div style="display: table">
        <p><br/>Blue LED Style</p>
        <div id="blueLed"></div>
    </div>
</asp:Content>
