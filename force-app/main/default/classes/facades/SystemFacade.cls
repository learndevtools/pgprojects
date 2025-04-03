/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public without sharing class SystemFacade {
    @TestVisible
    private static System.TriggerOperation triggerContext;
    public static System.TriggerOperation getTriggerContext(){
        return triggerContext == null ? Trigger.OperationType : triggerContext;
    }
}