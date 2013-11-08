
<cfoutput>

<cfset helperFuncs = application.registry.get("PizzaHelper")>

<button onclick="toggle('cartToggle');">Toggle Cart</button>

<cfset helperFuncs.displayCart()>

</cfoutput>