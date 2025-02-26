/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-25-2025
 * @last modified by  : salesforce
**/
List<Map<String, String>> params = new List<Map<String, String>>();
/*params.add(new Map<String, String>{
    'key' => 'q',
    'value' => '52.5432379%2C+13.4142133',
    'type' => 'param'
});*/
//Map<String,String> result =ExternalVendorsIntegrationService.getExternalServiceResult('Reverse Geocoding',null, params);
//ReverseGeocodingWrapper res= (ReverseGeocodingWrapper) System.JSON.deserialize(result.get('ResponseBody'),ReverseGeocodingWrapper.class );
//System.debug(result);

//Map<String,String> result =ExternalVendorsIntegrationService.getExternalServiceResult('Exchange Rates',null, null);
//ReverseGeocodingWrapper res= (ReverseGeocodingWrapper) System.JSON.deserialize(result.get('ResponseBody'),ReverseGeocodingWrapper.class );

/*params.add(new Map<String, String>{
    'key' => 'email',
    'value' => 'gaur.puneet@outlook.com',
    'type' => 'param'
});
Map<String,String> result =ExternalVendorsIntegrationService.getExternalServiceResult('Email Validation API',null, params);
System.debug(result);*/

Map<String,String> result =ExternalVendorsIntegrationService.getExternalServiceResult('LinkedIn_Get',null, null);
System.debug(result.get('status'));
