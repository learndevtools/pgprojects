/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : salesforce
**/
public with sharing class HttpRequestsGetService {
    public static Map<String, String> sendHttpRequest(String jsonPayLoad,List<Map<String, String>> params){
        return service().sendHttpRequest(jsonPayLoad,params);
    }
    /**
     * @description       :  Add Service Instance of Application Class
     * @return IFileUploadsService
     **/
    private static IHttpRequestsGetService service(){
        return (IHttpRequestsGetService) Application.SERVICE.newInstance(IHttpRequestsGetService.class);
    }
}