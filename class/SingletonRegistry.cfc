
<!--------------------------------------------------------------------
	ColdFusion can't create real singletons
	Used to help store all global variables to have one point of access
-------------------------------------------------------------------->

<cfcomponent name="SingletonRegistry">  
 
 <cfset This.PropertyStruct = structNew()>
 
 <cffunction name="init" output="false" access="private" returntype="SingletonRegistry">   
	<cfreturn THIS>  
  </cffunction>    

  <cffunction name="getInstance" output="false" access="public" returntype="SingletonRegistry">    
	  <cfif NOT isDefined("variables.instance")>		
		<cfset variables.instance = init()>    
	  </cfif>      
	  <cfreturn variables.instance>  
  </cffunction>
  
  <cffunction name="set" output="true" access="public" returntype="any">
		<cfargument	name="Property"	type="string" required="true"> 
		<cfargument	name="Value" type="any"	required="true">
		
		<cfif NOT IsSimpleValue(Arguments.Property)>
			<cfthrow type="InvalidPropertyException" message="Property Name is not of type string">
		</cfif>
		<cfset thisInstance = This.getInstance()>
		<cfset Arguments.Property = UCase(Arguments.Property)>
		<cfset StructInsert( thisInstance.PropertyStruct, Arguments.Property, Arguments.Value, 1)>
   </cffunction>
   
   <cffunction name="get" output="false" access="public" returntype="any">
		<cfargument	name="Property"	type="string" required="true"> 
				
		<cfif NOT IsSimpleValue(Arguments.Property)>
			<cfthrow type="InvalidPropertyException" message="Property Name is not of type string">
		</cfif>
		<cfset thisInstance = This.getInstance()>
		<cfset Arguments.Property = UCase(Arguments.Property)>
		<cfif StructKeyExists( thisInstance.PropertyStruct,Arguments.Property)>			
				<cfreturn  thisInstance.PropertyStruct[Arguments.Property]>
		</cfif>		
		<cfreturn "">	
   </cffunction>

 </cfcomponent> 
