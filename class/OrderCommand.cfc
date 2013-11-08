<!--------------------------------------------------------------------
	Handles orders and processes data or excutes an action depending 
	on the command.
	
	This will add orders to the session cart
-------------------------------------------------------------------->

<cfcomponent name="OrderCommand">
		
	<cffunction name="execute" access="public" output="true" returntype="boolean">		
		<cfargument name="cmdContext" type="CommandContext" required="true">
						
		<cfset formStruct = arguments.cmdContext.get("form")>
		<cfset urlStruct = arguments.cmdContext.get("url")>
		<cfset cart = application.registry.get("cart")>
		
		<cfset submitBtnValue = "">
		<cfset pizzIDValue = "">
		<cfset orderIdValue = "">
		 
		<cfif StructKeyExists(formStruct, "id")>
			<cfset pizzIDValue = formStruct["id"]>
		</cfif>
		
		<cfif StructKeyExists(formStruct, "orderID")>
			<cfset orderIdValue = formStruct["orderID"]>
		</cfif>
		
		<cfif StructKeyExists(formStruct, "submitBtn")>
			<cfset submitBtnValue = UCase(formStruct["submitBtn"])>
		</cfif>
		
		
		<cfif cgi.request_method eq "POST">
		
			<cfswitch expression = "#submitBtnValue#">
				 <cfcase value = "ADD">
											
						<cfset id = hash(CreateUUID())>						
						<cfif NOT cart.add(id, formStruct)>						
							<cfset arguments.cmdContext.setError("Pizza could not be added")>
							<cfreturn false>
						</cfif>
							<cfset arguments.cmdContext.setSuccess("Pizza has been added")>
						
						
				</cfcase>	

				<cfcase value = "DELETE">
																	
						<cfif NOT cart.delete(orderIdValue)>						
							<cfset arguments.cmdContext.setError("Pizza Order could not be deleted")>
							<cfreturn false>
						</cfif>
							<cfset arguments.cmdContext.setSuccess("Pizza Order has been deleted")>
						
						
				</cfcase>
				
				<cfcase value = "EDIT">
																	
						<cfif NOT cart.add(orderIdValue, formStruct)>						
							<cfset arguments.cmdContext.setError("Pizza could not be edited")>
							<cfreturn false>
						</cfif>
							<cfset arguments.cmdContext.setSuccess("Pizza has been edited")>
						
						
				</cfcase>
				
					
			</cfswitch> 
			
			
		</cfif>
		
		<cfset arguments.cmdContext.set("orderIdValue",orderIdValue)>
			
		<cfreturn true> 
	</cffunction>


</cfcomponent>