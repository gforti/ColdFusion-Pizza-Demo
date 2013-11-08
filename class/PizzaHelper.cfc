<!--------------------------------------------------------------------
	Utility functions
-------------------------------------------------------------------->

<cfcomponent name="PizzaHelper">

	<cffunction name="isValidPizzaID" output="false" access="public" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">			
		<cfreturn isValidDAOID(arguments.idval,"PizzasDAO")>
	</cffunction>
	
	<cffunction name="isValidToppingID" output="false" access="public" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">			
		<cfreturn isValidDAOID(arguments.idval,"ToppingsDAO")>
	</cffunction>
	
	<cffunction name="isValidCrustID" output="false" access="public" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">			
		<cfreturn isValidDAOID(arguments.idval,"CrustsDAO")>
	</cffunction>
	
	<cffunction name="isValidSauceID" output="false" access="public" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">			
		<cfreturn isValidDAOID(arguments.idval,"SaucesDAO")>
	</cffunction>
	
	<cffunction name="isValidSizeID" output="false" access="public" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">			
		<cfreturn isValidDAOID(arguments.idval,"SizesDAO")>
	</cffunction>
	
	
	<cffunction name="isValidDAOID" output="false" access="private" returntype="boolean">
			<cfargument name="idVal" type="string" required="true">
			<cfargument name="DAOVal" type="string" required="true">
			
			<cfset arguments.idval = Trim(arguments.idval)>
			<cfif Len(arguments.idval) AND IsQuery(application.registry.get(arguments.DAOVal).read(arguments.idval))>
				<cfreturn true>
			</cfif>
			
		<cfreturn false>
	</cffunction>

	
	
	<cffunction name="pizzaHasTopping" output="false" access="public" returntype="boolean">
		<cfargument name="pizzaIDVal" type="string" required="true">
		<cfargument name="toppingIDVal" type="string" required="true">		
		
		<cfset arguments.pizzaIDVal = Trim(arguments.pizzaIDVal)>
		<cfset arguments.toppingIDVal = Trim(arguments.toppingIDVal)>
		
		<cfif isValidPizzaID(arguments.pizzaIDVal) AND isValidToppingID(arguments.toppingIDVal)>
			<cfset pizzaQuery = application.registry.get("PizzasDAO").read(arguments.pizzaIDVal)>
			<cfif IsDefined("pizzaQuery.TOPPINGS") AND ListFindNoCase(pizzaQuery.TOPPINGS,arguments.toppingIDVal)>
				<cfreturn true>
			</cfif>
		</cfif>
	
		<cfreturn false>
	</cffunction>
	
	
	<!--------------------------------------------------------------------
		Checks the session if order ID is valid
	-------------------------------------------------------------------->
	
	<cffunction name="isValidOrderID" output="false" access="public" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">	
		<cfset cart = application.registry.get("cart")>
		<cfset cartStruct = cart.read(arguments.idval)>
		<cfif isStruct(cartStruct) AND NOT StructIsEmpty(cartStruct)>
			<cfreturn true>
		</cfif>
		<cfreturn false>
	</cffunction>
	
	<cffunction name="isCartEmpty" output="false" access="public" returntype="boolean">
		<cfset cart = application.registry.get("cart")>
		<cfset cartStruct = cart.read()>
		<cfif isStruct(cartStruct) AND NOT StructIsEmpty(cartStruct)>
			<cfreturn false>
		</cfif>
		<cfreturn true>
	</cffunction>
	
	<cffunction name="getCartIDExtraToppingsIDs" output="false" access="public" returntype="string">
		<cfargument name="idVal" type="string" required="true">		
		<cfset returnList = "">
		<cfif isValidOrderID(arguments.idval)>
			<cfset cart = application.registry.get("cart")>
			<cfset cartStruct = cart.read(arguments.idval)>
			<cfset toppingsQuery = application.registry.get("ToppingsDAO").read()>
			
			<cfif IsQuery(toppingsQuery)>
				<cfloop query="toppingsQuery">	
					<cfset topID = "Topping_#ID#">
					<cfif StructKeyExists(cartStruct, topID)>
						<cfset cartTopIDVal = val(cartStruct[topID])>
						<cfloop from="1" to="#val(cartTopIDVal)#" index="i">
							<cfset returnList = ListAppend(returnList, ID)>
						</cfloop>
					</cfif>
				</cfloop>
			</cfif>
			
		</cfif>
		<cfreturn returnList>
	</cffunction>
	
	<cffunction name="getCartIDExtraToppingsNames" output="false" access="public" returntype="string">
		<cfargument name="idVal" type="string" required="true">	
		<cfset returnNameList = "">
		<cfset idList = getCartIDExtraToppingsIDs(arguments.idval)>
		<cfset toppingsDAO = application.registry.get("ToppingsDAO")>
		<cfif ListLen(idList)>
			<cfloop index="topID" list="#idList#">
				<cfset toppingName = " "&toppingsDAO.read(topID).name>
				<cfset hasTopping = ListFindNoCase(returnNameList,toppingName)>
				<cfif hasTopping>					
					<cfset returnNameList = ListDeleteAt(returnNameList, hasTopping)>
					<cfset returnNameList = ListAppend(returnNameList, " Extra"&toppingName)>
				<cfelse>
					<cfset returnNameList = ListAppend(returnNameList, toppingName)>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn returnNameList>
	</cffunction>
	
	
	<cffunction name="displayCart" output="true" access="public" returntype="Void">
		<cfset cart = application.registry.get("cart")>
		<cfset cartStruct = cart.read()>
		<cfset sitePath = application.config.sitePath>
		<cfset thisPage = application.config.currentUrl>
		<cfset PizzasDAO = application.registry.get("PizzasDAO")>
		
		<cfif NOT isCartEmpty()>
			<table width="100%" border="0" id="cartToggle">
			<tr>
			<td width="60%">
			
				<table class="orderTable">
				<caption> <img src="images/Pizza-box.png" /> Your Cart ( #StructCount(cartStruct)# orders) </caption>
				<thead>
					<tr>
						<th></th>
						<th> Order </th> 
						<th> Price </th> 
						<th> Quantity </th>  
						<th> </th>
						<th> </th>
					</tr>
				</thead>
				<tbody>
					<cfset i = 1>
					<cfset subTotal = 0>
					<cfset salesTax = 0>
					<cfloop collection="#cartStruct#" item="cartID">
						<cfset currentCart = cartStruct[cartID]>
										
							<cfif StructKeyExists(currentCart, "PIZZAID") AND isValidPizzaID(currentCart.PIZZAID)>
							<tr>
								<td> #i# </td>
								<td class="noWrap"> #PizzasDAO.read(currentCart.PIZZAID).name# </td>
							
							<cfif StructKeyExists(currentCart, "PRICE")>
								<td> #NumberFormat(val(currentCart.PRICE),"$___.__")# </td>
								<cfset subTotal = val(subTotal+currentCart.PRICE)>
							</cfif>
							
							<cfif StructKeyExists(currentCart, "QUANTITY")>
								<td> #val(currentCart.QUANTITY)# </td>
							</cfif>
							
							<td> <form name="delete" method="post" action="#thisPage#">
								<input type="hidden" name="action" value="ORDER" />
								<input type="hidden" name="orderID" value="#cartID#" />
								<input type="submit" name="submitBtn" value="Delete">
							</form>	</td>
							
							<td> <form name="Modify" method="post" action="#thisPage#">
								<input type="hidden" name="action" value="EDITORDER" />
								<input type="hidden" name="orderID" value="#cartID#" />
								<input type="submit" name="submitBtn" value="Modify">
							</form> </td>
							<cfset i = i+1>
						</tr>
						<cfelse>
							<cfset cart.delete(cartID)>
						</cfif>
					</cfloop>
				</tbody>
			</table>
			
			</td>
			<td width="40%">
				 <table border="0" colspan="5" cellspacing="5">
				<tr>					
				  <td>Subtotal</td>
				  <td>#NumberFormat(subTotal,"$___.__")#</td>
				</tr>
				<tr>					
				  <td>Sales Tax</td>
				  <cfset salesTax = val(subTotal*.07)>
				  <td>#NumberFormat(salesTax,"$___.__")#</td>
				</tr>
				<tr>				
				  <td><strong>Total</strong></td>
				  <td>#NumberFormat(val(subTotal+salesTax),"$___.__")#</td>
				</tr>			
				<tr>					
				  <td colspan="2">
					  <form name="Checkout" method="post" action="#thisPage#">
						<input type="hidden" name="action" value="checkout" />
						<input type="submit" name="submitBtn" value="Checkout">
					</form>
				  </td>
				</tr>
			  </table>

			</td>
			</tr></table>
			
		<cfelse>

			<div id="cartToggle" style="display:none;"> <p><img src="images/icon_pizzabox.gif" /> <big>Your Cart is Empty</big></p></div>
				
		</cfif>

			

	</cffunction>
	

	
	<cffunction name="displayPizzaOrders" output="true" access="public" returntype="Void">
	
		<cfset pizzasQuery = application.registry.get("PizzasDAO").read()>
		<cfset sitePath = application.config.sitePath>
				
		<h3> Pizzas </h3>		
		<cfif IsQuery(pizzasQuery)>
			<ul class="inlineList">			
			<cfloop query="pizzasQuery">
				<li>
					<div class="displayPizza">						
						<strong> #NAME# </strong>						
						<cfif IsDefined("PRICE")>
							<em>Price: <span>#NumberFormat(PRICE,"$__.__")#</span></em>
						</cfif>						
						<a href="#sitePath#?action=order&pizzaid=#id#">Order Now</a>																
						<cfif IsDefined("DESCRIPTION")>
							<span>#DESCRIPTION#</span>
						</cfif>							
					</div>
				</li>
			</cfloop>		
			</ul>
		<cfelse>
			<p> None Available, Please come back </p>
		</cfif>	

	</cffunction>
	
	
	
	
	<cffunction name="displayOrderStatusSearch" output="true" access="public" returntype="Void">
	
		<cfset thisPage = application.config.currentUrl>
		<h3> Check Order Status </h3>
		<p> Have your order number?  Enter it and see the status of your order </p>
		
		<form name="lookup" method="post" action="#thisPage#">
			<input type="hidden" name="action" value="ORDERSTATUS"  />
			<label for="orderD">Order ID:</label> <input type="text" id="LookupOrderID" name="orderID" value="" />
			<input type="submit" name="submitBtn" value="Lookup">
			<div id="errMsg" class="errorMsg" style="display:none;"></div>
		</form>	

	</cffunction>
	
	<!--------------------------------------------------------------------
		Checks the Orders XML if order ID is valid
	-------------------------------------------------------------------->
	
	<cffunction name="isValidOrderStatusID" output="true" access="public" returntype="Boolean">
		<cfargument name="idVal" type="string" required="true">	
		<cfset ordersStruct = application.registry.get("OrdersDAO").read()>
		
		<cfif isStruct(ordersStruct) AND StructKeyExists(ordersStruct, arguments.idval)>
			<cfreturn true>
		</cfif>
		<cfreturn false>

	</cffunction>
	
	
	
	
	<cffunction name="translateExtraToppingsNames" output="false" access="public" returntype="string">
		<cfargument name="idVal" type="string" required="true">	
		
		<cfset idList = Trim(arguments.idval)>
		<cfset returnNameList = "">
		<cfset toppingsDAO = application.registry.get("ToppingsDAO")>
		<cfif ListLen(idList)>
			<cfloop index="topID" list="#idList#">
				<cfif isValidToppingID(topID)>
					<cfset toppingName = " "&toppingsDAO.read(topID).name>
					<cfset hasTopping = ListFindNoCase(returnNameList,toppingName)>
					<cfif hasTopping>					
						<cfset returnNameList = ListDeleteAt(returnNameList, hasTopping)>
						<cfset returnNameList = ListAppend(returnNameList, " Extra"&toppingName)>
					<cfelse>
						<cfset returnNameList = ListAppend(returnNameList, toppingName)>
					</cfif>
				</cfif>
			</cfloop>
		</cfif>
		
		<cfreturn returnNameList>
	</cffunction>
	

</cfcomponent> 