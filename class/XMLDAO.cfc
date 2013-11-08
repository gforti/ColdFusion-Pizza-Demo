<!--------------------------------------------------------------------
	Gets XML and converts to a temporay query table
	can read, create/update and delete xml data
-------------------------------------------------------------------->

<cfcomponent name="XMLDAO" extends="GenericGetSet">

	<cfset set("DAOFileName","")>
	<cfset set("DAOXMLRootName","")>
	<cfset set("DAOXMLChildName","")>
	<cfset set("DAOXMLNodeList","name")>
	<cfset set("DAOXMLAttributesList","id")>
	<cfset set("DAOQuery",QueryNew(get("DAOXMLAttributesList")&","&get("DAOXMLNodeList")))>	
	<cfset set("DAOXML","")>	
	<cfset variables.XMLFileHandlerObj = "">
	
	<!--------------------------------------------------------------------
	start by getting XML file and converting it to a query
	-------------------------------------------------------------------->
	<cffunction name="init" access="public" output="true"  returntype="Void">     
		<cfargument name="datasource" type="string" required="true">
		
		<cfobject name="variables.XMLFileHandlerObj" component="XMLFileHandler">		
		<cfset variables.XMLFileHandlerObj.init(get("DAOFileName"),arguments.datasource)>
		
		<cfif NOT FileExists(arguments.datasource&get("DAOFileName"))>
			<cfset createValidXMLFile()>
		</cfif>
		
		<cfset set("DAOXML",variables.XMLFileHandlerObj.read())>		
		<cfset convertXML()>	
			
	</cffunction>
   
   <!--------------------------------------------------------------------
	create file if it does not exist
	-------------------------------------------------------------------->
   <cffunction name="createValidXMLFile" access="private" output="true" returntype="boolean">
		<cfset xmlDoc = XmlNew()>
		<cfset xmlDoc.XmlRoot = XmlElemNew( xmlDoc, get("DAOXMLRootName") )>
		<cfreturn variables.XMLFileHandlerObj.save(xmlDoc)>		
   </cffunction>
   
    <!--- this is important, incase XML format needs to be reversed --->
    <cffunction name="decodeHtmlEntity" access="private" returntype="String" output="true">     
		<cfargument name="Entity" type="String" />   
		
		<cfset var resultString=ReplaceNoCase(arguments.Entity,"&apos;","'","ALL")>
		<cfset resultString=ReplaceNoCase(resultString,"&quot;","""","ALL")>
		<cfset resultString=ReplaceNoCase(resultString,"&lt;","<","ALL")>
		<cfset resultString=ReplaceNoCase(resultString,"&gt;",">","ALL")>
		<cfset resultString=ReplaceNoCase(resultString,"&amp;","&","ALL")>

					
		<cfreturn resultString /> 
	</cffunction> 
   
   <!--------------------------------------------------------------------
	Gets XML and converts to a temporay query table
	-------------------------------------------------------------------->
	<cffunction name="convertXML" access="private" output="true" returntype="Void"> 
		<cfset xmlDoc = get("DAOXML")>
		<cfset xmlQuery = get("DAOQuery")>
		<cfset rootName = get("DAOXMLRootName")>
		<cfset nodeList = get("DAOXMLNodeList")>
		<cfset attrList = get("DAOXMLAttributesList")>
		
		<cfset size = 0>
		<cfif IsXML(xmlDoc) AND StructKeyExists(xmlDoc, rootName)>	
			<cfset size = ArrayLen(xmlDoc[rootName].XmlChildren)>
			<cfif size GT 0>
				<cfset QueryAddRow(xmlQuery, #size#)>
				<cfloop index="i" from = "1" to = #size#>
					<cfset currentNode = xmlDoc[rootName].XmlChildren[i]>
					
					<!--- A bit tricky but gets the list of nodes and Attributes then creates the XML --->
					
					<cfloop list="#attrList#" index="attrName">
						<cfset attrName = Lcase(attrName)>
						<cfif StructKeyExists(currentNode.XmlAttributes, attrName)>
							<cfset QuerySetCell(xmlQuery, attrName, #currentNode.XmlAttributes[attrName]#, #i#)>
					   <cfelse>
							<cfset QuerySetCell(xmlQuery, attrName, "", #i#)>
						</cfif>
					</cfloop>
					
					<cfloop list="#nodeList#" index="nodeName">					
						 <cfset nodeName = Lcase(nodeName)>						
						<cfif StructKeyExists(currentNode, nodeName)>
							<cfset QuerySetCell(xmlQuery, nodeName, #decodeHtmlEntity(currentNode[nodeName].XmlText)#, #i#)>
						<cfelse>
							<cfset QuerySetCell(xmlQuery, nodeName, "", #i#)>
						</cfif>					
					</cfloop>			  
				</cfloop>

				<cfset set("DAOQuery",xmlQuery)>
				
			</cfif>
		<cfelse>
			<cfif NOT createValidXMLFile()>
				<cfthrow type="InvalidXMLException" message="File is not valid XML">
			<cfelse>
				<cfset set("DAOXML",variables.XMLFileHandlerObj.read())>
				<cfset convertXML()>
			</cfif>
		</cfif>
		
   </cffunction>
   
   
    <!--------------------------------------------------------------------
	Gets query and converts to a XML
	-------------------------------------------------------------------->
   <cffunction name="convertQuery" access="private" output="true" returntype="any">
		<cfset xmlDoc = "">
		<cfset xmlQuery = get("DAOQuery")>
		<cfset childName = get("DAOXMLChildName")>
		<cfset nodeList = get("DAOXMLNodeList")>
		<cfset attrList = get("DAOXMLAttributesList")>
		
		<cfif IsQuery(xmlQuery)>
			<cfset xmlDoc = XmlNew()>		
			<cfset xmlDoc.XmlRoot = XmlElemNew( xmlDoc, get("DAOXMLRootName") )>
			
			<cfloop query="xmlQuery">			 
				<cfset xmlRootNodeElem = XmlElemNew( xmlDoc, childName )>								
				
				<cfloop list="#attrList#" index="attrName">
					<cfset attrName = Lcase(attrName)>
					<cfset xmlRootNodeElem.XmlAttributes[attrName] = Trim(XMLFormat(xmlQuery[attrName][xmlQuery.currentrow]))>
				</cfloop>
				
				<cfloop list="#nodeList#" index="nodeName">					
					<cfset nodeName = Lcase(nodeName)>	
					<cfset xmlNodeElem = XmlElemNew( xmlDoc, nodeName )>
					<cfset xmlNodeElem.XmlText = Trim(XMLFormat(xmlQuery[nodeName][xmlQuery.currentrow]))>
					<cfset ArrayAppend(xmlRootNodeElem.XmlChildren,xmlNodeElem)>
				</cfloop>
				
				<cfset ArrayAppend(xmlDoc.XmlRoot.XmlChildren,xmlRootNodeElem)>	
			
			</cfloop>
			
		</cfif>
	
		<cfreturn xmlDoc>   
   </cffunction>
   
   
   <cffunction name="read" access="public" output="true" returntype="any">
		<cfargument name="idval" type="string" default="" required="false">
		
		<cfset arguments.idval = Trim(arguments.idval)>
		<cfset xmlQuery = get("DAOQuery")>
		
		<cfif IsQuery(xmlQuery)>
			<cfif Len(arguments.idval)>
				<cfquery name="dataRow" dbType="query"> 
					SELECT * FROM xmlQuery where id = '#arguments.idval#'
				</cfquery>
			<cfelse>
				<cfquery name="dataRow" dbType="query"> 
					SELECT * FROM xmlQuery
				</cfquery>
			</cfif>
			<cfif dataRow.recordcount GT 0>
				<cfreturn dataRow>
			</cfif>
		</cfif>
   
	<cfreturn false> 
	</cffunction>
	
	<cffunction name="delete" access="public" output="true" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">
		
		<cfset arguments.idval = Trim(arguments.idval)>
		<cfset xmlQuery = get("DAOQuery")>

		<cfif IsQuery(xmlQuery) AND Len(arguments.idVal)>			
			<cfif IsQuery(read(arguments.idVal))>
				<cfquery name="dataDelete" dbType="query"> 
					SELECT * FROM xmlQuery where id <> '#arguments.idVal#'
				</cfquery>
				<cfset set("DAOQuery",dataDelete)>				
				<cfreturn true>
			</cfif>
		</cfif>
   
	<cfreturn false> 
	</cffunction>
	
	
	<!--------------------------------------------------------------------
	Needs a struct with same propertys that will be saved into XML
	-------------------------------------------------------------------->
	
	<cffunction name="create" access="public" output="true" returntype="boolean">
		<cfargument name="structVals" type="struct" required="true">
		
		<cfif NOT IsStruct(arguments.structVals) OR StructIsEmpty(arguments.structVals)>
			<cfreturn false>
		</cfif>
		
		<cfset nameVal = "">
		
		<cfif StructKeyExists(arguments.structVals, "name")>
			<cfset nameVal = Trim(arguments.structVals["name"])>
		</cfif>
		
		<cfset idVal = iif(Len(nameVal),de("ID#Hash(UCase(nameVal))#"),de(""))>		
		
		<cfif Len(idVal)>		
			<cfset delete(idVal)>
			<cfset xmlQuery = get("DAOQuery")>
			<cfset nodeList = get("DAOXMLNodeList")>
			<cfif IsQuery(xmlQuery)>
			
				<cfset QueryAddRow(xmlQuery)>
				<cfset QuerySetCell(xmlQuery, "id", idVal)>
				
				<cfloop list="#nodeList#" index="nodeName">
					<cfset nodeName = Lcase(nodeName)>
					<cfif StructKeyExists(arguments.structVals, nodeName)>
						<cfset QuerySetCell(xmlQuery, nodeName, Trim(arguments.structVals[nodeName]))>
					<cfelse>
						<cfset QuerySetCell(xmlQuery, nodeName, "")>
					</cfif>
				</cfloop>
				
				<cfset set("DAOQuery",xmlQuery)>

				<cfreturn true>
			</cfif>
		</cfif>
   
	<cfreturn false> 
	</cffunction>
	
	
	<cffunction name="save" access="public" output="true" returntype="boolean">		
		<cfreturn variables.XMLFileHandlerObj.save(convertQuery())> 
	</cffunction>
	
	
</cfcomponent>