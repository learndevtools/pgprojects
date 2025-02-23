/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-21-2025
 * @last modified by  : salesforce
**/
public interface IExternalServiceParamsSelector extends fflib_ISObjectSelector{
    /**
     * @description       : Get External Service Params Configuration
     * @param serviceName  : String
     * @return List<External_Service_Params__mdt>
     **/
    List<External_Service_Params__mdt> getExternalServiceParamsConfiguration(String serviceName);
}