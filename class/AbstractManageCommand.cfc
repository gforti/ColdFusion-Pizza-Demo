<!--------------------------------------------------------------------
	These commands are the same for all the admin management processes
-------------------------------------------------------------------->

<cfcomponent name="AbstractManageCommand">

	<cfset This.DAO = "">
		
	<cffunction name="execute" access="public" output="true" returntype="boolean">		
		<cfargument name="cmdContext" type="CommandContext" required="true">
						
		<cfset formStruct = arguments.cmdContext.get("form")>
		<cfset submitBtnValue = "">
		 
		<cfif StructKeyExists(formStruct, "submitBtn")>
			<cfset submitBtnValue = UCase(formStruct["submitBtn"])>
		</cfif>
		
		<cfset NameVal = "">
		<cfif StructKeyExists(formStruct, "NAME")>
			<cfset NameVal = "<strong>#formStruct.NAME#</strong>">
		</cfif>	
		<cfif cgi.request_method eq "POST">
		
			<cfswitch expression = "#submitBtnValue#">
				 <cfcase value = "ADD">
									
					<cfif StructKeyExists(formStruct, "price")>
						<cfset formStruct["price"] = val(formStruct["price"])>
					</cfif>
					<cfif StructKeyExists(formStruct, "inches")>
						<cfset formStruct["inches"] = val(formStruct["inches"])>
					</cfif>
					<cfif StructKeyExists(formStruct, "limit")>
						<cfset formStruct["limit"] = val(formStruct["limit"])>
					</cfif>
					<cfif NOT application.registry.get(This.DAO).create(formStruct)>					
						<cfset arguments.cmdContext.setError("#NameVal# could not be added")>
						<cfreturn false>						
					</cfif>
					<cfset arguments.cmdContext.setSuccess("#NameVal# has been added")>
					
				</cfcase>
				
				 <cfcase value = "DELETE">
					
					<cfif NOT StructKeyExists(formStruct, "ID")>
						<cfset arguments.cmdContext.setError("#NameVal# could not be Deleted")>
						<cfreturn false>	
					</cfif>
					<cfif NOT application.registry.get(This.DAO).delete(formStruct.ID)>
						<cfset arguments.cmdContext.setError("#NameVal# could not be Deleted")>
						<cfreturn false>	
					</cfif>
					<cfset arguments.cmdContext.setSuccess("#NameVal# has been Deleted")>
					
				</cfcase>
				
			</cfswitch> 
			
			<cfset application.registry.get(This.DAO).save()>
		</cfif>
			
		<cfreturn true> 
	</cffunction>


</cfcomponent>