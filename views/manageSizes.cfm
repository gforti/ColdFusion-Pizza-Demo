<cfoutput>

	<h1> <img src="images/veggie2.jpg" /> Manage Pizza Sizes </h1>
	<p> Please Note to Edit, just re-enter the name of the item and it will overwrite the current configured item </p>
		<cfset DAOQuery = application.registry.get("SizesDAO").read()>
		<cfset thisPage = application.config.currentUrl>
		<cfset pageAction = "SIZE">
		
		<cfif Len(variables.context.getSuccess())>
			<p class="sucessMsg">#variables.context.getSuccess()#</p>
		</cfif>
		
		<cfif Len(variables.context.getError())>
			<p class="errorMsg">#variables.context.getError()#</p>
		</cfif>
		
		<table class="orderTable">
			<caption> Current Sizes </caption>
				<thead>
					<tr>
					<th> Name </th>
					<th> Size of Pizza </th>					
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
					<cfif IsDefined("inches")> #Val(inches)#" </cfif>	
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
				<label for="inches">Size of Pizza:</label> <br /> <input id="inches" type="text" name="inches" value="16" /> (Inches) <br />
				<label for="description">Description:</label> <br /> <textarea id="description" name="description"></textarea> <br />
				<input type="hidden" name="action" value="#pageAction#" />
				<input type="submit" name="submitBtn" value="Add">
			</fieldset>
		</form>	
		
	
	</cfoutput>