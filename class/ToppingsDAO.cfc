
<!--------------------------------------------------------------------
	Extended class uses generic XML Data Access Object
	Gets XML and converts to a temporay query table
-------------------------------------------------------------------->

<cfcomponent name="ToppingsDAO" extends="XMLDAO">

	<cfset set("DAOFileName","toppings.xml")>
	<cfset set("DAOXMLRootName","toppings")>
	<cfset set("DAOXMLChildName","topping")>
	<cfset set("DAOXMLNodeList","name,price,limit,description")>
	<cfset set("DAOQuery",QueryNew(get("DAOXMLAttributesList")&","&get("DAOXMLNodeList"),"VarChar,VarChar,Decimal,Integer,VarChar"))>
	
</cfcomponent>