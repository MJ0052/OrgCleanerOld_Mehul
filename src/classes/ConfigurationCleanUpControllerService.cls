public class ConfigurationCleanUpControllerService {
    
    public Map <String, Schema.SObjectType> schemaMap {get;set;}
    public List<List<String>> ListOfObjects {get;set;}
    public List<List<String>> listOfClasses {get;set;}
    public List<List<String>> ListOfPages {get;set;}
    public List<List<String>> ListOfTriggers {get;set;}
    public List<List<String>> ListOfWorkflows {get;set;}
    public List<List<String>> ListOfValidationRules {get;set;}
    public set<set<String>> ListOfTriggerObjects {get;set;}
    public MetadataAPI mapi = new MetadataAPI();
    
    public ConfigurationCleanUpControllerService(){
    }
    
    /*   public void getObjects(){
schemaMap = Schema.getGlobalDescribe();
List<String> objects = new List<String>(schemaMap.keySet()); 
list<String> listobj;
ListOfObjects = new List<List<String>>(); 
for(String a:  objects){
listobj = new list<String>();
listobj.add('"'+a+'"');
ListOfObjects.add(listobj);
}
}*/
    
    public void getCustomObjects()
    {
        MetadataService.FileProperties[] fileproperties = mapi.listObjectsMetadata();
        List<String> CustomObjects = new List<String>();
        for(MetadataService.FileProperties fileProperty : fileproperties){
            if(fileProperty.fullName.contains('__c'))
            {
                CustomObjects.add(fileProperty.fullName);
                System.debug('Custom Object '+ fileProperty.fullName);
            }
        }
    }
    
    public void getPages(){      
        List<ApexPage> ap = new List<ApexPage>([Select Id, Name From Apexpage]);
        ListOfPages = new List<List<String>>();
        list<String> pagelist;
        for(Apexpage a : ap){
            pagelist = new list<String>();
            pagelist.add('"'+string.valueOf(a.Name)+'"');
            ListOfPages.add(pagelist);
        }
    }
    
    public void getClasses(){      
        List<ApexClass> ac = new List<ApexClass>([Select Id, Name From ApexClass]);
        listOfClasses = new List<List<String>>();
        list<String> listclass;
        for(ApexClass a : ac){
            listclass = new list<String>();
            listclass.add('"'+string.valueOf(a.Name)+'"');
            listOfClasses.add(listclass);
        }
    }
    
    public void getTriggers()
    {
        list<ApexTrigger> at = new List<ApexTrigger>([Select TableEnumOrId,Name from ApexTrigger]);
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
    }
    
    public void getWorkflow()
    {
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
        }System.debug('WorkflowMap'+ WorkflowMap);        
    }
    
    public void getValidationRule()
    {
        MetadataService.FileProperties[] fileproperties = mapi.listValidationRuleMetadata();
        Map<string, List<String>> ValidationRuleMap = new Map<string, List<String>>();
        list<String> ValidationRuleName;
        
        for(MetadataService.FileProperties fileProperty : fileproperties)
        {
            if(fileProperty.fullName != null && fileProperty.fullName != '')
            {
                ValidationRuleName = new List<String>();                
                string Objectname = fileProperty.fullName;
                if(ValidationRuleMap.containsKey(Objectname.substringBefore('.')))
                { 
                    ValidationRuleName.addAll(ValidationRuleMap.get(Objectname.substringBefore('.')));
                    ValidationRuleName.add(Objectname.substringAfter('.'));   
                }
                else{
                    ValidationRuleName.add(Objectname.substringAfter('.'));
                }
                ValidationRuleMap.put(Objectname.substringBefore('.'), ValidationRuleName);      
            }
        }System.debug('ValidationRuleMap'+ ValidationRuleMap);         
    }
    
    public void getFields()
    {
        MetadataService.FileProperties[] fileproperties = mapi.listFieldsMetadata();
        Map<string, List<String>> FieldsMap = new Map<string, List<String>>();
        list<String> FieldsName;
        
        for(MetadataService.FileProperties fileProperty : fileproperties)
        {
            if(fileProperty.fullName != null && fileProperty.fullName != '')
            {
                FieldsName = new List<String>();                
                string Objectname = fileProperty.fullName;
                if(FieldsMap.containsKey(Objectname.substringBefore('.')))
                { 
                    FieldsName.addAll(FieldsMap.get(Objectname.substringBefore('.')));
                    FieldsName.add(Objectname.substringAfter('.'));   
                }
                else{
                    FieldsName.add(Objectname.substringAfter('.'));
                }
                FieldsMap.put(Objectname.substringBefore('.'), FieldsName);      
            }
        }System.debug('FieldsMap'+ FieldsMap);         
    }
    
    public Map<string, List<Sobject>> getValidationRuleTest()
    {
        MetadataService.FileProperties[] fileproperties = mapi.listValidationRuleMetadata();
        Map<string, List<Sobject>> ValidationRuleMap = new Map<string, List<Sobject>>();
        list<Sobject> ValidationRuleName;
        if(fileproperties!=Null){
            for(MetadataService.FileProperties fileProperty : fileproperties)
            {
                ValidationRuleName = new list<Sobject>();
                string Objectname = fileProperty.fullName;
                System.debug('hi '+Objectname.substringAfter('.'));
                Schema.SObjectType convertType = Schema.getGlobalDescribe().get(Objectname.substringBefore('.'));
                System.debug('convertType : '+convertType);
               // Sobject genericObject = convertType.newSObject();
               // ValidationRuleName.add(genericObject);
               // System.debug('list : '+ValidationRuleName);
            }   ValidationRuleMap.put('ValidationRule', ValidationRuleName);   
            
        }
        return ValidationRuleMap;
    }
}