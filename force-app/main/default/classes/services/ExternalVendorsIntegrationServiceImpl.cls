/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : salesforce
**/
public with sharing class ExternalVendorsIntegrationServiceImpl implements IExternalVendorsIntegrationService {
    public static final string FTP_CALLOUT_ENDPOINT = 'callout:Exchange_Rates';
    public static final string JSON_CONTENT_TYPE = 'application/json';
    public static final string GET_METHOD = 'GET';
    public static final string STATUS_KEY = 'status';
    public static final string MESSAGE_KEY = 'message';
    public static final string CONTENT_TYPE = 'Content-Type';
    public static final Integer SET_TIMEOUT = 120000;
    /*public void getReverseGeocoding(){
        Map<String,String> customSettingDetails = getExternalVendorCustomSettings('Reverse Geocoding(');
    }*/
    public Map<String,String> getExternalServiceResult(String serviceName){
        List<Map<String, String>> params = setParamsExternalVendorRequest(getExternalVendorCustomSettings(serviceName),GET_METHOD,JSON_CONTENT_TYPE);
        switch on serviceName{
            when 'Reverse Geocoding'{
                params.add(new Map<String, String>{
                    'key' => 'q',
                    'value' => '52.5432379%2C+13.4142133',
                    'type' => 'param'
                });
                params.add(new Map<String, String>{
                    'key' => 'pretty',
                    'value' => '1',
                    'type' => 'param'
                });
                params.add(new Map<String, String>{
                    'key' => 'no_annotations',
                    'value' => '1',
                    'type' => 'param'
                });
                
            }
        }
        return HttpRequestsGetService.sendHttpRequest(null,params);
    }
    private Map<String, String> getExternalVendorCustomSettings(String vendorName){
        return new Map<String, String>{
            'endpoint' => External_Vendor_API_Keys__c.getvalues(vendorName)?.Named_Credential__c??null,
            'apiKey' => External_Vendor_API_Keys__c.getvalues(vendorName)?.API_Key__c??null,
            'apiKeyField' => External_Vendor_API_Keys__c.getvalues(vendorName)?.API_Key_Param_Name__c??null,
            'timeOut' => String.valueOf(External_Vendor_API_Keys__c.getvalues(vendorName)?.Time_Out__c??null)
        };
    }
    private List<Map<String, String>> setParamsExternalVendorRequest(Map<String,String> customSettingDetails,String method,String contentType){
        return new List<Map<String, String>>{
            new Map<String, String>{
                'key' => 'endpoint',
                'value' => customSettingDetails.get('endpoint'),
                'type' => 'endpoint'
            },
            new Map<String, String>{
                'key' => 'method',
                'value' => method,
                'type' => 'method'
            },
            new Map<String, String>{
                'key' => 'timeout',
                'value' => String.valueOf(customSettingDetails.get('timeOut')),
                'type' => 'timeout'
            },
            new Map<String, String>{
                'key' => 'Content-Type',
                'value' => contentType,
                'type' => 'header'
            },
            new Map<String, String>{
                'key' => String.valueOf(customSettingDetails.get('apiKeyField')),
                'value' => String.valueOf(customSettingDetails.get('apiKey')),
                'type' => 'param'
            }
        };
    }
}