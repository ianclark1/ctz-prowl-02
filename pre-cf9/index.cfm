
<cfscript>

	apikey = "";
	providerkey = "";
	callto = "https://prowl.weks.net/publicapi/";
	appname = "Critter's Code'";
	/*
	optional attributes
	proxyserver = "";
	proxyport = "";
	*/
	
	/*	connect to the prowl
		optional: _proxyserver (string);
		optional: _proxyport (numeric) -- default is 80;
	*/
	
	p = createObject("component","ctzprowl").init(_apikey=apikey,_callto=callto,_providerkey=providerkey,_appname=appname);
	
	//	verify account (it does count against your 1,0000 requests per hour)
	x = p.verify();
	
	if(x.complete and x.code eq 200)
	{
		//	send notification to devices registered to our account.	//
		y = p.add(priority='0',event='CF9',description="I'm in your phone via CF9'");
	}
	// dump x (our verification call)
	dump(obj=x,label='Verification results');
	
	
	if(isDefined("y"))
	{
		writeoutput('<br />');
		dump(obj=y,label='Add Notification results');
	}

</cfscript>

<cffunction name="dump" returntype="void" >
	<cfargument name="obj" default="" required="true"  />
	<cfargument name="label" default="" required="false"  />
	
	<cfdump var="#arguments.obj#" label="#arguments.label#" />
</cffunction>
