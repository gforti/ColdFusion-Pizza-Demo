
<cfoutput>
	 <h1> <img src="images/pizza_icon.png" /> Order Status</h1>
	 
	 <cfset formStruct = variables.context.get("form")>
	 
	 <cfset orderID = "">	
	 <cfif StructKeyExists(formStruct, "orderID")>
		<cfset orderID = Trim(formStruct["orderID"])>		
	</cfif>

	
		<cfset helperFuncs.displayOrderStatusSearch()>	
		<cfset ToppingsDAO = application.registry.get("ToppingsDAO")>
		<cfset PizzasDAO = application.registry.get("PizzasDAO")>
		
		<cfif Len(orderID)>
		
			<h3> Order Status </h3>
			<cfif helperFuncs.isValidOrderStatusID(orderID)>			
		
				<cfset thisOrderStruct = application.registry.get("OrdersDAO").read(orderID)>
				
				<table cellpadding="5">
				<tr>
					<td> <strong> Status </strong> </td> 
					<td> <cfif thisOrderStruct.status EQ 0> In Progress <cfelse> Ready </cfif> </td>				
				</tr>
				<tr>
					<td> <strong> Order Placed </strong> </td> 
					<td> #DateFormat(thisOrderStruct.datetime,"mm/dd/YYYY")# #TimeFormat(thisOrderStruct.datetime)# </td>				
				</tr>
				<tr>
					<td> <strong> Order Ready By </strong> </td> 
					<td> #DateFormat(DateAdd("n", 30, thisOrderStruct.datetime),"mm/dd/YYYY")# #TimeFormat(DateAdd("n", 30, thisOrderStruct.datetime))# </td>				
				</tr>				
				<tr>
					<td> <strong> Contact </strong> </td> 
					<td> #thisOrderStruct.contact# </td>				
				</tr>
				<tr>
					<td> <strong> Contact Phone </strong> </td> 
					<td> #thisOrderStruct.phone# </td>				
				</tr>
				</table>
				
				<cfset subTotal = 0>
				<cfset salesTax = 0>
			
				<table cellpadding="10" border="1">
				<tr>
					<th> Pizza </th>
					<th> Price </th>
					<th> Quanity </th>
					<th> Extra Toppings </th>
				</tr>
				
				
				<cfset pizzStructs = thisOrderStruct.Pizzas>
				<cfloop collection="#pizzStructs#" item="thisID">
				
					<cfset pizzaInfo = pizzStructs[thisID]>
				
					<cfset subTotal = val(subTotal+pizzaInfo.pizzaprice)>
				
					<tr> 
						<td> <cfif helperFuncs.isValidPizzaID(pizzaInfo.pizzaid)> #PizzasDAO.read(pizzaInfo.pizzaid).name#</cfif> </td>
					
						<td>#NumberFormat(val(pizzaInfo.pizzaprice),"$___.__")# </td>
						<td>#val(pizzaInfo.pizzaqty)# </td>
						<td> 
							<cfif ListLen(pizzaInfo.pizzaextratoppings)>
								#helperFuncs.translateExtraToppingsNames(pizzaInfo.pizzaextratoppings)#
							<cfelse>
								No Extra Toppings
							</cfif>
						</td>
					
					</tr>
					
				</cfloop>
				
				</table>
				
				
				
				
			<table border="0" cellpadding="5">
				<tr>					
				  <td>Subtotal</td>
				  <td>#NumberFormat(subTotal,"$___.__")#</td>
				</tr>
				<tr>					
				  <td>Sales Tax</td>
				  <cfset salesTax = val(subTotal*.07)>
				  <td>#NumberFormat(salesTax,"$___.__")#</td>
				</tr>
				<tr>				
				  <td><strong>Total</strong></td>
				  <td>#NumberFormat(val(subTotal+salesTax),"$___.__")#</td>
				</tr>			
				
			</table>
			
			
			<cfelse>
				<p> Order Status could not be found </p>
			</cfif>
		</cfif>
		
</cfoutput>		
		