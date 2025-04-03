/**
 * @description       : 
 * @author            : salesforce
 * @group             : gaurp
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public class FlatFileIntegration {
    public static void uploadFile(String message,String fileName){
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
        /*System.debug('response='+response.getBody());
        System.debug('message='+message);*/
    }
}