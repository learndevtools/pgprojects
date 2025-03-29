/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 03-27-2025
 * @last modified by  : salesforce
**/
public with sharing class EvaluationController {
    @AuraEnabled(cacheable=true)
    public static List<Evaluation_Component__c> getEvaluationComponents(Id evaluationId) {
        return [
            SELECT Id, Name, Type__c, Status__c, Due_Date__c, Completion_Date__c, Notes__c
            FROM Evaluation_Component__c
            WHERE Evaluation__c = :evaluationId
            WITH SECURITY_ENFORCED
            ORDER BY Type__c ASC
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Patient_Document__c> getPatientDocuments(Id evaluationId) {
        return [
            SELECT Id, Name, Document_Type__c, Date_Received__c, Verified__c, File_URL__c 
            FROM Patient_Document__c
            WHERE Evaluation__c = :evaluationId
            WITH SECURITY_ENFORCED
            ORDER BY Date_Received__c DESC
        ];
    }
    
    @AuraEnabled(cacheable=true)
    public static List<Appointment__c> getUpcomingAppointments(Id evaluationId) {
        return [
            SELECT Id, Appointment_Type__c, Start_Time__c, End_Time__c, Status__c, 
                   Location__c, Special_Requirements__c, Patient__r.Name
            FROM Appointment__c
            WHERE Evaluation__c = :evaluationId
            AND Start_Time__c >= TODAY
            WITH SECURITY_ENFORCED
            ORDER BY Start_Time__c ASC
        ];
    }
    
    @AuraEnabled
    public static void updateEvaluationComponentStatus(Id componentId, String status) {
        // Security check
        List<Evaluation_Component__c> components = [
            SELECT Id, Status__c, Completion_Date__c
            FROM Evaluation_Component__c
            WHERE Id = :componentId
            WITH SECURITY_ENFORCED
        ];
        
        if (components.isEmpty()) {
            throw new AuraHandledException('Component not found or you do not have access.');
        }
        
        Evaluation_Component__c component = components[0];
        component.Status__c = status;
        
        // If status is 'Completed', set completion date
        if (status == 'Completed') {
            component.Completion_Date__c = Date.today();
        } else {
            component.Completion_Date__c = null;
        }
        
        try {
            Database.update(component, AccessLevel.USER_MODE);
        } catch (Exception e) {
            throw new AuraHandledException('Error updating component: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Decimal calculateEvaluationProgress(Id evaluationId) {
        // Count total components and completed components
        AggregateResult[] totalResults = [
            SELECT COUNT(Id) totalCount 
            FROM Evaluation_Component__c 
            WHERE Evaluation__c = :evaluationId
            WITH SECURITY_ENFORCED
        ];
        
        AggregateResult[] completedResults = [
            SELECT COUNT(Id) completedCount 
            FROM Evaluation_Component__c 
            WHERE Evaluation__c = :evaluationId
            WITH SECURITY_ENFORCED
            //AND Status__c = 'Completed'
        ];
        
        // Calculate percentage
        Integer totalCount = (Integer) totalResults[0].get('totalCount');
        Integer completedCount = (Integer) completedResults[0].get('completedCount');
        
        Decimal progressPercentage = 0;
        if (totalCount > 0) {
            progressPercentage = ((Decimal) completedCount / totalCount) * 100;
        }
        
        // Update the evaluation record with new progress
        List<Evaluation__c> evaluations = [
            SELECT Id, Progress__c FROM Evaluation__c WHERE Id = :evaluationId WITH SECURITY_ENFORCED
        ];
        
        if (!evaluations.isEmpty()) {
            Evaluation__c eval = evaluations[0];
            eval.Progress__c = progressPercentage;
            Database.update(eval, AccessLevel.USER_MODE);
        }
        
        return progressPercentage;
    }
    
    @AuraEnabled
    public static Id scheduleAppointment(Appointment__c appointment) {
        // Validate input
        if (appointment.Start_Time__c == null || appointment.Evaluation__c == null) {
            throw new AuraHandledException('Required fields missing for appointment creation.');
        }
        
        try {
            Database.update(appointment, AccessLevel.USER_MODE);
            return appointment.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error creating appointment: ' + e.getMessage());
        }
    }
    
    @AuraEnabled
    public static Id uploadDocument(Id patientId, Id evaluationId, String fileUrl) {
        Patient_Document__c doc = new Patient_Document__c(
            Name = 'UploadDocument.txt',
            Document_Type__c = 'txt',
            Patient__c = patientId,
            Evaluation__c = evaluationId,
            Date_Received__c = Datetime.now(),
            File_URL__c = fileUrl
        );
        
        try {
            Database.insert(doc, AccessLevel.USER_MODE);
            return doc.Id;
        } catch (Exception e) {
            throw new AuraHandledException('Error uploading document: ' + e.getMessage());
        }
    }
}