<!--------------------------------------------------------------------
	Extended class uses generic XML Data Access Object
	Gets XML and converts to a temporay query table
-------------------------------------------------------------------->

<cfcomponent name="SizesDAO" extends="XMLDAO">

	<cfset set("DAOFileName","sizes.xml")>
	<cfset set("DAOXMLRootName","sizes")>
	<cfset set("DAOXMLChildName","size")>
	<cfset set("DAOXMLNodeList","name,inches,description")>
	<cfset set("DAOQuery",QueryNew(get("DAOXMLAttributesList")&","&get("DAOXMLNodeList"),"VarChar,VarChar,Integer,VarChar"))>
	
</cfcomponent>