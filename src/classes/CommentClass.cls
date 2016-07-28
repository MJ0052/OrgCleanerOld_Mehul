public class CommentClass 
{
    private ToolingAPIWSDL.SforceService service;
    private static final String endpointSuffix = '/services/Soap/T/32.0';
    
     public CommentClass() {
        this(UserInfo.getSessionId(),URL.getSalesforceBaseUrl().toExternalForm());
    }
    public CommentClass(String sessionId,String endpoint) 
    {
         if(sessionId==null)
           System.debug('Unable to obtain Session Id');

        service = new ToolingAPIWSDL.SforceService();
        service.SessionHeader = new ToolingAPIWSDL.SessionHeader_element();
        service.SessionHeader.sessionId = sessionId;
        service.endpoint_x = endpoint + endpointSuffix;
        
    }
     public void setTimeout(Integer TimeoutInMilliSecond) {
        this.service.timeout_x = TimeoutInMilliSecond;
    }
    public void CommentAllClass()
    {
        System.debug('Login Sucessful..............');     
        String CompleteClass = '//----Added by zen4orce -----';
        String reg = '*/';
        String replacement = '*//*';
        //create the metadata container 
  		ToolingAPIWSDL.ApexClass con = new ToolingAPIWSDL.ApexClass();
        ToolingAPIWSDL.ApexClass[] classarray = new List<ToolingAPIWSDL.ApexClass>();
        
        List<ApexClass> ApexClassBody = new List<ApexClass>([SELECT Id,Body,Name FROM ApexClass]);	        
        for(ApexClass a : ApexClassBody){
            //STRING OPERATION
            String s1 = a.Body.substringBefore('{');
            String s2 = a.Body.substringAfter('{');
            s2 ='{ /*'+ s2;  
           	s2 = s2.replace(reg, replacement);          
            s2 =s2 + '*/ }';
            CompleteClass = s1 + s2;   
            //System.debug(CompleteClass); 
            con.Body= CompleteClass;
            classarray.add(con);
        }
 
         ToolingAPIWSDL.SforceService abc = new ToolingAPIWSDL.SforceService();
         abc.upsert_x('id', classarray); 
         System.debug('execution complete');
    }  
}