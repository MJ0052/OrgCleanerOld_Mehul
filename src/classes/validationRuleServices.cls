public class validationRuleServices {
    
	public Map<string, List<String>> getValidationRule()
    {
        MetadataAPI mapi = new MetadataAPI();
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
        return ValidationRuleMap;
    }
    
}