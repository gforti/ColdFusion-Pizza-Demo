<!--------------------------------------------------------------------
	Sets all params needed for the view, as well as if the command
	was sucessful or not
-------------------------------------------------------------------->


<cfcomponent name="CommandContext"  extends="GenericGetSet">

	<cfset variables.error = "">	
	<cfset variables.success = "">
	
	<cffunction name="init" access="public" output="false"  returntype="Void">     
		<cfset set("form",form)>
		<cfset set("url",url)>
		<cfset set("view","")>
		<cfset set("showAdminMenu",false)>
		<cfset setAction()>
	</cffunction>
	
	<cffunction name="setError" output="false" access="public" returntype="any">
		<cfargument	name="msg" type="any" required="true">
		<cfset variables.error = Arguments.msg> 		
	</cffunction>

	<cffunction name="getError" output="false" access="public" returntype="any">
		<cfreturn variables.error>
	</cffunction>
	
	<cffunction name="setSuccess" output="false" access="public" returntype="any">
		<cfargument	name="msg" type="any"	required="true">
		<cfset variables.success = Arguments.msg> 		
	</cffunction>

	<cffunction name="getSuccess" output="false" access="public" returntype="any">
		<cfreturn variables.success>
	</cffunction>
	
	<cffunction name="setAction" output="false" access="private" returntype="Void">
		<cfset actionValue = "">
		<cfif Len(application.config.currentQueryString) AND StructKeyExists(get("url"), "action")>
			<cfset actionValue = get("url").action>
		</cfif>
		<cfif StructKeyExists(get("form"), "action")>
			<cfset actionValue = get("form").action>
		</cfif>
		
		<cfset set("action",actionValue)>		
	</cffunction>

</cfcomponent> 