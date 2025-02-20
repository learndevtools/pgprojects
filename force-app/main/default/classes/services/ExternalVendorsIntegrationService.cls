/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : salesforce
**/
public with sharing class ExternalVendorsIntegrationService {
    public static Map<String,String> getExternalServiceResult(String serviceName){
        return service().getExternalServiceResult(serviceName);
    }
    /**
     * @description       :  Add Service Instance of Application Class
     * @return IFileUploadsService
     **/
    private static IExternalVendorsIntegrationService service(){
        return (IExternalVendorsIntegrationService) Application.SERVICE.newInstance(IExternalVendorsIntegrationService.class);
    }
}