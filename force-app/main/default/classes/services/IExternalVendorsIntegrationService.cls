/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-21-2025
 * @last modified by  : salesforce
**/
public interface IExternalVendorsIntegrationService {
    //void getExchangeRates();
    Map<String,String> getExternalServiceResult(String serviceName, String jsonPayload,List<Map<String, String>> params);
    //Map<String,String> postExternalServiceResult(String serviceName, String jsonPayload);
}