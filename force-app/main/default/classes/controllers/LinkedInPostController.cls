/**
 * @description       : 
 * @author            : salesforce
 * @group             : gaurp
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public with sharing class LinkedInPostController {
    /*@AuraEnabled
    public static Map<String,String> getUserInforDetails() {
       return ExternalVendorsIntegrationService.getExternalServiceResult('LinkedIn_Get',null, null);
    }
    @AuraEnabled
    public static Map<String,String> postMessageToLinkedInChannel(String jsonBody){
        return ExternalVendorsIntegrationService.getExternalServiceResult('LinkedIn_Post',jsonBody, null);
    }*/
    @AuraEnabled
    public static Map<String,String> externalServiceCallout(String serviceName, String jsonBody, List<Map<String, String>> params) {
       return ExternalVendorsIntegrationService.getExternalServiceResult(serviceName,jsonBody, params);
    }
}