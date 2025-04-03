/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public with sharing class ContactChangeEventsHandler extends ApplicationDomainHandler {
    public ContactChangeEventsHandler(List<ContactChangeEvent> sObjectList){
        super(sObjectList);

    }
    public override void onAfterInsert(){
        ContactChangeEvents.createContactChangeEventsTasks((List<ContactChangeEvent>) getRecords());
    }
    public class Constructor implements fflib_SObjectDomain.IConstructable{
        public fflib_SObjectDomain construct(List<SObject> sObjectList){
            return new ContactChangeEventsHandler(sObjectList);
        }
    }
}