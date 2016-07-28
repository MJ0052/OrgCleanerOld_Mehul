public class ConfigurationCleanUpServiceHandler {
    
    //Search Keyword
    public String SearchKeyword = 'BillingCity'; 
    Boolean result= FALSE;
    
    public Map<String, List<String>> SummaryMap = new Map<String, List<String>>();
    public MetadataAPI mapi = new MetadataAPI();
    
    public ConfigurationCleanUpServiceHandler(){     
        SummaryMap.put('ApexClass', null);
        SummaryMap.put('ApexTrigger', null);
        SummaryMap.put('ApexPages', null);
        SummaryMap.put('Workflow', null);
        SummaryMap.put('ValidationRule', null);
    }
    
    public void SortAndCheckDependency()
    {
        SearchInTrigger();
        SearchInClass();
        SearchInPage();
        SearchInWorkflow();
        SearchInValidationRule();   
        System.debug('Summary Page: '+ SummaryMap);
    }
    
    //METHOD TO COLLECT ID's 
    public static void InvokeBatchForReceivedId()
    {             
      List<List<sObject>> finalIds = new List<List<sObject>>();
      //finalIds.add();
        
    }

    
    Public void SearchInClass()
    {
        List<String> ClassSummary = new list<String>();
        
        //SOSL Dynamic Query
        String SearchQuery = 'FIND {'+SearchKeyword+'}RETURNING ApexClass(Name  Where name!='+'\'OrgCleanerHandlerService\')';
        Search.SearchResults searchResults = Search.find(SearchQuery);
        List<Search.SearchResult> ClassSearchResult = searchResults.get('ApexClass');
        
        //Retriving Keyword Used in Class
        for (Search.SearchResult searchResult : ClassSearchResult) { 
        ApexClass Classes = (ApexClass) searchResult.getSObject(); 
        ClassSummary.add(Classes.Name);
		SummaryMap.put('ApexClass', ClassSummary);
        //System.debug('******************************* Used in Class ' +Classes.Name); 
        }
    }
    
    Public void SearchInTrigger()
    {
        List<String> TriggerSummary = new list<String>();
        String SearchQuery = 'FIND {'+SearchKeyword+'}RETURNING ApexTrigger(name)';
        Search.SearchResults searchResults = Search.find(SearchQuery);
        List<Search.SearchResult> TriggerSearchResult = searchResults.get('ApexTrigger');
        
         //Retriving Keyword Used in Triggers
        for (Search.SearchResult TriggersearchResults : TriggerSearchResult) { 
        ApexTrigger Triggers = (ApexTrigger) TriggersearchResults.getSObject();
            TriggerSummary.add(Triggers.Name);
            SummaryMap.put('ApexTrigger', TriggerSummary);
        //System.debug('******************************* Used in Triggers ' +Triggers.Name);
        } 
    }
    
    Public void SearchInPage()
    {        
        //Retriving Keyword Used in Pages
        Map<ID, ApexPage> ApexpageBody = new Map<ID, ApexPage>([SELECT Id,Name,Markup FROM ApexPage]);
        List<String> PageNames = new List<String>();
        for (ID idKey : ApexpageBody.keyset()) 
        {
            ApexPage a = ApexpageBody.get(idKey);
            Boolean PageSearchResult = a.Markup.contains(SearchKeyword);
            if(PageSearchResult)
            {
                PageNames.add(a.Name);
            }  
        }
        SummaryMap.put('ApexPages', PageNames);
        //System.debug('******************************* Received Page Name '+ PageNames); 
    }

    public void SearchInWorkflow()
    {              
        MetadataService.FileProperties[] fileProperties = mapi.listWorkflowMetadata();
        MetadataService.MetadataPort service = createService();
        List<String> WorkflowName = new List<String>();
        for(MetadataService.FileProperties fileProperty : fileProperties)
        {
 			MetadataService.WorkflowRule wRule =
                 (MetadataService.WorkflowRule) service.readMetadata('WorkflowRule',
               	 new String[] { fileProperty.fullName }).getRecords()[0];
				 
            
                 List<MetadataService.FilterItem> rul = new List<MetadataService.FilterItem>(wRule.criteriaItems);
                   for(MetadataService.FilterItem r : rul)
                   {  
                       result = r.field.contains(SearchKeyword);
                       if(result)
                        {
                           WorkflowName.add(wRule.fullName);
                        }  
                   }
        	}
        SummaryMap.put('Workflow', WorkflowName);   
    }
    
    public void SearchInValidationRule()
    {
        List<String> ValidationRuleName = new List<String>();
        MetadataService.MetadataPort service = createService();
		MetadataService.FileProperties[] fileProperties = mapi.listValidationRuleMetadata();
        
        for(MetadataService.FileProperties fileProperty : fileProperties)
        {   
            MetadataService.ValidationRule Validationrul =
                    (MetadataService.ValidationRule) service.readMetadata('ValidationRule',
                        new String[] {  fileProperty.fullName  }).getRecords()[0];
          		
            String fieldr = ValidationRul.errorConditionFormula;
            if(fieldr.contains(SearchKeyword))
            {
                ValidationRuleName.add(ValidationRul.fullName);
            }  
        }
        SummaryMap.put('ValidationRule', ValidationRuleName);
    }
    
    public static MetadataService.MetadataPort createService()
    {
        MetadataService.MetadataPort service = new MetadataService.MetadataPort();
        service.SessionHeader = new MetadataService.SessionHeader_element();
        service.SessionHeader.sessionId = UserInfo.getSessionId();
        return service;
    }

}