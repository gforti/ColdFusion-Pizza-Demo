<!--------------------------------------------------------------------
	Extened class used to read files
-------------------------------------------------------------------->

<cfcomponent name="ReadFileHandler" extends="FileHandler">
	
	<cffunction name="read" output="true" returntype="boolean">
		<cftry>
			<cffile action="read" file="#get('fullFileName')#" variable="fileContents">
			<cfset set("fileContents",fileContents)>			
			<cfcatch type = "Any"> 
				<cfset set("fileError",cfcatch.Type&" - "&cfcatch.Message)>
				<cfreturn false>
			</cfcatch>
		</cftry>
		<cfreturn true>
   </cffunction>
	  
</cfcomponent>
