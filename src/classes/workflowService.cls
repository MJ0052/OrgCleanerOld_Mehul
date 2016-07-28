public class workflowService {
    
    public Map<string, List<String>> getWorkflow()
    {
        MetadataAPI mapi = new MetadataAPI();
        MetadataService.FileProperties[] fileproperties = mapi.listWorkflowMetadata();
        Map<string, List<String>> WorkflowMap = new Map<string, List<String>>();
        list<String> WorkflowName;
        
        for(MetadataService.FileProperties fileProperty : fileproperties)
        {
            if(fileProperty.fullName != null && fileProperty.fullName != '')
            {
                WorkflowName = new List<String>();                
                string Objectname = fileProperty.fullName;
                if(WorkflowMap.containsKey(Objectname.substringBefore('.')))
                { 
                    WorkflowName.addAll(WorkflowMap.get(Objectname.substringBefore('.')));
                    WorkflowName.add(Objectname.substringAfter('.'));   
                }
                else{
                    WorkflowName.add(Objectname.substringAfter('.'));
                }
                WorkflowMap.put(Objectname.substringBefore('.'), WorkflowName);      
            }
        }
        //System.debug('WorkflowMap'+ WorkflowMap);      
        return WorkflowMap;
    }
}