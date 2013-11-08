
<!--------------------------------------------------------------------
	Extened class used to write files
-------------------------------------------------------------------->


<cfcomponent name="WriteFileHandler" extends="FileHandler">
	
	<!--------------------------------------------------------------------
		used to prepare file contents before writing
	-------------------------------------------------------------------->
    <cffunction name="setFileContents" output="false" returntype="boolean">
		<cfargument name="fileContents" type="string" required="true">
		<cfargument name="append" type="boolean" default="true" required="false">
		
		<cfif NOT IsSimpleValue(Arguments.fileContents)>
			<cfthrow type="InvalidFileContentsException" message="File Contents is not of type string">
		</cfif>
		<cfif NOT Len(Arguments.fileContents)>
			<cfthrow type="InvalidFileContentsException" message="File Contents was not supplied">
		</cfif>
		<cfif Arguments.append>
			<cfset set("fileContents",get('fileContents')&Arguments.fileContents)>
		<cfelse>
			<cfset set("fileContents",Arguments.fileContents)>
		</cfif>
		<cfreturn true>
   </cffunction>
   
  
   <cffunction name="write" output="true" returntype="boolean">
		<cftry>
			<cffile action="write" file="#get('fullFileName')#" output="#get('fileContents')#" addNewLine="Yes">
			<cfcatch type = "Any"> 
				<cfset set("fileError",cfcatch.Type&" - "&cfcatch.Message)>
				<cfreturn false>
			</cfcatch>
		</cftry>
		<cfreturn true>
   </cffunction>
   
   
</cfcomponent>
