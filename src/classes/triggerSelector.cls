public class triggerSelector {
	
    public list<ApexTrigger> getTriggerList()
    {
        list<ApexTrigger> at = new List<ApexTrigger>([Select TableEnumOrId,Name from ApexTrigger]);
        return at;
    }
}