public with sharing class GetCheckinDate {
   // Make this method available for grounding
   // the Generate_Personalized_Schedule prompt template
   @InvocableMethod(
      CapabilityType='PromptTemplateType://einstein_gpt__salesEmail'
   )
   public static List<Response> getDate(List<Request> requests) {
      Request input = requests[0];
      Contact contact = input.Recipient;
      String nextCheckInDate = null;
      // Create input for query operation
      ConnectApi.CdpQueryInput queryInput = new ConnectApi.CdpQueryInput();
      queryInput.sql =
         'SELECT MIN(Check_in_Date__c) FROM Reservation__dlm JOIN UnifiedLinkssotIndividualCcid__dlm ON Contact_ID__c = SourceRecordId__c WHERE Check_in_Date__c >= NOW() AND UnifiedRecordId__c = (SELECT UnifiedRecordId__c FROM UnifiedLinkssotIndividualCcid__dlm WHERE SourceRecordId__c=\''+contact.Id+'\')';
      // Execute SQL
      ConnectApi.CdpQueryOutputV2 response = ConnectApi.CdpQuery.queryAnsiSqlV2(queryInput);
      if (response != null && response.data != null && !response.data.isEmpty()) {
         ConnectApi.CdpQueryV2Row resultRow = response.data[0];
         Object rowDataValue = resultRow.rowData[0];
         if (rowDataValue != null && rowDataValue instanceof String) {
            nextCheckInDate = (String) rowDataValue;
         }
      }
      // Create response
      List<Response> responses = new List<Response>();
      Response res = new Response();
      res.Prompt = nextCheckInDate;
      responses.add(res);
      return responses;
   }

   // The variables in this class need to match the prompt template inputs,
   // that may be different on each prompt template
   public class Request {
      @InvocableVariable(required=true)
      public Contact Recipient;
      @InvocableVariable(required=true)
      public User Sender;
   }
   public class Response {
      @InvocableVariable
      public String Prompt;
   }
}