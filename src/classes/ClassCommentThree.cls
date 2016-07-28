public class ClassCommentThree 
{ 
    
    // SomeValues to be store
    public String axid = '' ;
    public String cid ;
    public String apmid ;
    public String carid ;
    public String updated ='" /* hi */ " ';          
    

    public String getResponse(HttpRequest req)
    {
        try
        {
            Http httpreq = new Http();
            HttpResponse res = httpreq.send(req);
            String reqresponse = res.getBody();
            System.debug(res.getBody());
            return reqresponse;
        }
        catch (Exception e)
        {return 'Error:' +e.getMessage();}
    }

    // create a http request with required endpoint and request method
    public HttpRequest createHttpRequest(String endpoint, String method)
    {
        HttpRequest req = new HttpRequest();
        req.setHeader('Authorization', 'Bearer ' + UserInfo.getSessionID());
        req.setHeader('Content-Type', 'application/json');
        req.setEndpoint(endpoint);
        req.setMethod(method);
        return req;
    }
     
    
    public void createMetadataContainer() 
	{
        HttpRequest req = createHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/MetadataContainer','POST');
        req.setBody('{"Name":"Container17"}');  
        //String response = getResponse(req);      
        Map<String, Object> rmp = (Map<String, Object>)(JSON.deserializeUntyped(getResponse(req)));
        //Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeUntyped(response);
        String cid = (String)rmp.get('id'); // used to save containerId
        System.debug('CID : '+ cid);
        
        List<ApexClass> ac = new List<ApexClass>([Select id,body from ApexClass where Name = 'dsfs' Limit 1]);
          System.debug('Body : '+ ac[0].body);
        
        HttpRequest req1 = createHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/ApexClassMember','POST');
        req1.setBody('{"MetadataContainerId" : "'+cid+'", "ContentEntityId" : "'+ac[0].id+'", "Body": "'+ac[0].body+'"}');
        //String response1 = getResponse(req1);
        
        Map<String,Object> rmp1 = (Map<String,Object>)JSON.deserializeuntyped(getResponse(req1));
        String apmid = (String)rmp1.get('id');// Store ApexClassMember Id
        
        //createApexClassMember(cid,axid,updated);
        //createContainerAsyncRequest(cid);
        //getContainerAsyncRequestStatus();
    }
     
    public void createApexClassMember(String mid, String axid, String classBody)
    {
        HttpRequest req = createHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/ApexClassMember','POST');
        req.setBody('{"MetadataContainerId" : "'+mid+'", "ContentEntityId" : "'+axid+'", "Body": "'+classbody+'"}');
        String response = getResponse(req);
        Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
        String apmid = (String)rmp.get('id');// Store ApexClassMember Id
    }
	
    public void createContainerAsyncRequest(String mid)
    {
        HttpRequest req = createHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/containerAsyncRequest','POST');
        req.setBody('{"MetadataContainerId" : "'+mid+'", "isCheckOnly": "true"}');
        String response = getResponse(req);
        Map<String,Object> rmp = (Map<String,Object>)JSON.deserializeuntyped(response);
        carid = (String)rmp.get('id');
    }
     
	public void getContainerAsyncRequestStatus()
    {
        HttpRequest req = createHttpRequest(URL.getSalesforceBaseUrl().toExternalForm()+'/services/data/v36.0/tooling/sobjects/containerAsyncRequest/'+carid,'GET');
        String responseJson = getResponse(req);
        System.debug('Response jason : '+ responseJson);
    }
}