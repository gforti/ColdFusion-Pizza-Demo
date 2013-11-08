<!--------------------------------------------------------------------
	Extended class uses generic XML Data Access Object
	Gets XML and converts to a temporay query table
-------------------------------------------------------------------->

<cfcomponent name="PizzasDAO" extends="XMLDAO">
		
	<cfset set("DAOFileName","pizzas.xml")>
	<cfset set("DAOXMLRootName","pizzas")>
	<cfset set("DAOXMLChildName","pizza")>
	<cfset set("DAOXMLNodeList","name,price,toppings,sauce,crust,size,description")>
	<cfset set("DAOQuery",QueryNew(get("DAOXMLAttributesList")&","&get("DAOXMLNodeList"),"VarChar,VarChar,Decimal,VarChar,VarChar,VarChar,VarChar,VarChar"))>
		
</cfcomponent>