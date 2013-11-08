
<!--------------------------------------------------------------------
	Base class that can be used to extend functionality with
	file management
-------------------------------------------------------------------->

<cfcomponent name="FileHandler" extends="GenericGetSet">

	<cfset set("fileDirectory","")>
	<cfset set("fileName","")>
	<cfset set("fileError","")>
	<cfset set("fileContents","")>
	<cfset updateFullFileName()>
	
	<cffunction name="init" access="public" output="false"  returntype="Void">     
		<cfargument name="fileName" type="string" required="true">
		<cfargument name="fileDirectory" type="string" required="true">
		
		<cfset setFileName(arguments.fileName)>
		<cfset setFileDirectory(arguments.fileDirectory)>
		<cfset updateFullFileName()>
   </cffunction>
      
   <cffunction name="updateFullFileName" access="private" output="false" returntype="Void">
		<cfset set("fullFileName",get("fileDirectory")&get("fileName"))>
	</cffunction>
	
	<cffunction name="setFileName" access="public" output="false" returntype="any" >
		 <cfargument name="fileName" type="string" Required=true>
		 <cfif NOT IsSimpleValue(Arguments.fileName)>
			<cfthrow type="InvalidFileContentsException" message="File Name is not of type string">
		</cfif>
		<cfif NOT Len(Arguments.fileName)>
			<cfthrow type="InvalidFileNameException" message="File Name was not supplied">
		</cfif>
		<cfset set("fileName",arguments.fileName)>
		<cfset updateFullFileName()>
		<cfreturn This>
   </cffunction>
   
    <cffunction name="setFileDirectory" access="public" output="false" returntype="any">
		 <cfargument name="fileDirectory" type="string" Required=true>		 
		 <cfif NOT IsSimpleValue(Arguments.fileDirectory)>
			<cfthrow type="InvalidFileDirectoryNameException" message="File Directory is not of type string">
		</cfif>
		<cfif NOT Len(Arguments.fileDirectory)>
			<cfthrow type="InvalidFileDirectoryNameLengthException" message="File Directory was not supplied">
		</cfif>
		<cfset set("fileDirectory",arguments.fileDirectory)>
		<cfset updateFullFileName()>
		<cfreturn This>
   </cffunction>
      	
</cfcomponent>