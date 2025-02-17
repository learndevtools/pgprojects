/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-17-2025
 * @last modified by  : salesforce
**/
public class FileContentDocumentWrapper {
    @AuraEnabled
    public String contentVerSionData {get;set;}
    @AuraEnabled
    public String contentFileName {get;set;}
    /*public FileContentDocumentWrapper(String contentVerSionData, String contentFileName){
        this.contentVerSionData = contentVerSionData;
        this.contentFileName = contentFileName;
    }
    public String getContentVerSionData(){
        return this.contentVerSionData;
    }
    public String getContentFileName(){
        return this.contentFileName;
    }*/
}