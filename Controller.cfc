

<cfcomponent name="Controller">

	<cfset variables.context = "">	
	
	<cffunction name="init" access="public" output="false"  returntype="Void">     
		<cfobject name="variables.context" component="class.CommandContext">
		<cfset variables.context.init()>
	</cffunction>

	<cffunction name="getContext" output="false" access="public" returntype="any">
		<cfreturn variables.context>
	</cffunction>
	
	<cffunction name="process" output="true" access="public" returntype="any">
		<cftry>
			<cfset cmd = application.registry.get("CommandFactory").getCommand(variables.context.get("action"))>
			<cfset cmd.execute(variables.context)>			
			<cfset displayView()>
		
			<cfcatch type = "CommandNotFoundException">
				<!--- Display page --->
				<cfset displayView()>
			</cfcatch>
			<cfcatch type = "Any">
				<cfset variables.context.setError("An error occurred: #cfcatch.Message#.<br />Please contact the administrator.")>
				<cfset displayErrorView()>
			</cfcatch>
		</cftry>
		
	</cffunction>
	
	<cffunction name="displayView" output="true" access="private" returntype="Void">
		
		<cfset setView()>
		
		<cfset fileName = iif(Len(variables.context.get("view")),de(variables.context.get("view")),de(application.config.mainFileName))>
		<cfset folderName = application.config.mainFolder>
				
		<cfinclude template="inc/header.inc.cfm">					
		<cfinclude template="#folderName#/#fileName#.cfm">
		<cfinclude template="inc/footer.inc.cfm">
	</cffunction>
	
	
	<cffunction name="displayErrorView" output="true" access="private" returntype="Void">
				
		<cfif Len(variables.context.getError())>
			<p class="errorMsg">#variables.context.getError()#</p>
		</cfif>
		
	</cffunction>
	
	<cffunction name="setView" output="true" access="private" returntype="Void">
				
		<cfset pageView = "">
		<cfset showAdminMenu = variables.context.get("showAdminMenu")> 
		
		<cfswitch expression="#UCase(Trim(variables.context.get("action")))#">
			<cfcase value="SAUCE">
				<cfset pageView = "manageSauces">				
			</cfcase>
			<cfcase value="TOPPING">
				<cfset pageView = "manageToppings">	
			</cfcase>
			<cfcase value="CRUST">
				<cfset pageView = "manageCrusts">	
			</cfcase>
			<cfcase value="SIZE">
				<cfset pageView = "manageSizes">	
			</cfcase>
			<cfcase value="PIZZA">
				<cfset pageView = "managePizzas">	
			</cfcase>
			<cfcase value="PIZZAMENU">	
				<cfset pageView = "pizzaMenu">
			</cfcase>
			<cfcase value="ORDER">	
				<cfset pageView = "orderPizza">
			</cfcase>
			<cfcase value="EDITORDER">	
				<cfset pageView = "editOrderPizza">
			</cfcase>
			<cfcase value="CHECKOUT">	
				<cfset pageView = "checkout">
			</cfcase>
			<cfcase value="ORDERSTATUS">	
				<cfset pageView = "orderStatus">
			</cfcase>
			<cfcase value="ORDERS">	
				<cfset pageView = "manageOrders">
			</cfcase>
			
			
		</cfswitch>
		<cfset variables.context.set("view",pageView)>
		<cfset variables.context.set("showAdminMenu",showAdminMenu)>
		
	</cffunction>
	
</cfcomponent> 