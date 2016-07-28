public class createTrigger {
    
    public static void triggercreate(){
       for(integer i=0;i<2;i++)
     {
            String json = '{ "Name" : "AccountTrigger'+i+'", "TableEnumOrId" : "Account", "Body" : "trigger AccountTrigger'+i+'on Account (before insert) { }" }';
            Httprequest req = new HttpRequest();
            req.setEndpoint(URL.getSalesforceBaseUrl().toExternalForm() + '/services/data/v30.0/sobjects/ApexTrigger');
            req.setMethod('POST');
            req.setHeader('Content-Type', 'application/json');
            req.setHeader('Authorization', 'OAuth ' + UserInfo.getSessionId());
            req.setBody(json);
            
            Http httpReq = new Http();
            HttpResponse res = httpReq.send(req);
            System.debug(res.getBody());
        }
        }
    }