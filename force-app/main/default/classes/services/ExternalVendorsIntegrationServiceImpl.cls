/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-21-2025
 * @last modified by  : salesforce
**/
public with sharing class ExternalVendorsIntegrationServiceImpl implements IExternalVendorsIntegrationService {
    public static final string KEY_STRING = 'key';
    public static final string VALUE_STRING = 'value';
    public static final string TYPE_STRING = 'type';
    public static final string SPACE = ' ';
    public Map<String,String> getExternalServiceResult(String serviceName, String jsonPayload,List<Map<String, String>> params){
        return HttpRequestsGetService.sendHttpRequest(jsonPayload,getExternalVendorCustomSettings(serviceName,params));
    }
    private List<Map<String, String>> getExternalVendorCustomSettings(String vendorName, List<Map<String, String>> params){
        if(params == null){
            params = new List<Map<String, String>>();
        }
        for(External_Service_Params__mdt externalServiceParam : new ExternalServiceParamsSelector().getExternalServiceParamsConfiguration(vendorName)){
            params.add(new Map<String, String>{
                KEY_STRING => externalServiceParam.Key__c,
                TYPE_STRING => ((String.isNotBlank(externalServiceParam.Key_Value_Prefix__c)?externalServiceParam.Key_Value_Prefix__c:SPACE)+SPACE+(externalServiceParam.Is_Required_Encoding__c?EncodingUtil.base64Encode(Blob.valueOf(externalServiceParam.Value__c)):externalServiceParam.Value__c)).trim(),
                TYPE_STRING => externalServiceParam.Type__c.toLowerCase()
            });

        }
        return params;
    }
}