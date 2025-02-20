/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : salesforce
**/
// Use .apex files to store anonymous Apex.
// You can execute anonymous Apex in VS Code by selecting the
//     apex text and running the command:
//     SFDX: Execute Anonymous Apex with Currently Selected Text
// You can also execute the entire file by running the command:
//     SFDX: Execute Anonymous Apex with Editor Contents

Map<String,String> result =ExternalVendorsIntegrationService.getExternalServiceResult('Reverse Geocoding');
ReverseGeocodingWrapper res= (ReverseGeocodingWrapper) System.JSON.deserialize(result.get('ResponseBody'),ReverseGeocodingWrapper.class );
System.debug(res);