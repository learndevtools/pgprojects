/**
 * @description       : 
 * @author            : salesforce
 * @group             : gaurp
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public interface IExternalVendorsIntegrationService {
    //void getExchangeRates();
    Map<String,String> getExternalServiceResult(String serviceName, String jsonPayload,List<Map<String, String>> params);
    //Map<String,String> postExternalServiceResult(String serviceName, String jsonPayload);
}