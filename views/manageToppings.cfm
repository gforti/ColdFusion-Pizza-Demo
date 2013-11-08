<cfoutput>

	<h1> <img src="images/Meat.jpg" /> Manage Pizza Toppings </h1>
		<p> Please Note to Edit, just re-enter the name of the item and it will overwrite the current configured item </p>
		
		<cfif Len(variables.context.getSuccess())>
			<p class="sucessMsg">#variables.context.getSuccess()#</p>
		</cfif>
		
		<cfif Len(variables.context.getError())>
			<p class="errorMsg">#variables.context.getError()#</p>
		</cfif>
		
		<cfset DAOQuery = application.registry.get("ToppingsDAO").read()>
		<cfset thisPage = application.config.currentUrl>
		<cfset pageAction = "Topping">
		
		<table class="orderTable">
			<caption> Current Toppings </caption>
				<thead>
					<tr>
					<th> Name </th>
					<th> Price </th>
					<th> Limit Per Pizza </th>					
					<th> Description </th>
					<th> </th>
					</tr>
				</thead>
				<tbody>	
		
		
		<cfif IsQuery(DAOQuery)>
					
			<cfloop query="DAOQuery">		
				<tr>
					
					<td class="noWrap">#NAME# </td>
					
					<td>					
						<cfif IsDefined("PRICE")> #NumberFormat(PRICE,"$___.__")# </cfif>	
					</td>
					
					<td>
						<cfif IsDefined("LIMIT")>#LIMIT#</cfif>
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
				<label for="price">Price:</label> <br /> <input id="price" type="text" name="price" value=".75" /> <br />
				<label for="limit">Limit Per Pizza:</label> <br /> <input id="limit" type="text" name="limit" value="2" /> <br />
				<label for="description">Description:</label> <br /> <textarea id="description" name="description"></textarea> <br />
				<input type="hidden" name="action" value="#pageAction#" />
				<input type="submit" name="submitBtn" value="Add">
			</fieldset>
		</form>	
		
	
	</cfoutput>