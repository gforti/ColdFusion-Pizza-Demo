<!--------------------------------------------------------------------
	Easier way to get the command needed
-------------------------------------------------------------------->

<cfcomponent name="CommandFactory">

	<cffunction name="getCommand" access="public" output="true" returntype="any">	
		<cfargument	name="command" type="string" required="true"> 
				
		<cfif NOT IsSimpleValue(Arguments.command)>
			<cfthrow type="InvalidCommandNameException" message="Command Name is not of type string">
		</cfif>
		
		<cfswitch expression="#UCase(Trim(Arguments.command))#">
		
			 <cfcase value="SAUCE,TOPPING,CRUST,SIZE,PIZZA">
				<cfobject name="commandOBJ" component="AbstractManageCommand">
				<cfswitch expression="#UCase(Trim(Arguments.command))#">
					<cfcase value="SAUCE">
						<cfset commandOBJ.DAO = "SaucesDAO">
					</cfcase>
					<cfcase value="TOPPING">
						<cfset commandOBJ.DAO = "ToppingsDAO">
					</cfcase>
					<cfcase value="CRUST">	
						<cfset commandOBJ.DAO = "CrustsDAO">
					</cfcase>
					<cfcase value="SIZE">
						<cfset commandOBJ.DAO = "SizesDAO">
					</cfcase>
					<cfcase value="PIZZA">	
						<cfset commandOBJ.DAO = "PizzasDAO">
					</cfcase>
				</cfswitch>
			 </cfcase>
			 
			 <cfcase value="ORDER,EDITORDER">
				<cfobject name="commandOBJ" component="OrderCommand">
			 </cfcase>
			  <cfcase value="CHECKOUT">
				<cfobject name="commandOBJ" component="CheckoutCommand">
			 </cfcase>
			 			 
			 <cfdefaultcase> 
				<cfthrow type="CommandNotFoundException" message="Command Name is not Valid">
			</cfdefaultcase> 
		</cfswitch> 
		
		<cfreturn commandOBJ>
	</cffunction>

</cfcomponent> 