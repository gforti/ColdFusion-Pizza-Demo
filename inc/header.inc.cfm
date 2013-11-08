<cfoutput>
<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.01//EN" "http://www.w3.org/TR/html4/strict.dtd">
<html xmlns='http://www.w3.org/1999/xhtml' lang='en' xml:lang='en:us'>
  <head>
	<meta http-equiv="Content-type" content="text/html; charset=utf-8">
	<link rel="stylesheet" type="text/css" href="css/global.css" />
	
	<title>#variables.context.get("title")#</title>
	</head>
	<body>
		
	<cfif variables.context.get("showAdminMenu")>
		<div id="adminMenu">
		<cfinclude template="../inc/adminMenu.inc.cfm">
		</div>
	</cfif>	
	
	<div id="wrapper">
	
		<div id="header">
			<div id="menu">
				<cfinclude template="../inc/menu.inc.cfm">
			</div>
			
			<div id="logo">
				<h1>#variables.context.get("title")#</h1>
				<h2>Good Pizza Good Times</h2>
			</div>
			
		</div>
		<div id="cart">
			<cfinclude template="../inc/userCart.inc.cfm">
		</div>
			
		<div id="content">
			
</cfoutput>