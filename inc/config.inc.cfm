
<cfset application.config = structNew()>

<cfset application.config.xmlPath = ExpandPath("../gabepizza/data/xml/")>
<cfset application.config.mainFileName = "index">
<cfset application.config.currentUrl = "#getFileFromPath(getTemplatePath())#">
<cfset application.config.currentQueryString = "#cgi.query_string#">
<cfset application.config.sitePath = "../gabepizza/">
<cfset application.config.mainFolder = "views">





