/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
trigger ContactChangeEventTrigger on ContactChangeEvent (after insert) {
    fflib_SObjectDomain.triggerHandler(ContactChangeEventsHandler.class);
}