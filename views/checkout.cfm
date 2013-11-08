

<cfoutput>

	 <h1> <img src="images/Tomato.jpg" /> CheckOut </h1>
	 
	 
	<cfset cart = application.registry.get("cart")>
	<cfset cartStruct = cart.read()>

	<cfset ToppingsDAO = application.registry.get("ToppingsDAO")>
	<cfset SaucesDAO = application.registry.get("SaucesDAO")>
	<cfset SizesDAO = application.registry.get("SizesDAO")>
	<cfset CrustsDAO = application.registry.get("CrustsDAO")>
	<cfset PizzasDAO = application.registry.get("PizzasDAO")>	
	<cfset helperFuncs = application.registry.get("PizzaHelper")>
	<cfset sitePath = application.config.sitePath>
	<cfset thisPage = application.config.currentUrl>

	
	<cfif Len(variables.context.getSuccess())>
		<p class="sucessMsg">#variables.context.getSuccess()#</p>
	</cfif>
	
	<cfif Len(variables.context.getError())>
		<p class="errorMsg">#variables.context.getError()#</p>
	</cfif>
		
	
	<cfif NOT helperFuncs.isCartEmpty()>

		<p> Make your final review before finishing your order. </p>
	
		<h3> Review Order </h3>
		
		<table class="orderTable">
		<caption> <img src="images/Pizza-box.png" /> Your Cart ( #StructCount(cartStruct)# orders) </caption>
		<thead>
			<tr>
				<th></th>
				<th> Order </th> 
				<th> Price </th> 
				<th> Quantity </th> 
				<th> Details </th> 
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
			<cfset PizzaQuery = PizzasDAO.read(currentCart.PIZZAID)>
				<cfif StructKeyExists(currentCart, "PIZZAID") AND helperFuncs.isValidPizzaID(currentCart.PIZZAID)>
				<tr>
					<td> #i# </td>
					<td class="noWrap"> #PizzaQuery.name# </td>
				
				<td class="noWrap">
				<cfif StructKeyExists(currentCart, "PRICE")>
					 #NumberFormat(val(currentCart.PRICE),"$___.__")# 
					<cfset subTotal = val(subTotal+currentCart.PRICE)>
				</cfif>
				</td>
				
				<td>
				<cfif StructKeyExists(currentCart, "QUANTITY")>
					 #val(currentCart.QUANTITY)# 
				</cfif>
				</td>
				
				<td>				
					<cfif IsDefined("PizzaQuery.SAUCE") AND helperFuncs.isValidSauceID(PizzaQuery.SAUCE)>
						 #SaucesDAO.read(PizzaQuery.SAUCE).name# <br />
					</cfif>
					
					<cfif IsDefined("PizzaQuery.SIZE") AND helperFuncs.isValidSizeID(PizzaQuery.SIZE)>
						#SizesDAO.read(PizzaQuery.SIZE).name# <small>(#Trim(SizesDAO.read(PizzaQuery.SIZE).inches)#")</small> <br />
					</cfif>
					
					<cfif IsDefined("PizzaQuery.CRUST") AND helperFuncs.isValidCrustID(PizzaQuery.CRUST)>
						 #CrustsDAO.read(PizzaQuery.CRUST).name# <br />
					</cfif>
					
					<cfif IsDefined("PizzaQuery.TOPPINGS") AND ListLen(PizzaQuery.TOPPINGS)>
						<cfset toppingsList = "">
						<cfloop index = "ListElement" list = "#PizzaQuery.TOPPINGS#">
							<cfif helperFuncs.isValidToppingID(ListElement)>
								<cfset toppingsList = ListAppend(toppingsList, " #ToppingsDAO.read(ListElement).name#")>
							</cfif>
						</cfloop>
						<strong>Toppings: </strong>#toppingsList# <br />
					</cfif>	
					<strong>Extra Toppings: </strong> #helperFuncs.getCartIDExtraToppingsNames(cartID)#<br />
				</td>
				
				<td> 
					<form name="delete" method="post" action="#thisPage#">
						<input type="hidden" name="action" value="ORDER" />
						<input type="hidden" name="orderID" value="#cartID#" />
						<input type="submit" name="submitBtn" value="Delete">
					</form>	
				</td>
				
				<td> 
					<form name="Modify" method="post" action="#thisPage#">
						<input type="hidden" name="action" value="EDITORDER" />
						<input type="hidden" name="orderID" value="#cartID#" />
						<input type="submit" name="submitBtn" value="Modify">
					</form> 
				</td>
				<cfset i = i+1>
			</tr>
			<cfelse>
				<cfset cart.delete(cartID)>
			</cfif>
		</cfloop>
		</tbody>
		<tfoot>

		<tr>
			<td colspan="6" align="right">Subtotal</td>
			<td>#NumberFormat(subTotal,"$___.__")#</td>
		</tr>
		
		<tr>
			<td colspan="6" align="right">Sales Tax</td>
			<cfset salesTax = val(subTotal*.07)>
			<td>#NumberFormat(salesTax,"$___.__")#</td>
		</tr>
		
		<tr>			
		  <td colspan="6" align="right"><strong>Total</strong></td>
		  <td>#NumberFormat(val(subTotal+salesTax),"$___.__")#</td>
		</tr>
		
		<tr>			
		  <td colspan="10" align="right">
			  <form name="Add Order" method="post" action="#thisPage#">
				<input type="hidden" name="action" value="Order" />
				<input type="submit" name="submitBtn" value="Add Order">
			</form>
		  </td>
		</tr>
		
	  </tfoot>

		</table>
		
		
		
		<h3> Final Step </h3>
		
		<p> <strong> What to know before placing your order: </strong> </p>
		<ul> 
			<li> Your order is guaranteed to be ready in 30 minutes or it's free! </li>
			<li> All Orders are Pick up Only! </li>
			<li> Payment is expected upon pickup </li>
			<li> An order ID will display upon placing your order.  Be sure write it down to track the status of your order. </li>
		</ul>
		<strong> Pickup location:</strong>
		<blockquote>
			<address>
			Pizza Company <br />
			204 Main Street <br />
			Providence, RI 02903 <br />
			Tel: 401.555.1212
			</address>			
		</blockquote>
		
		
		<form name="finish" method="post" action="#thisPage#">
			
			<fieldset>			
				<p> Please enter your name and phone number to complete the order </p>
				
				<label for="contact">Contact Name</label> <br />
				<input type="text" id="contact" name="contact" value="" /> <br />
				<label for="phone">Phone:</label> <br />
				<input type="text" id="phone" name="phone" value="" /> <br />
					
				<input type="hidden" name="action" value="CHECKOUT" />
				<input type="submit" name="submitBtn" value="Finish">
				<div id="errMsg" class="errorMsg" style="display:none;"></div>
			</fieldset>
		</form>
		
	<cfelse>

		<p><img src="images/icon_pizzabox.gif" /> <big>Your Cart is Empty</big></p>


	</cfif>

	 
</cfoutput>