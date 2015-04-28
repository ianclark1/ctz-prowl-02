<cfcomponent output="false">
	<!--- 
		Author: 	Critter Gewlas / Critter's Code
		Created:	August 2, 2009
		Purpose: 	Create push notifications using ColdFusion via Prowl servers
	 --->
	 
	<cfproperty name="apikey" type="string" />
	<cfproperty name="providerkey" type="string" />
	<cfproperty name="callto" type="string" />
	<cfproperty name="appname" type="string" />
	<cfproperty name="proxyserver" type="string" />
	<cfproperty name="proxyport" type="numeric" />


	<cffunction name="init" returntype="ctzprowl">
		<cfargument name="_apikey" required="true" type="string" />
		<cfargument name="_providerkey" required="true" type="string" />
		<cfargument name="_appname" required="true" type="String" />
		<cfargument name="_callto" required="true" type="string" />
		<cfargument name="_proxyserver" required="false" default="" type="string" />
		<cfargument name="_proxyport" required="false" default="80" type="Numeric" />
		
		<cfset setApikey(_apikey) />
		<cfset setProviderkey(_providerkey) />
		<cfset setAppname(_appname) />
		<cfset setCallto(_callto) />
		<cfset setProxyserver(_proxyserver) />
		<cfset setProxyport(_proxyport) />
	
		<cfreturn this />
    </cffunction>

	<cffunction name="add" access="public" output="false" returntype="struct">
		<cfargument name="event" type="String" required="true"  />
		<cfargument name="description" type="String" required="true" />
		<cfargument name="priority" type="Numeric" required="true"  />
		
		
		<cfhttp url="#callto#add" method="post" result="r" proxyserver="#proxyserver#" proxyport="#proxyport#" >
			<cfhttpparam type="formfield" name="apikey" value="#apikey#" />
			<cfhttpparam type="formfield" name="providerkey" value="#providerkey#" />
			<cfhttpparam type="formfield" name="priority" value="#priority#" />
			<cfhttpparam type="formfield" name="application" value="#appname#" />
			<cfhttpparam type="formfield" name="event" value="#event#" />
			<cfhttpparam type="formfield" name="description" value="#description#" />
		</cfhttp>


		
		<cfreturn processresult(r) />

	</cffunction>	



	<cffunction name="verify" access="public" output="false" returntype="struct">
		<cfhttp url="#callto#verify" method="get" result="r">
			<cfhttpparam type="formfield" name="apikey" value="#apikey#" />
			<cfhttpparam type="formfield" name="providerkey" value="#providerkey#" />
		</cfhttp>
		
		<cfreturn processresult(r) />
	</cffunction>


	<cffunction name="processresult" access="private" returntype="struct">
		<cfargument name="incoming" type="struct" required="true" />
		
		<cfset var result = structNew() />
		<cfset var xmlfile = xmlparse(incoming.filecontent) />
		<cfset result.complete = true />
		<cfset result.err = false />
		<cfset result.rawmessage = "" />
		<cfset result.statuscode = "" />

		<cfif incoming.statuscode NEQ "200 OK">
			<cfset result.err = true />
			<cfset result.errmessage = xmlfile.prowl.error[1].xmlText />
			<cfset result.code = xmlfile.prowl.error[1].xmlAttributes.code />
		<cfelse>
			<cfset result.remaining = xmlfile.prowl.success[1].xmlAttributes.remaining />
			<cfset result.resetdata = dateadd('s',xmlfile.prowl.success[1].xmlAttributes.resetdate,'01/01/1970') />
			<cfset result.code = xmlfile.prowl.success[1].xmlAttributes.code />
		</cfif>
		
		<cfset result.rawmessage = incoming.filecontent />
		<cfset result.statuscode = incoming.statuscode />
		
		<cfreturn result />
	</cffunction>



	<cffunction name="getProxyserver" access="public" output="false" returntype="String" >
		<cfreturn proxyserver />
	</cffunction>
	<cffunction name="setProxyserver" access="public" output="false" returntype="void">
		<cfargument name="_proxyserver" type="string" />
		<cfset proxyserver = _proxyserver />
	</cffunction>
	
	<cffunction name="getProxyport" access="public" output="false" returntype="Numeric" >
		<cfreturn proxyport />
    </cffunction>
	<cffunction name="setProxyport" access="public" output="false" returntype="void" >
		<cfargument name="_proxyport" type="Numeric"  />
		<cfset proxyport = _proxyport />
	</cffunction>
	
	<cffunction name="getApikey" access="public" output="false" returntype="string">
		<cfreturn apikey>
	</cffunction>

	<cffunction name="setApikey" access="public" output="false" returntype="void">
		<cfargument name="_apikey" type="string">
		<cfset apikey=_apikey/>
		
	</cffunction>

	<cffunction name="getProviderkey" access="public" output="false" returntype="string">
		<cfreturn providerkey>
	</cffunction>

	<cffunction name="setProviderkey" access="public" output="false" returntype="void">
		<cfargument name="_providerkey" type="string">
		<cfset providerkey=_providerkey/>
	</cffunction>

	<cffunction name="getCallto" access="public" output="false" returntype="string">
		<cfreturn callto>
		
	</cffunction>

	<cffunction name="setCallto" access="public" output="false" returntype="void">
		<cfargument name="_callto" type="string">
		<cfset callto=_callto/>
		
	</cffunction>

	<cffunction name="getAppname" access="public" output="false" returntype="string">
		<cfreturn appname>
	</cffunction>

	<cffunction name="setAppname" access="public" output="false" returntype="void">
		<cfargument name="_appname" type="string">
		<cfset appname=_appname/>
	</cffunction>


</cfcomponent>