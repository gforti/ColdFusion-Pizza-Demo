
<!--------------------------------------------------------------------
	This Controller based page controls the flow of the entire 
	application.
-------------------------------------------------------------------->

<cfoutput>

	<cftry>	

		<cfobject name="Controller_Obj" component="Controller">	
		<cfset Controller_Obj.init()>	
		<cfset variables.params = Controller_Obj.getContext()>
		
		<cfset variables.params.set("title","Pizza Parlor")>	
		<cfset variables.params.set("showAdminMenu",true)>	
		<cfset Controller_Obj.process()>
		
				
		<cfcatch type = "Any">
			<p class="errorMsg">There was an error with the system. Please contact the administrator. <br />
			#cfcatch.Type# #cfcatch.Message#</p>
		</cfcatch>
	</cftry>

</cfoutput>	