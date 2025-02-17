/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-17-2025
 * @last modified by  : salesforce
**/
public with sharing class FileUploadsServiceImpl implements IFileUploadsService {
    public static final string COMMA_DELIMITER = ',';
    public static final string FTP_CALLOUT_ENDPOINT = 'callout:FlatFileNamedCredential';
    public static final string FILE_PATH = '/';
    public static final string HTTP_METHOD = 'POST';
    public static final string JSON_CONTENT_TYPE = 'application/json';
    public static final string JSON_OPEN_BRACKET = '[';
    public static final string JSON_CLOSED_BRACKET = ']';
    public static final string HEADER_CONTENT_KEY = 'Content-Type';
    public static final Integer STATUS_CODE = 200;
    public static final String STATUS_SUCCESS = 'Success';
    public static final String STATUS_ERROR = 'Error';
    public static final String STATUS_KEY = 'Status';
    public static final String MESSAGE_KEY = 'Message';
    public static final String STATUS_SUCCESS_MESSAGE = 'File has been uploaded successfully to selected target location';
    public static final String STATUS_ERROR_MESSAGE = 'Error while uploading file to selected target location';
    /**
     * @description       :  Method to load file to FTP locations
     * @param contentVerSionData
     * @param contentFileName 
     * @return String
     **/
    public Map<String, String> ftpFileUpload(List<FileContentDocumentWrapper> fileContentDocumentWrapperList){
        List<String> fileContentList = new List<String>();
        try{
            for(FileContentDocumentWrapper fileContentDocumentWrapper : fileContentDocumentWrapperList){
                fileContentList.add(JSON.serialize(new FlatFileIntegrationWrapper(
                    FILE_PATH,EncodingUtil.base64Encode(Blob.valueOf(fileContentDocumentWrapper.contentVerSionData)),fileContentDocumentWrapper.contentFileName
                )));
            }
            //System.debug('fileContentList'+fileContentList);
            if(fileContentList.isEmpty()){
                return getMessage(STATUS_ERROR,STATUS_ERROR_MESSAGE);
            }
            HttpResponse response = sendHttpRequest(JSON_OPEN_BRACKET+ String.join(fileContentList,COMMA_DELIMITER) +JSON_CLOSED_BRACKET,FTP_CALLOUT_ENDPOINT);
            return getMessage(response.getStatusCode() == STATUS_CODE?STATUS_SUCCESS:STATUS_ERROR,response.getStatusCode() == STATUS_CODE?STATUS_SUCCESS_MESSAGE:STATUS_ERROR_MESSAGE);
        }catch(Exception ex){
            return getMessage(STATUS_ERROR,ex.getMessage());
        }
        
    }
    /**
     * @description       :  Private method to send the HttpRequest
     * @param jsonPayLoad
     * @param calloutEndPoint 
     * @return String
     **/
    private HttpResponse sendHttpRequest(String jsonPayLoad,String calloutEndPoint){
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        HttpResponse response = new HttpResponse();
        try{
            req.setEndPoint(calloutEndPoint);
            req.setMethod(HTTP_METHOD);
            req.setHeader('Content-Type', JSON_CONTENT_TYPE);
            req.setBody(jsonPayLoad);
            req.setTimeout(120000);
            response = http.send(req);
            //System.debug('response='+response.getBody());
            return response;
        }catch(Exception ex){
            throw ex;
        }
    }
    private Map<String, String> getMessage(String status, String message){
        return new Map<String,String>{
            STATUS_KEY => status,
            MESSAGE_KEY => message
        };
    }
    /*public static void uploadFile(String jsonPayLoad,String fileName){
        FlatFileIntegrationWrapper obj = new FlatFileIntegrationWrapper(
        	'/',EncodingUtil.base64Encode(Blob.valueOf(message)),fileName
        );
        String jsonPayload = '['+JSON.serialize(obj) +']';
        HttpRequest req = new HttpRequest();
        req.setEndPoint('callout:FlatFileNamedCredential');
        req.setMethod('POST');
        req.setBody(jsonPayload);
        Http http =new Http();
        HttpResponse response = http.send(req);
        System.debug('response='+response.getBody());
        System.debug('message='+message);
    }*/
}