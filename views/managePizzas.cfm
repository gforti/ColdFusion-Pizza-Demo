<cfoutput>

	<h1> <img src="images/Pizzaslice.jpg" /> Manage Pizzas </h1>
		<p> Please Note to Edit, just re-enter the name of the item and it will overwrite the current configured item </p>
	
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
		<cfset thisPage = application.config.currentUrl>
		<cfset pageAction = "pizza">
		
		
		<cfif Len(variables.context.getSuccess())>
			<p class="sucessMsg">#variables.context.getSuccess()#</p>
		</cfif>
		
		<cfif Len(variables.context.getError())>
			<p class="errorMsg">#variables.context.getError()#</p>
		</cfif>
		
			
			
			<table class="orderTable">
				<caption> Current Pizzas </caption>
				<thead>
					<tr>
						<th> Pizza </th> 
						<th> Price</th> 
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
					
					<td class="noWrap">					
						<cfif IsDefined("PRICE")> #NumberFormat(PRICE,"$__.__")# </cfif>	
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
					
					<td>
						<cfif IsDefined("DESCRIPTION")>#DESCRIPTION#</cfif>
					</td>
					
					<td>	
						<form name="delete" method="post" action="#thisPage#">
							<input type="hidden" name="action" value="#pageAction#" />
							<input type="hidden" name="name" value="#NAME#" />
							<input type="hidden" name="ID" value="#ID#" />
							<input type="submit" name="submitBtn" value="Delete">
						</form>						
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
			
		
		
		
		<form name="add" method="post" action="#thisPage#">			
			<fieldset>
				<legend>Add/Edit</legend>
				<label for="name">Name:</label> <br /> <input id="name" type="text" name="name" value="" /> <br />
				<label for="price">Price:</label> <br /> <input id="price" type="text" name="price" value="" /> <br />
				<br />
				
				<label>Select One Sauce:<label>
				<cfif IsQuery(SaucesQuery)>					
					<ol>			
					<cfloop query="SaucesQuery">		
						<li> <input type="radio" name="sauce" value="#ID#" /> #NAME# </li>			
					</cfloop>
					</ol>					
				<cfelse>
					<p> No Sauces </p>
				</cfif>
				
				<label>Toppings: </label>
				<cfif IsQuery(toppingsQuery)>					
					<ol>			
					<cfloop query="toppingsQuery">		
						<li> <input type="checkbox" name="toppings" value="#ID#" /> #NAME# </li>			
					</cfloop>
					</ol>					
				<cfelse>
					<p> No Toppings </p>
				</cfif>
				
				<label>Select One Size: </label>
				<cfif IsQuery(sizesQuery)>					
					<ol>			
					<cfloop query="sizesQuery">		
						<li> <input type="radio" name="size" value="#ID#" /> #NAME# (#inches#") </li>			
					</cfloop>
					</ol>					
				<cfelse>
					<p> No Sizes </p>
				</cfif>
				
				<label>Select One Crust: </label>
				<cfif IsQuery(crustsQuery)>					
					<ol>			
					<cfloop query="crustsQuery">		
						<li> <input type="radio" name="crust" value="#ID#" /> #NAME# </li>			
					</cfloop>
					</ol>					
				<cfelse>
					<p> No Crusts </p>
				</cfif>
								
				
				
				<label for="description">Description:</label> <br /> <textarea id="description" name="description"></textarea> <br />
				<input type="hidden" name="action" value="#pageAction#" />
				<input type="submit" name="submitBtn" value="Add">
			</fieldset>
		</form>	
		
	
	</cfoutput>