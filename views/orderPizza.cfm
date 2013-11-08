

<cfoutput>

	<cfset urlStruct = variables.context.get("url")>
	<cfset pizzasQuery = application.registry.get("PizzasDAO").read()>

	<cfset pizzaIDValue = "">
			 
	<cfif StructKeyExists(urlStruct, "pizzaid")>
		<cfset pizzaIDValue = urlStruct["pizzaid"]>
	</cfif>
	
	<cfset ToppingsDAO = application.registry.get("ToppingsDAO")>
	<cfset SaucesDAO = application.registry.get("SaucesDAO")>
	<cfset SizesDAO = application.registry.get("SizesDAO")>
	<cfset CrustsDAO = application.registry.get("CrustsDAO")>
	<cfset PizzasDAO = application.registry.get("PizzasDAO")>
	<cfset helperFuncs = application.registry.get("PizzaHelper")>

	<cfset toppingsQuery = ToppingsDAO.read()>
	<cfset SaucesQuery = SaucesDAO.read()>
	<cfset sizesQuery = SizesDAO.read()>
	<cfset crustsQuery = CrustsDAO.read()>
	<cfset pizzasQuery = PizzasDAO.read()>
		
	
	<cfset thisPage = application.config.currentUrl>
	<cfset pageAction = "ORDER">
	
	 <h1> <img src="images/pizza_icon.png" /> Order </h1>
	 
	 <cfif Len(variables.context.getSuccess())>
		<p class="sucessMsg">#variables.context.getSuccess()#</p>
	</cfif>
	
	<cfif Len(variables.context.getError())>
		<p class="errorMsg">#variables.context.getError()#</p>
	</cfif>
	
	<!--- display a Pizza to order --->
	<cfif NOT helperFuncs.isValidPizzaID(pizzaIDValue)>
		
		<p> To start choose a Pizza and click order now.  Then fill out the order form on the following page. </p>
		<cfset helperFuncs.displayPizzaOrders()>
		
	</cfif>
	
	
	
	<cfif helperFuncs.isValidPizzaID(pizzaIDValue)>
	
		<form name="addOrder" method="post" action="#thisPage#">
		
		<cfset pizzaQuery = PizzasDAO.read(pizzaIDValue)>
		
		<dl>
		<dt> <h2>#pizzaQuery.name# Pizza</h2> </dt>		
		
		<cfif IsDefined("pizzaQuery.SAUCE") AND helperFuncs.isValidSauceID(pizzaQuery.SAUCE)>
			<dd><strong>Sauce:</strong> #SaucesDAO.read(pizzaQuery.SAUCE).name#</dd>
		</cfif>
		<cfif IsDefined("pizzaQuery.SIZE") AND helperFuncs.isValidSizeID(pizzaQuery.SIZE)>
			<dd><strong>Size:</strong> #SizesDAO.read(pizzaQuery.SIZE).name# (#SizesDAO.read(pizzaQuery.SIZE).inches#")</dd>
		</cfif>
		<cfif IsDefined("pizzaQuery.CRUST") AND helperFuncs.isValidCrustID(pizzaQuery.CRUST)>
			<dd><strong>Crust:</strong> #CrustsDAO.read(pizzaQuery.CRUST).name#</dd>
		</cfif>		
		
		<cfif IsDefined("pizzaQuery.TOPPINGS") AND ListLen(pizzaQuery.TOPPINGS)>
			<cfset toppingsList = "">
			<cfloop index = "ListElement" list = "#pizzaQuery.TOPPINGS#">
				<cfif helperFuncs.isValidToppingID(ListElement)>
					<cfset toppingsList = ListAppend(toppingsList, ToppingsDAO.read(ListElement).name)>
				</cfif>
			</cfloop>
			<dd><strong>Current Topping(s):</strong> #toppingsList#</dd>
		</cfif>		
		<cfif IsDefined("pizzaQuery.PRICE")>
			<dd><strong>Price Per Pizza:</strong> #NumberFormat(pizzaQuery.PRICE,"$__.__")# </dd>
		</cfif>	
		
		</dl>
		
		<p>
			<label for="Quantity">Quantity: </label>
			<input id="Quantity" type="text" name="Quantity" value="1" size="2" readonly="readonly"/> 
			<input type="button" name="subQty" value="-" onclick="subToQty()"> 
			<input type="button" name="addQty" value="+" onclick="addToQty()">
		</p>		
		
		
		
	<table class="orderTable">
		<caption> Extra Toppings </caption>
		<thead>
			<tr>
				<th> Topping </th>
				<th> Price Per Topping</th>
				<th> Extra Amount </th>
			</tr>
		</thead>
		<tbody>			
			<cfif IsQuery(toppingsQuery)>			
				<cfloop query="toppingsQuery">		
				<tr>
					<td>#NAME# </td>
					<td> #NumberFormat(PRICE,"$__.__")# </td>
					<td>
					<select id="Topping_#ID#" name="Topping_#ID#" onchange="CalculateOrderTotal();">
						<cfset topLimit = val(LIMIT)>
						<cfif helperFuncs.pizzaHasTopping(pizzaIDValue,ID)>
							<cfset topLimit = val(topLimit-1)>
						</cfif>
						<cfloop from="0" to="#val(topLimit)#" index="i">
							<option value="#i#">#i#</option>
						</cfloop>						
					</select>
					</td>
				</tr>
				</cfloop>							
			<cfelse>
				<tr>
					<td colspan="10"> No Extra Toppings Available </td>
				</tr>	
			</cfif>
			</tbody>
		</table>
		
			<input type="hidden" name="action" value="#pageAction#" />
			<input type="hidden" name="pizzaID" value="#pizzaIDValue#" />
		
			<p>
				<label for="price">Total Price: $</label> <input id="price" type="text" name="price" value="#val(pizzaQuery.PRICE)#" readonly="readonly"/>
				<input type="submit" name="submitBtn" value="Add">
			</p>
				
		</form>
		<br />
		
		
		<script Language="JavaScript">
			var toppingIDs = [];
			var pizzaAmt = #val(pizzaQuery.PRICE)#;
			 <cfif IsQuery(toppingsQuery)>	
				 <cfloop query="toppingsQuery">
				  toppingIDs['Topping_#ID#'] = '#val(PRICE)#';
				 </cfloop>
			</cfif>
		</script>
		
	
	</cfif>
	
</cfoutput>