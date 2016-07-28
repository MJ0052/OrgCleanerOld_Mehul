public with sharing class ContactTriggerHandlerClass extends BaseTrigger{
    
    // Constructor
    public ContactTriggerHandlerClass()
    {
    }
 
    public void bulkBefore()
    {
    }
 
    public void bulkAfter()
    {
    }
 
    public void beforeInsert(List<SObject> so)
    {
        Contact c;
    	List<Account> newaccount =new List<Account>();
    	map<String,ID> conAcc=new map<String,ID>();
    	for(SObject co:so)
    	{
    		c = (Contact)co;
    		if(c.AccountId==null)
    		{ 
    			Account a=new Account(Name='Accountof'+c.LastName);
    			newaccount.add(a);
    		}
    	}
    	insert newaccount;
    	Integer counter = 0;
    	for(SObject co:so)
    	{
    		Contact cobj = (Contact)co;
    		cobj.AccountID = newaccount[counter].id;
    		counter++;
    	}
    }
 
    public void beforeUpdate(Map<Id,SObject> oldSo, Map<Id,SObject> so)
    {
    }
    
    public void beforeDelete(List<SObject> so)
    {
        
    }
 
    public void afterInsert(List<SObject> so)
    {
        
        
    }
 
    public void afterUpdate(Map<id,sObject> oldMap, Map<Id,sObject> newMap)
    {
        
        
        
        
    }
 
    public void afterDelete(List<SObject> so)
    {
    }
 
    public void andFinally()
    {
        
    }
}