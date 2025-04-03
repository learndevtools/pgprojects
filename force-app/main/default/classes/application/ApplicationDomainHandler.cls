/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public inherited sharing abstract class ApplicationDomainHandler extends fflib_SObjectDomain {
    public ApplicationDomainHandler(List<SObject> records){
        super(records);
    }
    /*protected void setContextBypass(Schema.SObjectType sObjectType, System.Type domainClass){
        System.TriggerOperation triggerContext = SystemFacade.getTriggerContext();
        return ;
    }*/
}