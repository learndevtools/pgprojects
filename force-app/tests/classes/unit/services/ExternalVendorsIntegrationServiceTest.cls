/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : salesforce
**/
@isTest
public with sharing class ExternalVendorsIntegrationServiceTest {
    @IsTest
    private static void validateExtervalVendorWhenPass() {
        External_Vendor_API_Keys__c externalVendorAPIKey = createExternalVendorAPIKeyrecord();
        Test.startTest();
            Map<String, String> externalVendorIntegrations = ExternalVendorsIntegrationService.getExternalServiceResult('Reverse Geocoding');
        Test.stopTest();
        System.assertEquals(true, externalVendorIntegrations.size()>0, 'External Vendor Integration should not be null');
    }
    private static External_Vendor_API_Keys__c createExternalVendorAPIKeyrecord(){
        External_Vendor_API_Keys__c externalVendorAPIKey = new External_Vendor_API_Keys__c();
        externalVendorAPIKey.Name = 'Reverse Geocoding';
        externalVendorAPIKey.API_Key__c = '4f5a3d7a72aa42c187e549f8c74c12c7';
        externalVendorAPIKey.Named_Credential__c = 'callout:Reverse_Geocoding';
        externalVendorAPIKey.External_Vendor__c = 'Reverse Geocoding';
        externalVendorAPIKey.Time_Out__c = 2000;
        externalVendorAPIKey.API_Key_Param_Name__c = 'key';
        insert externalVendorAPIKey;
        return externalVendorAPIKey;
    }
}