public class EvaluationProgressCalculator {
    @future
    public static void calculateProgress(Set<Id> evaluationIds) {
        List<Evaluation__c> evaluationsToUpdate = new List<Evaluation__c>();
        
        for (Id evaluationId : evaluationIds) {
            // Count total components
            Integer totalComponents = [SELECT COUNT() FROM Evaluation_Component__c WHERE Evaluation__c = :evaluationId];
            
            // Count completed components
            Integer completedComponents = [SELECT COUNT() FROM Evaluation_Component__c 
                                         WHERE Evaluation__c = :evaluationId AND Status__c = 'Completed'];
            
            Decimal progress = 0;
            if (totalComponents > 0) {
                progress = ((Decimal)completedComponents / totalComponents) * 100;
            }
            
            Evaluation__c evaluation = new Evaluation__c(
                Id = evaluationId,
                Progress__c = progress
            );
            
            evaluationsToUpdate.add(evaluation);
        }
        
        if (!evaluationsToUpdate.isEmpty()) {
            update evaluationsToUpdate;
        }
    }
}