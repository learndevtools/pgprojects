/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
@isTest
public  class SystemFacadeTest {
    @IsTest
    static void validateTriggetContextForNullInputs() {
        System.TriggerOperation triggerContext = null;
        Test.startTest();
        triggerContext = SystemFacade.getTriggerContext();
        Test.stopTest();
        System.assertEquals(null, triggerContext, 'Systme Facade should return null for null inputs');
    }
}