<!--------------------------------------------------------------------
	Extended class uses generic XML Data Access Object
	Gets XML and converts to a temporay query table
-------------------------------------------------------------------->

<cfcomponent name="SizesDAO" extends="XMLDAO">

	<cfset set("DAOFileName","crusts.xml")>
	<cfset set("DAOXMLRootName","crusts")>
	<cfset set("DAOXMLChildName","crust")>
	<cfset set("DAOXMLNodeList","name,price,description")>
	<cfset set("DAOQuery",QueryNew(get("DAOXMLAttributesList")&","&get("DAOXMLNodeList"),"VarChar,VarChar,Decimal,VarChar"))>
	
</cfcomponent>