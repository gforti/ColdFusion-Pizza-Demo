
<cfoutput>

	<h1> <img src="images/food-icon.png" /> Menu </h1>
		
		<cfset ToppingsDAO = application.registry.get("ToppingsDAO")>
		<cfset SaucesDAO = application.registry.get("SaucesDAO")>
		<cfset SizesDAO = application.registry.get("SizesDAO")>
		<cfset CrustsDAO = application.registry.get("CrustsDAO")>
		<cfset PizzasDAO = application.registry.get("PizzasDAO")>
		
		<cfset toppingsQuery = ToppingsDAO.read()>
		<cfset SaucesQuery = SaucesDAO.read()>
		<cfset sizesQuery = SizesDAO.read()>
		<cfset crustsQuery = CrustsDAO.read()>
		<cfset pizzasQuery = PizzasDAO.read()>
		
		<cfset helperFuncs = application.registry.get("PizzaHelper")>
		<cfset sitePath = application.config.sitePath>
		
		
		
					
		<h3> Pizzas </h3>		
		
		<table class="orderTable">
				<thead>
					<tr>
						<th> Pizza </th> 
						<th> Price Per Pizza</th> 
						<th> Sauce </th>  
						<th> Size </th> 
						<th> Crust </th>
						<th> Toppings </th>
						<th> Description </th>
						<th> </th>
					</tr>
				</thead>
				<tbody>	
		<cfif IsQuery(pizzasQuery)>
				
			<cfloop query="pizzasQuery">
				<tr>
					
					<td class="noWrap">#NAME# </td>
					
					<td>					
						<cfif IsDefined("PRICE")> #NumberFormat(PRICE,"$___.__")# </cfif>	
					</td>
					
					<td>
						<cfif IsDefined("SAUCE") AND helperFuncs.isValidSauceID(SAUCE)>	 #SaucesDAO.read(SAUCE).name# </cfif>
					</td>
					
					<td class="noWrap">
						<cfif IsDefined("SIZE") AND helperFuncs.isValidSizeID(SIZE)>
							#SizesDAO.read(SIZE).name# <small>(#Trim(SizesDAO.read(SIZE).inches)#")</small> 
						</cfif>
					</td>
					
					<td>
						<cfif IsDefined("CRUST") AND helperFuncs.isValidCrustID(CRUST)> #CrustsDAO.read(CRUST).name# </cfif>
					</td>
					
					<td>
					<cfif IsDefined("TOPPINGS") AND ListLen(TOPPINGS)>
						<cfset toppingsList = "">
						<cfloop index = "ListElement" list = "#TOPPINGS#">
							<cfif helperFuncs.isValidToppingID(ListElement)>
								<cfset toppingsList = ListAppend(toppingsList, " #ToppingsDAO.read(ListElement).name#")>
							</cfif>
						</cfloop>
						 #toppingsList# 
					</cfif>	
					</td>
					
					
					<td>	<a href="#sitePath#?action=order&pizzaid=#id#" class="buttonLink">Order Now</a> 
					
					</td>
				</tr>
				</cfloop>		
						
		<cfelse>
			<tr>
			<td colspan="10"> None Available </td>
			</tr>
		</cfif>
		
		</tbody>
	</table>
		
		<h3> Sauces</h3> 
		<cfif IsQuery(SaucesQuery)>
			
			<ul>			
			<cfloop query="SaucesQuery">		
				<li>  #NAME# </li>			
			</cfloop>
			</ul>
			
		<cfelse>
			<p> No Sauces </p>
		</cfif>
		
		<h3> Crusts</h3> 
		<cfif IsQuery(crustsQuery)>
			
			<ul>			
			<cfloop query="crustsQuery">		
				<li>  #NAME# </li>			
			</cfloop>
			</ul>
			
		<cfelse>
			<p> No Crusts </p>
		</cfif>
		
		<h3> Sizes</h3> 
		<cfif IsQuery(sizesQuery)>
			
			<ul>			
			<cfloop query="sizesQuery">		
				<li>  #NAME# (#inches#") </li>			
			</cfloop>
			</ul>
			
		<cfelse>
			<p> No Sizes </p>
		</cfif>
		
		<h3> Extra Toppings </h3> 
		<table class="orderTable">
				<thead>
					<tr>
						<th> Topping </th> <th> Price Per Topping</th> <th> Limit Per Pizza </th>
					</tr>
				</thead>
				<tbody>		
		<cfif IsQuery(toppingsQuery)>
			
				<cfloop query="toppingsQuery">
					<tr>
						<td>#NAME# </td>
						<td><cfif IsDefined("PRICE")> #NumberFormat(PRICE,"$___.__")# </cfif></td>					
						<td> <cfif IsDefined("LIMIT")>#LIMIT#</cfif></td>
					</tr>
				</cfloop>
					
		<cfelse>
			<tr>
			<td colspan="10"> No Extra Toppings </td>
			</tr>
		</cfif>
		
		</tbody>
	</table>
</cfoutput>