
<cfoutput>
		<h1><img src="images/Pizzaslice.jpg" /> Welcome </h1>
		
		
		<cfif Len(variables.context.getSuccess())>
			<p class="sucessMsg">#variables.context.getSuccess()#</p>
		</cfif>
		
		<cfif Len(variables.context.getError())>
			<p class="errorMsg">#variables.context.getError()#</p>
		</cfif>
		
		
		<p> Welcome to the Pizza Company Pizza Parlor site.  To Start Select a Pizza You would like to order and follow the instructions</p>
		
		<p> All orders are for pick up only and if your pizza is not ready within 30 minutes, it's free!</p>
				
		
		<cfset helperFuncs = application.registry.get("PizzaHelper")>
		<cfset thisPage = application.config.currentUrl>
		
		
		<cfset helperFuncs.displayOrderStatusSearch()>	
		
		<cfset helperFuncs.displayPizzaOrders()>
				
		
	</cfoutput>	