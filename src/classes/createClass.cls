global class createClass {

    public static void classcre(){
        try{
            for(integer i=0;i<10;i++)
            {
                HttpRequest req = new HttpRequest();
                req.setHeader('Authorization', 'OAuth  ' + UserInfo.getSessionId());
                req.setHeader('Content-Type', 'application/json');
                req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() +'/services/data/v30.0/sobjects/ApexTrigger');
                req.setMethod('POST');
                String json ='{ "Name" : "AccountTrigger'+i+'", "TableEnumOrId" : "Account", "Body" : "trigger AccountTrigger'+i+'on Account (before insert) { }" }';
                req.setBody(json);
            
                Http h = new Http();
                HttpResponse res = h.send(req);
                system.debug('************************** Response'+res.getBody());
            system.debug('************************** Response'+res.getStatus());
            }
        }
        catch(Exception e){            
            System.debug('Exception : '+ e.getMessage());
        }
    }
}