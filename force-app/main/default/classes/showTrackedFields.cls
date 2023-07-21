public class showTrackedFields{

  // one idea to make this work for more than 100 objects is to create multiple SOQL statements that are looking in many objects each like
  //select EntityDefinition.QualifiedApiName id,DataType,NamespacePrefix,DeveloperName from FieldDefinition where EntityDefinition.QualifiedApiName in ( 'Account','Contact')
  
  public String result{ get; set; }
  public showTrackedFields(){
    result = '';
    String SOQL = '';
    Integer queryCount = 0;

    for (Schema.SObjectType obj : Schema.getGlobalDescribe().values()){
      if (queryCount < 100){
        //result+= 'trying Sobject: ' + obj ;
        try{
          Schema.DescribeSObjectResult objResult = obj.getDescribe();
          SOQL = 'SELECT QualifiedApiName FROM FieldDefinition WHERE EntityDefinition.QualifiedApiName = \'' + objResult.getName() + '\' AND IsFieldHistoryTracked = true';
          List<FieldDefinition> trackedFields = Database.query(SOQL);
          if (trackedFields.size() > 0){
            result += '<h1>' + objResult.getLabel() + '</h1><br/>';
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
  }
}