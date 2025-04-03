/**
 * @description       : 
 * @author            : salesforce
 * @group             : gaurp
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public with sharing class ExternalServiceParamsSelector extends fflib_SObjectSelector implements IExternalServiceParamsSelector {
    public static IExternalServiceParamsSelector newInstance(){
        return (IExternalServiceParamsSelector) Application.selector.newInstance(External_Service_Params__mdt.sObjectType);
    }
    public Schema.SObjectType getSObjectType(){
        return External_Service_Params__mdt.sObjectType;
    }
    public List<schema.SObjectField> getSObjectFieldList(){
        return new List<schema.SObjectField>{
            External_Service_Params__mdt.Id,
            External_Service_Params__mdt.MasterLabel,
            External_Service_Params__mdt.DeveloperName,
            External_Service_Params__mdt.Key__c,
            External_Service_Params__mdt.Value__c,
            External_Service_Params__mdt.Type__c,
            External_Service_Params__mdt.Is_Required_Encoding__c,
            External_Service_Params__mdt.Key_Value_Prefix__c
        };
    }
    public List<External_Service_Params__mdt> getExternalServiceParamsConfiguration(String serviceName){       
        fflib_QueryFactory queryFactory = newQueryFactory();
        queryFactory.setCondition('MasterLabel = :serviceName');
        return (List<External_Service_Params__mdt>) Database.query(queryFactory.toSOQL());
    }
}