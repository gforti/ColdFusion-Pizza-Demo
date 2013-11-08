<!--------------------------------------------------------------------
	This will handle the session data in a struct format
	
	can read, write, and delete data
-------------------------------------------------------------------->

<cfcomponent name="CartSession">

	<cffunction name="init" access="public" output="true"  returntype="Void">     
		
		<cflock scope="Session"  timeout="30" type="Exclusive">
          <cfif NOT isValidCart()>
            <cfset session.pizzaCart = structNew()>
          </cfif>
		</cflock>
	</cffunction>
	
	<cffunction name="isValidCart" access="public" output="true" returntype="boolean">
		<cfset returnResults = false>
		<cflock scope="Session"  timeout="30" type="Exclusive">
		  <cfif StructKeyExists(session, "pizzaCart") AND IsStruct(session.pizzaCart)>
			<cfset returnResults = true>
		  </cfif>
		</cflock>
		<cfreturn returnResults> 
	</cffunction>
	

	<cffunction name="clearCart" access="public" output="true" returntype="Void">
		
		<cflock scope="Session"  timeout="30" type="Exclusive">
          <cfif StructKeyExists(session, "pizzaCart")>
            <cfset session.pizzaCart = structNew()>
          </cfif>
		</cflock>	
      
	</cffunction>
	
	
	<cffunction name="read" access="public" output="true" returntype="any">
		<cfargument name="idVal" type="string" default="" required="false">
				
		<cfset returnResults = "">
		<cfset arguments.idval = Trim(arguments.idval)>
		<cfif isValidCart()>		
			<cflock scope="Session"  timeout="30" type="Exclusive">
			  <cfif Len(arguments.idVal) AND StructKeyExists(session.pizzaCart, arguments.idval)>
					<cfset returnResults = session.pizzaCart[arguments.idval]>
				<cfelse>
					<cfset returnResults = session.pizzaCart>
			  </cfif>
			</cflock>
		</cfif>
		
		<cfreturn returnResults> 
	</cffunction>
	
	<cffunction name="add" access="public" output="true" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">
		<cfargument name="Val" type="any" required="true">
		
		<cfset returnResults = false>
		<cfset arguments.idval = Trim(arguments.idval)>
		<cfif Len(arguments.idVal) AND isValidCart()>		
			<cflock scope="Session"  timeout="30" type="Exclusive">
				<cfset StructInsert(session.pizzaCart, arguments.idval, Duplicate(arguments.Val),1)>
				<cfset returnResults = true>
			</cflock>
		</cfif>
		
		<cfreturn returnResults> 
	</cffunction>
	
	
	
	<cffunction name="delete" access="public" output="true" returntype="boolean">
		<cfargument name="idVal" type="string" required="true">
		
		<cfset returnResults = false>
		<cfset arguments.idval = Trim(arguments.idval)>
		<cfif Len(arguments.idVal) AND isValidCart()>		
			<cflock scope="Session"  timeout="30" type="Exclusive">
			  <cfif StructKeyExists(session.pizzaCart, arguments.idval)>
				<cfset returnResults = StructDelete(session.pizzaCart, arguments.idval, 1)>
			  </cfif>
			</cflock>
		</cfif>
		
		<cfreturn returnResults> 
	</cffunction>
	

</cfcomponent>