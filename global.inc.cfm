

	<!--- register all object classes application should be able to access gloabaly --->
	<cfobject name="application.registry" component="class.SingletonRegistry">

	<!--- Pizza DAO classes --->
	<cfobject name="ToppingsDAOObj" component="class.ToppingsDAO">
	<cfobject name="PizzasDAOObj" component="class.PizzasDAO">
	<cfobject name="SaucesDAOObj" component="class.SaucesDAO">
	<cfobject name="SizesDAOObj" component="class.SizesDAO">
	<cfobject name="CrustsDAOObj" component="class.CrustsDAO">
	<cfobject name="OrdersDAOObj" component="class.OrdersDAO">
	
	<!--- other objects used through out application --->
	<cfobject name="CommandFactoryObj" component="class.CommandFactory">
	<cfobject name="PizzaHelperObj" component="class.PizzaHelper">
	<cfobject name="CartSessionObj" component="class.CartSession">
	
	<!--- make sure objects are ready before registering them --->
	<cfset ToppingsDAOObj.init(application.config.xmlPath)>
	<cfset PizzasDAOObj.init(application.config.xmlPath)>
	<cfset SaucesDAOObj.init(application.config.xmlPath)>
	<cfset SizesDAOObj.init(application.config.xmlPath)>
	<cfset CrustsDAOObj.init(application.config.xmlPath)>
	<cfset OrdersDAOObj.init(application.config.xmlPath)>
	
	<cfset CartSessionObj.init()>
	
	<!--- populate registry with global use objects --->
	<cfset application.registry.set("ToppingsDAO",ToppingsDAOObj)>
	<cfset application.registry.set("PizzasDAO",PizzasDAOObj)>	
	<cfset application.registry.set("SaucesDAO",SaucesDAOObj)>
	<cfset application.registry.set("SizesDAO",SizesDAOObj)>
	<cfset application.registry.set("CrustsDAO",CrustsDAOObj)>
	<cfset application.registry.set("OrdersDAO",OrdersDAOObj)>
	
	<cfset application.registry.set("CommandFactory",CommandFactoryObj)>	
	<cfset application.registry.set("PizzaHelper",PizzaHelperObj)>
	<cfset application.registry.set("cart",CartSessionObj)>
	

