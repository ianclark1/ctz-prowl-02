<cfscript>

	apikey = "";
	providerkey = "";
	callto = "https://prowl.weks.net/publicapi/";
	appname = "Critter's Code'";
	
	/*	optional attributes if you need them.
	proxyport = 4450;
	proxyserver = http://187.23.45.21;
	*/
	
	/*	
		connect to the prowl cfc	
		optional -- _proxyserver (string)
		optional -- _proxyport (numeric)
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
	writedump(var=x,label='Verification results');
	
	
	if(isDefined("y"))
	{
		writeoutput('<br />');
		writedump(var=y,label='Add Notification results');
	}
	

</cfscript>