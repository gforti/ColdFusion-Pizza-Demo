<!--------------------------------------------------------------------
	Handles XML based Orders and uses a struct to convert data.	
-------------------------------------------------------------------->


<cfcomponent name="OrdersDAO" extends="GenericGetSet">

	<cfset set("DAOFileName","Orders.xml")>
	<cfset set("DAOXMLRootName","Orders")>
	<cfset set("DAOXMLChildName","Order")>
	<cfset set("DAOXML","")>
	<cfset set("DAOStruct",structNew())>	
	<cfset variables.XMLFileHandlerObj = "">

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
   
   <cffunction name="createValidXMLFile" access="private" output="true" returntype="boolean">
		<cfset xmlDoc = XmlNew()>
		<cfset xmlDoc.XmlRoot = XmlElemNew( xmlDoc, get("DAOXMLRootName") )>
		<cfreturn variables.XMLFileHandlerObj.save(xmlDoc)>		
   </cffunction>
   
   
	<cffunction name="convertXML" access="private" output="true" returntype="Void"> 
		<cfset xmlDoc = get("DAOXML")>
		<cfset xmlStruct = get("DAOStruct")>
		<cfset rootName = get("DAOXMLRootName")>
		
		<cfset size = 0>
		<cfif IsXML(xmlDoc) AND StructKeyExists(xmlDoc, rootName)>	
			<cfset size = ArrayLen(xmlDoc[rootName].XmlChildren)>
			<cfif size GT 0>
				
				<cfloop index="i" from = "1" to = #size#>
					<cfset currentNode = xmlDoc[rootName].XmlChildren[i]>
					<cfset idVal = "">
					<cfset currentStruct = structNew()>
										
					
					<cfif StructKeyExists(currentNode.XmlAttributes, "id")>
						<cfset idVal = currentNode.XmlAttributes["id"]>
						<cfset StructInsert(currentStruct, "id", idVal,1)>
					</cfif>
					
					
					<cfloop list="contact,phone,datetime,status,processeddatetime" index="nodeName">					
						 <cfset nodeName = Lcase(nodeName)>	
						  <cfset nodeNameVal = "">	
						<cfif StructKeyExists(currentNode, nodeName)>
							<cfset nodeNameVal = currentNode[nodeName].XmlText>
						</cfif>
						<cfset StructInsert(currentStruct, nodeName, decodeHtmlEntity(nodeNameVal),1)>
					</cfloop>
					
					<cfset pizzaNodessize = ArrayLen(currentNode["pizzas"].XmlChildren)>
					<cfset currentPizzaStruct = structNew()>
					
						
						<cfloop index="i" from = "1" to = #pizzaNodessize#>
							<cfset currentNode2 = currentNode["pizzas"].XmlChildren[i]>
							<cfset idVal2 = "">
							<cfset currentPizzaNodeStruct = structNew()>
							
							<cfif StructKeyExists(currentNode2.XmlAttributes, "id")>
								<cfset idVal2 = currentNode2.XmlAttributes["id"]>
							</cfif>
							
							<cfloop list="pizzaID,pizzaQty,pizzaPrice,pizzaExtraToppings" index="nodeName2">					
								 <cfset nodeName2 = Lcase(nodeName2)>	
								  <cfset nodeNameVal2 = "">	
								<cfif StructKeyExists(currentNode2, nodeName2)>
									<cfset nodeNameVal2 = currentNode2[nodeName2].XmlText>
								</cfif>
								<cfset StructInsert(currentPizzaNodeStruct, nodeName2, nodeNameVal2,1)>
							</cfloop>
							
							
							<cfset StructInsert(currentPizzaStruct, idVal2, currentPizzaNodeStruct,1)>
						
						</cfloop>	
							<cfset StructInsert(currentStruct, "Pizzas", currentPizzaStruct,1)>
							
							
					<cfif Len(idVal)>
						<cfset StructInsert(xmlStruct, idVal, currentStruct,1)>
					</cfif>
				</cfloop>

							
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
   
   
   <!---- this is important, incase XML format needs to be reversed ---->
   <cffunction name="decodeHtmlEntity" access="private" returntype="String" output="true">     
		<cfargument name="Entity" type="String" />   
		
		<cfset var resultString=ReplaceNoCase(arguments.Entity,"&apos;","'","ALL")>
		<cfset resultString=ReplaceNoCase(resultString,"&quot;","""","ALL")>
		<cfset resultString=ReplaceNoCase(resultString,"&lt;","<","ALL")>
		<cfset resultString=ReplaceNoCase(resultString,"&gt;",">","ALL")>
		<cfset resultString=ReplaceNoCase(resultString,"&amp;","&","ALL")>

					
		<cfreturn resultString /> 
	</cffunction> 
   
   <!----- convert the struct into a XML file ------->
   <cffunction name="convertStruct" access="private" output="true" returntype="any">
		<cfset xmlDoc = "">		
		<cfset childName = get("DAOXMLChildName")>
		<cfset childName2 = "pizzas">
		<cfset xmlStruct = get("DAOStruct")>
		
		<cfif IsStruct(xmlStruct) AND NOT StructIsEmpty(xmlStruct)>
			<cfset xmlDoc = XmlNew()>		
			<cfset xmlDoc.XmlRoot = XmlElemNew( xmlDoc, get("DAOXMLRootName") )>
				
			<cfloop collection="#xmlStruct#" item="thisID">
				<cfset currentStructID = xmlStruct[thisID]>
				<cfset pizzasStruct = currentStructID["pizzas"]>
				
				
				
				<cfset xmlRootNodeElem = XmlElemNew( xmlDoc, childName )>								
				
				<cfloop list="id" index="attrName">
					<cfset attrName = Lcase(attrName)>
					<cfset xmlRootNodeElem.XmlAttributes[attrName] = Trim(XMLFormat(currentStructID[attrName]))>
				</cfloop>
				
				<cfloop list="contact,phone,datetime,status,processeddatetime" index="nodeName">					
					<cfset nodeName = Lcase(nodeName)>	
					<cfset xmlNodeElem = XmlElemNew( xmlDoc, nodeName )>
					<cfset xmlNodeElem.XmlText = Trim(XMLFormat(currentStructID[nodeName]))>
					<cfset ArrayAppend(xmlRootNodeElem.XmlChildren,xmlNodeElem)>
				</cfloop>
				
				
				<cfset xmlRootNodeElem2 = XmlElemNew( xmlDoc, childName2 )>
				
				
				<cfloop collection="#pizzasStruct#" item="thisID2">
					<cfset currentStructID2 = pizzasStruct[thisID2]>
					
					<cfset xmlChildNodeElem = XmlElemNew( xmlDoc, "pizza" )>
					<cfset xmlChildNodeElem.XmlAttributes["id"] = Trim(XMLFormat(thisID2))>
					
					<cfloop list="pizzaID,pizzaQty,pizzaPrice,pizzaExtraToppings" index="nodeName2">					
						<cfset nodeName2 = Lcase(nodeName2)>	
						<cfset xmlNodeElem2 = XmlElemNew( xmlDoc, nodeName2 )>
						<cfset xmlNodeElem2.XmlText = Trim(XMLFormat(currentStructID2[nodeName2]))>
						<cfset ArrayAppend(xmlChildNodeElem.XmlChildren,xmlNodeElem2)>
					</cfloop>
				
					<cfset ArrayAppend(xmlRootNodeElem2.XmlChildren,xmlChildNodeElem)>

									
				</cfloop>
				
				
				<cfset ArrayAppend(xmlRootNodeElem.XmlChildren,xmlRootNodeElem2)>	
				<cfset ArrayAppend(xmlDoc.XmlRoot.XmlChildren,xmlRootNodeElem)>	
		
			</cfloop>
		</cfif>
		
		
	
		<cfreturn xmlDoc>   
   </cffunction>
   
   
   <cffunction name="read" access="public" output="true" returntype="any">
		<cfargument name="idval" type="string" default="" required="false">
		
		<cfset arguments.idval = Trim(arguments.idval)>
		<cfset xmlStruct = get("DAOStruct")>
		
		<cfif IsStruct(xmlStruct)>
			<cfif Len(arguments.idval)>
				<cfif StructKeyExists(xmlStruct, arguments.idval)>
					<cfreturn xmlStruct[arguments.idval]>
				</cfif>
			<cfelse>
				<cfreturn xmlStruct>	
			</cfif>
		</cfif>
   
	<cfreturn false> 
	</cffunction>
	
	<cffunction name="delete" access="public" output="true" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">
		
		<cfset arguments.idval = Trim(arguments.idval)>
		<cfset xmlStruct = get("DAOStruct")>

		<cfif IsStruct(xmlStruct) AND Len(arguments.idVal)>							
			<cfreturn StructDelete(xmlStruct, arguments.idVal, 1)>			
		</cfif>
   
	<cfreturn false> 
	</cffunction>
	

	<!--- Saving data in a struct than a query is easier to process --->

	
	<cffunction name="create" access="public" output="true" returntype="boolean">
		<cfargument name="structVals" type="struct" required="true">
		
		<cfif NOT IsStruct(arguments.structVals) OR StructIsEmpty(arguments.structVals)>
			<cfreturn false>
		</cfif>
				
		<cfset datetimeVal = "">
		<cfset idVal = "">
		<cfset statusVal = 0>
		<cfset pizzaStruct = "">
		
		<cfif StructKeyExists(arguments.structVals, "datetime")>
			<cfset datetimeVal = Trim(arguments.structVals["datetime"])>
		</cfif>
		
		<cfif StructKeyExists(arguments.structVals, "id")>
			<cfset idVal = Trim(arguments.structVals["id"])>
		</cfif>
		
		<cfif StructKeyExists(arguments.structVals, "status")>
			<cfset statusVal = Trim(arguments.structVals["status"])>
		</cfif>
		
		<cfif StructKeyExists(arguments.structVals, "pizzas")>
			<cfset pizzaStruct = arguments.structVals["pizzas"]>
		</cfif>
		
		<!--- lets make sure the data is at least valid --->
		<cfif 	NOT Len(idVal) OR 
				NOT isBoolean(statusVal) OR 
				NOT IsDate(datetimeVal) OR 
				NOT IsStruct(pizzaStruct) OR 
				StructIsEmpty(pizzaStruct)
		>
			<cfreturn false>
		</cfif>
		
				
			<cfset delete(idVal)>
			<cfset xmlStruct = get("DAOStruct")>
			
			<cfif IsStruct(xmlStruct)>
			
				<cfset StructInsert(xmlStruct, idVal, Duplicate(arguments.structVals),1)>	
				
				<cfreturn true>
			</cfif>
		   
	<cfreturn false> 
	</cffunction>
	
	
	<cffunction name="save" access="public" output="true" returntype="boolean">		
		<cfreturn variables.XMLFileHandlerObj.save(convertStruct())> 
	</cffunction>
	
	
</cfcomponent>