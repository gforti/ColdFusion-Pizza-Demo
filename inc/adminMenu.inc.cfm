

<cfset sitePath = application.config.sitePath>

<cfoutput>
	<ul>
		 <li> <a href="#sitePath#?action=sauce">Manage Sauces</a> </li>
		  <li> <a href="#sitePath#?action=topping">Manage Toppings</a> </li>
		  <li> <a href="#sitePath#?action=SIZE">Manage Sizes</a> </li>
		  <li> <a href="#sitePath#?action=CRUST">Manage Crusts</a> </li>
		  <li> <a href="#sitePath#?action=pizza">Manage Pizzas</a> </li>
		  <li> <a href="#sitePath#?action=ORDERS">View Orders</a> </li>
	  
	</ul>
	<div id="adminMenuTitle"> Admin Menu </div>
</cfoutput>