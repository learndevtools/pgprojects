/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 03-28-2025
 * @last modified by  : salesforce
**/
trigger EvaluationComponentTrigger on Evaluation_Component__c (after insert, after update, after delete) {
 Set<Id> evaluationIds = new Set<Id>();
    
    if (Trigger.isInsert || Trigger.isUpdate) {
        for (Evaluation_Component__c component : Trigger.new) {
            evaluationIds.add(component.Evaluation__c);
        }
    } 
    
    if (!evaluationIds.isEmpty()) {
        // Schedule the progress calculation to run asynchronously
        EvaluationProgressCalculator.calculateProgress(evaluationIds);
    }

}