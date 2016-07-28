global class ConfigurationCleanUpBatchService implements Database.Batchable<sObject>, Database.Stateful, Database.AllowsCallouts{
    
    //GLOBAL DECLARATION
    //global List<List<sObject>> receivedlist = new List<List<sObject>>();
    global Map<String,List<sObject>> receivedlist = new Map<String,List<sObject>>();
    global List<sObject> batchlist = new List<sObject>(); 
    global string configName;
    //global List<sObject> batchlisttemp = new List<sObject>();
    public String sessionId; 
    
    global ConfigurationCleanUpBatchService(Map<String,List<sObject>> listofsobject){
        sessionId = UserInfo.getSessionId();
        for(String sObj : listofsobject.keySet()){
            batchlist = listofsobject.get(sObj);
            configName = sObj;
            listofsobject.remove(sObj);
            receivedlist = listofsobject.clone();
            break;
        }
    }
    
    //BATCH START METHOD
    global List<sObject> start(Database.BatchableContext BC){
        System.debug('configName in start: '+configName);
        return batchlist;
        //return new IterableConfigurationHandler();
    }
    
    //BATCH EXECUTE METHOD
    global void execute(Database.BatchableContext BC, List<sObject> scope){	
        System.debug('configName : '+configName);
        List<String> ss = new  List<String>();
        try{
            ToolingAPIService t = new ToolingAPIService();
            MetadataAPI mapi = new MetadataAPI();
            for (sObject s : scope) 
            {   
                if(configName == 'ApexTrigger'){
                    t.TriggerDelete(s.id, sessionId);
                }
                if(configName == 'ApexPage'){
                    t.PageDelete(s.id, sessionId);
                } 
                
                ss.add(string.valueOf(s));
            }
            if(configName == 'WorkFlow'){
                mapi.deleteWorkflow(ss);
            }
            if(configName == 'ValidationRule'){
                mapi.deleteValidationRule(ss);
            }
        }catch(Exception e){
            System.debug('Exception : '+ e.getMessage());
        }
    }
    global void finish(Database.BatchableContext BC){
        
        //Call batch class again for delete another object's record
        if(receivedlist.size() > 0)
        {
            System.debug('listofsobject '+receivedlist);
            System.debug('configName in Finish: '+configName);
            configName = ''; 
            Id batchInstanceId = Database.executeBatch(new ConfigurationCleanUpBatchService(receivedlist));
            
        }
    }     
    
}