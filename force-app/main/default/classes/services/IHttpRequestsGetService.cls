/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : salesforce
**/
public interface IHttpRequestsGetService {
    /**
     * @description:  Method to send the HttpRequest
     * @param jsonPayLoad
     * @param calloutEndPoint 
     * @return HttpResponse
     **/
    Map<String,String> sendHttpRequest(String jsonPayLoad,List<Map<String, String>> params);
}