
component 
{
	/*
	Author: 	Critter Gewlas / Critter's Code
	Created:	August 2, 2009
	Purpose: 	Create push notifications using ColdFusion via Prowl servers (ColdFusion9)
	*/
	
	property name="apikey" type="string";			/* Can be obtained from http://prowl.weks.net/ */
	property name="providerkey" type="string";		/* Optional */
	property name="appname" type="string";
	property name="callto" type="string";
	property name="proxyserver" type="string";
	property name="proxyport" type="numeric";
	
	public ctzprowl function init(required string _apikey,required string _callto,required string _appname,string _proxyserver='',string _proxyport=80)
	{
		setapikey(_apikey);
		setproviderkey(_providerkey);
		setcallto(_callto);
		setapplication(_appname);
		setproxyserver(_proxyserver);
		setproxyport(_proxyport);
	
		return this;
	}
	public void function setapikey(required string _apikey)
	{
		apikey=_apikey;
	}
	public void function setproxyserver(required string _proxyserver)
	{
		proxyserver = _proxyserver;
	}
	public string function getproxyserver()
	{
		return proxyserver;
	}
	public void function setproxyport(required string _proxyport)
	{
		proxyport = _proxyport;
	}
	public void function setproviderkey(required  string _providerkey)
	{
		providerkey = _providerkey;
	}
	public string function getproviderkey()
	{
		return providerkey;
	}
	public void function setcallto(required string _callto)
	{
		callto = _callto;
	}
	public string function getcallto()
	{
		return callto;
	}
	
	public string function getApplication()
	{
		return appname;
	}
	
	public string function getapikey()
	{
		return apikey;
	}
	public void function setApplication(required string _appname)
	{
		appname=_appname;
	}

	public struct function add(required  string priority,required  string event,required  string description)
	{
		var local.http_result = structNew();
		var h = new http();
		
		h.setAttributes(url= callto & 'add', method = 'POST');
		h.addParam(type="formfield", name='apikey', value=apikey);
		h.addParam(type="formfield", name='providerkey', value=providerkey);
		h.addParam(type="formfield", name='priority', value=priority);
		h.addParam(type="formfield", name='application', value=appname);
		h.addParam(type="formfield", name='event', value=event);
		h.addParam(type="formfield", name='description', value=description);
		
		local.http_result = processresult(incoming=h.send().getPrefix());
		h.clear();
		
		return local.http_result;
	}

	public struct function verify()
	{
		var local.result = structNew();
		var local.http_result = structNew();
		var h = new http();
		
		h.setAttributes(url= callto & 'verify',method='GET');
		h.addParam(type="formfield", name='apikey', value=apikey);
		h.addParam(type="formfield", name='providerkey', value=providerkey);
		
		local.http_result = processresult(incoming=h.send().getPrefix());
		
		h.clear();
		
		return local.http_result;
		
	}

	private struct function processresult(required struct incoming)
	{
		var local.incoming = incoming;
		var local.result = structNew();
		
			local.result.complete = true;
			local.result.err = false;
			local.result.rawmessage = "";
			local.statuscode = "";
		local.xmlfile = xmlparse(local.incoming.filecontent);
		
		if(local.incoming.statuscode != "200 OK")
		{
			local.result.err = true;
			local.result.errmessage = local.xmlfile.prowl.error[1].xmlText;
			local.result.code = local.xmlfile.prowl.error[1].xmlAttributes.code;
			
			
		}
		else
		{
			
			local.result.remaining = local.xmlfile.prowl.success[1].xmlAttributes.remaining;
			local.result.resetdata = dateadd('s',local.xmlfile.prowl.success[1].xmlAttributes.resetdate,'01/01/1970');
			local.result.code = 	 local.xmlfile.prowl.success[1].xmlAttributes.code;
		}
		local.result.rawmessage = local.incoming.filecontent;
		local.result.statuscode = local.incoming.statuscode;
		
		return local.result;
		
	}
}