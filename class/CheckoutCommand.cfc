<!--------------------------------------------------------------------
	Handles orders and processes data or excutes an action depending 
	on the command.
	
	This will save orders into the xml file, and clear the session
-------------------------------------------------------------------->

<cfcomponent name="CheckoutCommand">
		
	<cffunction name="execute" access="public" output="true" returntype="boolean">		
		<cfargument name="cmdContext" type="CommandContext" required="true">
						
		<cfset formStruct = arguments.cmdContext.get("form")>
		<cfset urlStruct = arguments.cmdContext.get("url")>
		<cfset cart = application.registry.get("cart")>
		<cfset helperFuncs = application.registry.get("PizzaHelper")>
		
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
				 <cfcase value = "FINISH">
					
					<cfset cartOrders = cart.read()>
					
					<cfif NOT IsStruct(cartOrders) OR StructIsEmpty(cartOrders)>
						<cfset arguments.cmdContext.setError("Order could not be completed. Cart is empty.")>
						<cfreturn false>
					</cfif>
										
					<cfset pizzasStruct = structNew()>
					
					<!--- lets prepare the pizza struct correctly --->
					<cftry>
						<cfloop collection="#cartOrders#" item="cartID">
							
							<cfset currentStructVal = cartOrders[cartID]>
							<cfset pizzasStruct[cartID] = structNew()>
							
							<cfset pizzasStruct[cartID]["pizzaID"] = currentStructVal.PIZZAID>
							<cfset pizzasStruct[cartID]["pizzaPrice"] = currentStructVal.PRICE>
							<cfset pizzasStruct[cartID]["pizzaQty"] = currentStructVal.QUANTITY>
							<cfset pizzasStruct[cartID]["pizzaExtraToppings"] = Duplicate(helperFuncs.getCartIDExtraToppingsIDs(cartID))>
						
						</cfloop>
						
						<cfcatch type = "Any">
							<cfset arguments.cmdContext.setError("Pizza order data is not valid. Cart has been deleted")>
							<cfset cart.clearCart()>
							<cfreturn false>
						</cfcatch>
					</cftry>
				
					<cfif NOT IsStruct(pizzasStruct) OR StructIsEmpty(pizzasStruct)>
						<cfset arguments.cmdContext.setError("Pizza order data is not valid. Cart has been delete")>
						<cfset cart.clearCart()>
						<cfreturn false>
					</cfif>
					
					
					<!--- everything looks good so lets finish the struct and save it into orders XML --->
					
					<cfset orderStruct = structNew()>
					<cfset id = left(hash(CreateUUID()),10)>
					<cfset datetime = Now()>
					
					<cfset StructInsert(orderStruct, "id", Duplicate(id),1)>					
					<cfset StructInsert(orderStruct, "datetime", Duplicate(datetime),1)>
					<cfset StructInsert(orderStruct, "processeddatetime", "",1)>
					<cfset StructInsert(orderStruct, "status", "0" ,1)>					
					<cfif StructKeyExists(formStruct, "contact")>
						<cfset StructInsert(orderStruct, "contact", Duplicate(formStruct["contact"]),1)>
					</cfif>					
					<cfif StructKeyExists(formStruct, "phone")>
						<cfset StructInsert(orderStruct, "phone", Duplicate(formStruct["phone"]),1)>
					</cfif>					
					<cfset StructInsert(orderStruct, "pizzas", Duplicate(pizzasStruct),1)>
										
					<cfif NOT application.registry.get("OrdersDAO").create(orderStruct)>					
						<cfset arguments.cmdContext.setError("Order could not be completed.")>
						<cfreturn false>						
					</cfif>
										
					<cfset time = TimeFormat(DateAdd("n", 30, datetime))>
					<cfset arguments.cmdContext.setSuccess("Your order has been completed. <br /> Your order ID is <em>#id#</em> <br /> Your order will be ready by #time#.")>
					<cfset cart.clearCart()>
					
											
				</cfcase>	

							
			</cfswitch> 
			
			<cfset application.registry.get("OrdersDAO").save()>
		</cfif>
			
		<cfreturn true> 
	</cffunction>


</cfcomponent>