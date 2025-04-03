/**
 * @description       : 
 * @author            : salesforce
 * @group             : gaurp
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public with sharing class ExternalVendorsIntegrationService {
    public static Map<String,String> getExternalServiceResult(String serviceName, String jsonPayload,List<Map<String, String>> params){
        return service().getExternalServiceResult(serviceName,jsonPayload,params);
    }
    /**
     * @description       :  Add Service Instance of Application Class
     * @return IFileUploadsService
     **/
    private static IExternalVendorsIntegrationService service(){
        return (IExternalVendorsIntegrationService) Application.SERVICE.newInstance(IExternalVendorsIntegrationService.class);
    }
}