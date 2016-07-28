public class pageService {
    List<List<String>> ListOfPages;
    public List<List<String>> getPages(){      
        List<ApexPage> ap = new List<ApexPage>([Select Id, Name From Apexpage]);
        ListOfPages = new List<List<String>>();
        list<String> pagelist;
        for(Apexpage a : ap){
            pagelist = new list<String>();
            pagelist.add('"'+string.valueOf(a.Name)+'"');
            ListOfPages.add(pagelist);
        }
        //deletePage(ap);
        return ListOfPages;
    }
    
     public void deletePage(List<sObject> selectedPages)
    {
        Map<string, List<sObject>> pageMap = new Map<string, List<sObject>>();
        pageMap.put('ApexPage', selectedPages);
        database.executeBatch(new ConfigurationCleanUpBatchService(pageMap),100);
    }
}