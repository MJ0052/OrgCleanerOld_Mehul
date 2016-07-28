public class CommentClassTwo 
{
	public ToolingAPIWSDL.SforceService service;
    public static final String endpointSuffix = '/services/Soap/T/36.0';
    
     public CommentClassTwo() 
     {
        this(UserInfo.getSessionId(),URL.getSalesforceBaseUrl().toExternalForm());    
     }   
    public CommentClassTwo(String sessionId,String endpoint) 
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
        String CompleteClass = '//----Comment Added -----';
        String reg = '*/';
        String replacement = '*//*';
        ToolingAPIWSDL.sObject_x[] classa = new List<ToolingAPIWSDL.sObject_x>(); 
  		ToolingAPIWSDL.MetadataContainer Container = new ToolingAPIWSDL.MetadataContainer();
        Container.Name = 'Sample'; 
        ToolingAPIWSDL.MetadataContainer[] Containers = new List<ToolingAPIWSDL.MetadataContainer>();         
        ToolingAPIWSDL.SaveResult[] containerResults = service.create(Containers); 
        List<ApexClass> ApexClassBody = new List<ApexClass>([SELECT ApiVersion,Body,BodyCrc,CreatedById,CreatedDate,Id,IsValid,LastModifiedById,LastModifiedDate,LengthWithoutComments,Name,NamespacePrefix,Status,SystemModstamp FROM ApexClass where name ='dsfs']);	
        
        if (containerResults[0].success)
        {
            String containerId = containerResults[0].id;
            ToolingAPIWSDL.ApexClassMember classMember = new ToolingAPIWSDL.ApexClassMember();
             for(ApexClass a : ApexClassBody)
        	{	
                String s1 = a.Body.substringBefore('{');
                String s2 = a.Body.substringAfter('{');
                s2 ='{ /*'+ s2;  
                s2 = s2.replace(reg, replacement);          
                s2 =s2 + '*/ }';
                CompleteClass = s1 + s2;   
                classMember.ContentEntityId= a.Id;
                classMember.Body = CompleteClass;
                classMember.Name = a.Name;
                classMember.FullName = a.NamespacePrefix;
                classMember.CreatedById = a.CreatedById;
                classMember.CreatedDate = a.CreatedDate;
                classMember.LastModifiedById = a.LastModifiedById;
                classMember.LastModifiedDate =a.LastModifiedDate;
            }
            classMember.MetadataContainerId = containerId;
            ToolingAPIWSDL.ApexClassMember[] classMembers = new ToolingAPIWSDL.ApexClassMember[]{classMember};
            classa.add(classMember);
            
            ToolingAPIWSDL.SaveResult[] MembersResults = service.create(classa);
            if (MembersResults[0].success)
            {
              //create the ContainerAsyncRequest object
              ToolingAPIWSDL.ContainerAsyncRequest requ = new ToolingAPIWSDL.ContainerAsyncRequest();
              //if the code compiled successfully, save the updated class to the serverchange to IsCheckOnly = true to compile without saving 
              requ.IsCheckOnly = false;
              requ.MetadataContainerId = containerId;
              ToolingAPIWSDL.ContainerAsyncRequest[] requests = new ToolingAPIWSDL.ContainerAsyncRequest[]{ requ };
              ToolingAPIWSDL.SaveResult[] RequestResults = service.create(requests);
              if (RequestResults[0].success)
              { 
                 string requestId = RequestResults[0].id;
        
                 //poll the server until the process completes
                 ToolingAPIWSDL.QueryResult queryResult = null;
                 String soql = 'SELECT Id, State, ErrorMsg FROM ContainerAsyncRequest Where id = ' + requestId;
                 queryResult = service.query(soql);
                 if (queryResult.size > 0)
                 {
                    ToolingAPIWSDL.ContainerAsyncRequest request = (ToolingAPIWSDL.ContainerAsyncRequest)queryResult.records[0];
                    while (request.State.toLowerCase() == 'queued')
                    {
                       queryResult = service.query(soql);
                       request = (ToolingAPIWSDL.ContainerAsyncRequest)queryResult.records[0];
                    }
                 }
                 else
                  {
                      System.debug('Error: could not create ContainerAsyncRequest object');
                      System.debug('The error reported was: ' + RequestResults[0].errors[0].message);
                  }
              }
              else
              {
                  System.debug('Error: could not create Class Member');
                  System.debug('The error reported was:' + MembersResults[0].errors[0].message);
              }
            }
           else
            {
               System.debug('Error: could not create MetadataContainer ');
               System.debug(' The error reported was: ' + containerResults[0].errors[0].message);
            }
    	}  
	}
}