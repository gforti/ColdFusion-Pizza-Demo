<!--------------------------------------------------------------------
	Extended class uses generic XML Data Access Object
	Gets XML and converts to a temporay query table
-------------------------------------------------------------------->

<cfcomponent name="SaucesDAO" extends="XMLDAO">

	<cfset set("DAOFileName","Sauces.xml")>
	<cfset set("DAOXMLRootName","Sauces")>
	<cfset set("DAOXMLChildName","Sauce")>
	<cfset set("DAOXMLNodeList","name,price,description")>
	<cfset set("DAOQuery",QueryNew(get("DAOXMLAttributesList")&","&get("DAOXMLNodeList"),"VarChar,VarChar,Decimal,VarChar"))>	
	
</cfcomponent>