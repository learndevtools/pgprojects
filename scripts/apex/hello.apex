/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-19-2025
 * @last modified by  : salesforce
**/
// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

/*Map<String,String> result =ExternalVendorsIntegrationService.getExternalServiceResult('Reverse Geocoding');
ReverseGeocodingWrapper res= (ReverseGeocodingWrapper) System.JSON.deserialize(result.get('ResponseBody'),ReverseGeocodingWrapper.class );
System.debug(res);*/
//	003DX00001ZtbIdYAJ
Primary_Contact_Uploads__e pte=new Primary_Contact_Uploads__e(Account_Id__c='001DX00001Ntp0WYAR');
EventBus.publish(pte);