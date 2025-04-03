/**
 * @description       : 
 * @author            : ChangeMeIn@UserSettingsUnder.SFDoc
 * @group             : gaurp
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public with sharing class PatientEvaluationComponents {
 @AuraEnabled(Cacheable=true)
 public static List<Evaluation_Component__c> getEvaluationComponents(String recordId){
    try {
        return [
            SELECT
                Id, 
                Name, 
                Evaluation__c, 
                Status__c, 
                Type__c, 
                Completion_Date__c, 
                Due_Date__c, 
                Notes__c,
                Image_Path__c
            FROM
                Evaluation_Component__c
            WHERE
                Evaluation__c =: recordId
            WITH SECURITY_ENFORCED
            
        ];
    } catch (Exception e) {
        throw new AuraHandledException(e.getMessage());
    }
 }
}