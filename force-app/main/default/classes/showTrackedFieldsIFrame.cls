public class showTrackedFieldsIFrame{
    public String result{ get; set; }
    public showTrackedFieldsIFrame(){
        result = '';
        String SOQL = '';
        Integer queryCount = 0;
        Integer startIdx = Integer.valueOf(ApexPages.currentPage().getParameters().get('idx'));
        List<FieldDefinition> trackedFields = new List<FieldDefinition>();
        Integer totalTrackedFields = 0;
        Integer totalTrackedObjects = 0;
        List<Schema.SObjectType> objs = Schema.getGlobalDescribe().values();
        List<String> objectNames = new List<String>();
        For (Schema.SObjectType obj : objs){
            String name = obj.getDescribe().getName();
            // Exclude all the unwanted Sobjects e.g. History, Share etc.
            if (!name.containsignorecase('history') && !name.containsignorecase('tag') && !name.containsignorecase('share') && !name.containsignorecase('feed') && !name.containsignorecase('changeevent')){
                objectNames.add(name);
            }
        }
        //get the 100 names starting at this index (index *100)
        List<String> this100List = new List<String>();
        for (Integer i = (startIdx * 100); i < (startIdx * 100) + 100; i++){
            this100List.add(objectNames[i]);
        }
        for (String objName : this100List){
            if (queryCount < 100){
                try{
                    SOQL = 'SELECT QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = \'' + objName + '\' AND IsFieldHistoryTracked = true';
                    trackedFields = Database.query(SOQL);
                    if (trackedFields.size() > 0){
                        totalTrackedObjects += 1;
                        totalTrackedFields += trackedFields.size();
                        result += '<h1>' + objName + ' ('+trackedFields.size()+')</h1><br/>';
                        For (FieldDefinition field : trackedFields){
                            result += field.QualifiedApiName + '<br/>';
                        }
                        result += '<br/>';
                    }
                } catch (Exception e){
                    result += '*************************************' + e.getMessage();
                }
                queryCount += 1;
            }
        }
        result += '<script>window.parent.framesLoaded+=1;window.parent.numObjects+=' + totalTrackedObjects + ';window.parent.numFields+=' + totalTrackedFields + ';</script>';
    }
}