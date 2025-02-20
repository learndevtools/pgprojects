/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : salesforce
**/
public interface IExternalVendorsIntegrationService {
    //void getExchangeRates();
    Map<String,String> getExternalServiceResult(String serviceName);
}