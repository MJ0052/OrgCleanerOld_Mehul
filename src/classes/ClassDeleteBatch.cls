global class ClassDeleteBatch implements Database.AllowsCallouts, Database.Batchable<sObject>, Database.Stateful {
    
    public String sessionId;
    
    global ClassDeleteBatch(){
        sessionId = UserInfo.getSessionId();
        
    }

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator([SELECT Id, Name FROM ApexClass where Name LIKE '%Mydemoclass%']);
    }

    global void execute(Database.BatchableContext BC,List<ApexClass> scope){
    
        try{
            for (ApexClass idKey : scope) 
            {   
                System.debug('IDKEY : '+idKey.ID);
                ClassDeletehandler.TriggerDelete(idKey.ID, sessionId);
            }
        }catch(Exception e){
            
            System.debug('Exception : '+ e.getMessage());
        }
    }
       global void finish(Database.BatchableContext BC){
            // Logic to be Executed at finish
       }
}