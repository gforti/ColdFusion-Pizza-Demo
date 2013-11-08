<!--- Set application name and Session variables. --->
<cfapplication name="PizzaParlor" sessionmanagement="Yes">


<!--- Set Application-specific Variables scope variables. --->
<!--- Include a file containing user-defined functions called throughout the application. --->
<cflock scope="Application" timeout="30" type="Exclusive">
	<cfinclude template="inc/config.inc.cfm">
	<cfinclude template="global.inc.cfm">
</cflock>