public class triggerService {
    
    public Map<string, List<String>> getTriggers()
    {
        triggerSelector ts = new triggerSelector();  
        list<ApexTrigger> at = new List<ApexTrigger>(ts.getTriggerList());
        Map<string, List<String>> triggerMap = new Map<string, List<String>>();
        List<String> abc;
        for(ApexTrigger att : at)
        {
            abc = new List<String>();
            if(triggerMap.containsKey(att.TableEnumOrId)){
                abc.addAll(triggerMap.get(att.TableEnumOrId));
                abc.add(att.Name); 
            }
            else{abc.add(att.Name);}
            triggerMap.put(att.TableEnumOrId, abc);                     
        }
         System.debug('Map '+ triggerMap);
        //deleteTrigger(at);
        return triggerMap;
    }	
    
    public void deleteTrigger(List<sObject> selectedTriggers)
    {
        Map<string, List<sObject>> triggerMap = new Map<string, List<sObject>>();
        triggerMap.put('ApexTrigger', selectedTriggers);
        database.executeBatch(new ConfigurationCleanUpBatchService(triggerMap),100);
    }
}