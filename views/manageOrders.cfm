
<cfoutput>
	 <h1> <img src="images/pizza_icon.png" /> View Orders</h1>
	 
	 
	 <cfset ordersStruct = application.registry.get("OrdersDAO").read()>
	 	<cfset thisPage = application.config.currentUrl>
	 
	 <ul>
	 <cfloop collection="#ordersStruct#" item="thisID">
		 <li> <p>	 
			<form name="lookup" method="post" action="#thisPage#">
				Order <strong>#thisID# </strong>
				<input type="hidden" name="action" value="ORDERSTATUS"  />
				<input type="hidden" id="LookupOrderID" name="orderID" value="#thisID#" />
				<input type="submit" name="submitBtn" value="Lookup">
				<div id="errMsg" class="errorMsg" style="display:none;"></div>
			</form>	
			</p>
		 </li>	 
	 </cfloop>
	 </ul>
	 
</cfoutput>