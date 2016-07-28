public class selectiveOrgCleanerService {
    
    Map<string, List<String>> retrivedTriggers {get; set;}
    
    public Map<string, List<String>> retriveTrigger()
    {
        triggerService ts = new triggerService();
        retrivedTriggers = ts.getTriggers(); 
        return retrivedTriggers;
    }
    
    public void deleteTrigger(List<sObject> selectedTriggers)
    {
        Map<string, List<sObject>> triggerMap = new Map<string, List<sObject>>();
        triggerMap.put('ApexTrigger', selectedTriggers);
        database.executeBatch(new ConfigurationCleanUpBatchService(triggerMap),100);
    }
    
}