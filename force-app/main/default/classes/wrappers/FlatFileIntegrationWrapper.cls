/**
 * @description       : 
 * @author            : salesforce
 * @group             : gaurp
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public class FlatFileIntegrationWrapper {
    @InvocableVariable
    public String path;
    @InvocableVariable
    public String body;
    @InvocableVariable
    public String fileName;
    public FlatFileIntegrationWrapper(String filePath, String strBody, String strFileName){
        this.path = filePath;
        this.body = EncodingUtil.base64Encode(Blob.valueOf(strBody));
        this.fileName = strFileName;
    }
    
}