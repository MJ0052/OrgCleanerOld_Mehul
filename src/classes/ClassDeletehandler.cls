public class ClassDeletehandler {
    
    public static void TriggerDelete(ID a , String sessionID){
        String endp = URL.getSalesforceBaseUrl().toExternalForm() +'/services/data/v29.0/tooling/sobjects/ApexClass/'+ a;
            HttpRequest req = new HttpRequest();
            req.setHeader('Authorization', 'OAuth  ' + sessionID);
            req.setHeader('Content-Type', 'application/json');
            req.setEndpoint(endp);
            req.setMethod('DELETE');
        
            Http h = new Http();
            HttpResponse res = h.send(req);
            system.debug('************************** Trigger Response'+res.getStatus());
    }

}