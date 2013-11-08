
<cfset sitePath = application.config.sitePath>

<cfoutput>
	<ul>
		 <li> <a href="#sitePath#">Home</a> </li>
		 <li> <a href="#sitePath#?action=pizzamenu">Menu</a> </li>
		 <li> <a href="#sitePath#?action=order">Order</a> </li>
		 <li> <a href="#sitePath#?action=ORDERSTATUS">Order Status</a> </li>
		 
	</ul>
</cfoutput>