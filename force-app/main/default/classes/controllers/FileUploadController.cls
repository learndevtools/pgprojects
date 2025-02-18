/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-17-2025
 * @last modified by  : salesforce
**/
public with sharing class FileUploadController {
    @AuraEnabled
    public static Map<String,String> uploadFiles(String targetLocation, List<FileContentDocumentWrapper> fileContentDocumentWrapperList){
        return FileUploadsService.ftpFileUpload(fileContentDocumentWrapperList);
    }
}