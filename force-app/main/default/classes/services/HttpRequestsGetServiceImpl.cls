/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : salesforce
 * How to use this service
 * sendHttpRequest => Public method to consume from other classes. This method accepts two parameter
 * 1. jsonPayLoad => JSON Payload to be sent in the request, if not required pass null
 * 2. params => List of Map<String, String> to set the request parameters. Below is the sample request parameters
 * 3. return => Map<String, String> with status, message, StatusCode and ResponseBody
 * Example return=> {StatusCode=200, message=Request has been processed successfully, status=success, responseBody = Response Body}
 * Example params=>List<Map<String, String>> params =new List<Map<String, String>>{
            new Map<String, String>{
                'key' => 'endpoint',
                'value' => customSettingDetails.get('endpoint'),
                'type' => 'endpoint'
            },
            new Map<String, String>{
                'key' => 'method',
                'value' => 'GET',
                'type' => 'method'
            },
            new Map<String, String>{
                'key' => 'timeout',
                'value' => String.valueOf(customSettingDetails.get('timeOut')),
                'type' => 'timeout'
            },
            new Map<String, String>{
                'key' => 'from',
                'value' => 'USD',
                'type' => 'param'
            },
            new Map<String, String>{
                'key' => 'to',
                'value' => 'ISD',
                'type' => 'param'
            }
            ,
            new Map<String, String>{
                'key' => 'Content-Type',
                'value' => 'application/json',
                'type' => 'header'
            }
}
**/
public with sharing class HttpRequestsGetServiceImpl implements IHttpRequestsGetService {
    public static final string STATUS_KEY = 'status';
    public static final string MESSAGE_KEY = 'message';
    public static final String STATUS_SUCCESS = 'success';
    public static final String STATUS_ERROR = 'error';
    public static final String STATUS_SUCCESS_MESSAGE = 'Request has been processed successfully';
    public static final String STATUS_ERROR_MESSAGE = 'Error while processing the request';
    public static final String STATUS_CODE = 'StatusCode';
    public static final String RESPONSE_BODY = 'ResponseBody';
    public static final Integer SUCCESS_STATUS_CODE = 200;
    public static final Integer EXCEPTION_STATUS_CODE = 501;
    public static final String TYPE = 'type';  
    public static final String HEADER = 'header';  
    public static final String PARAM = 'param';  
    public static final String METHOD = 'method';  
    public static final String END_POINT = 'endPoint';
    public static final String TIMEOUT = 'timeout';
    public static final String KEY = 'key';
    public static final String VALUE = 'value';
    public static final String EQUAL_OPERATOR = '=';
    public static final String AND_OPERATOR = '&';
    public static final String QUESTION_MARK = '?';
    enum TYPE{
        HEADER,
        PARAM,
        METHOD,
        ENDPOINT,
        TIMEOUT
    }
    /*
     * @description       :  Method to send the HttpRequest
     * @param jsonPayLoad
     * @param externalVendor 
     * @return Map<String, String>
     **/
    public Map<String, String> sendHttpRequest(String jsonPayLoad,List<Map<String, String>> params){
        Http http = new Http();
        HttpRequest req;
        HttpResponse response = new HttpResponse();
        try{
            req = setHttpRequestBody(params);
            if(String.isNotBlank(jsonPayLoad)){
                req.setBody(jsonPayLoad);
            }
            response = http.send(req);
            return response.getStatusCode() == SUCCESS_STATUS_CODE?setRespopnse(STATUS_SUCCESS,STATUS_SUCCESS_MESSAGE,response.getStatusCode(),response.getBody()):setRespopnse(STATUS_ERROR,STATUS_ERROR_MESSAGE,response.getStatusCode(), response.getBody());
        }catch(System.CalloutException exCallOut){
            return setRespopnse(STATUS_ERROR,STATUS_ERROR_MESSAGE,EXCEPTION_STATUS_CODE, exCallOut.getMessage());
        }catch(System.Exception ex){
            return setRespopnse(STATUS_ERROR,STATUS_ERROR_MESSAGE,EXCEPTION_STATUS_CODE, ex.getMessage());
        }
    }
    /*
     * @description       :  Set the reponse body
     * @param status (succes, error, exception)
     * @param message 
     * @param statusCode
     * @param responseBody
     * @return Map<String, String>
     * Example - {StatusCode=200, message=Request has been processed successfully, status=success, responseBody = Response Body}
     **/
    @SuppressWarnings('PMD.ExcessiveParameterList')
    private Map<String, String> setRespopnse(String status, String message, Integer statusCode, String responseBody){
        return new Map<String,String>{
            STATUS_KEY => status,
            MESSAGE_KEY => message,
            STATUS_CODE => String.valueOf(statusCode),
            RESPONSE_BODY => responseBody
        };
    }
    /*
     * @description       :  Set the HttpRequest Body
     * @param params
     * @return HttpRequest
     **/
    @SuppressWarnings({'PMD.CognitiveComplexity','PMD.CyclomaticComplexity'})
    private HttpRequest setHttpRequestBody(List<Map<String, String>> params){
        HttpRequest req = new HttpRequest();
        List<String> queryParam = new List<String>();
        for(Map<String,String> param : params){
            switch on param.get('type'){
                when 'header'{
                    if (String.isNotBlank(param.get(KEY)) && String.isNotBlank(param.get(VALUE))) {
                        req.setHeader(param.get(KEY), param.get(VALUE));
                    }
                }
                when 'timeout'{
                    if (String.isNotBlank(param.get(VALUE))) {
                        req.setTimeout(Integer.valueOf(param.get(VALUE)));
                    }
                }
                when 'endpoint' {
                    if (String.isNotBlank(param.get(VALUE))) {
                        req.setEndPoint(param.get(VALUE));
                    }
                }
                when 'method'{
                    if (String.isNotBlank(param.get(VALUE))) {
                        req.setMethod(param.get(VALUE));
                    }
                }
                when 'param' {
                    if (String.isNotBlank(param.get(KEY)) && String.isNotBlank(param.get(VALUE))) {
                        queryParam.add(param.get(KEY)+EQUAL_OPERATOR+param.get(VALUE));
                    } else {
                        continue;
                    }
                }
            }
        }
        if(!queryParam.isEmpty()){
            req.setEndPoint(req.getEndPoint()+QUESTION_MARK+String.join(queryParam,AND_OPERATOR));
        }
        return req;
    }
}