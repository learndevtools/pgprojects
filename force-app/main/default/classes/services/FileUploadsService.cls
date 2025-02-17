/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-17-2025
 * @last modified by  : salesforce
**/
public with sharing class FileUploadsService {
    /**
     * @description       :  Method to load file to FTP locations
     * @param fileContentDocumentWrapperList
     * @return String
     **/
    public static Map<String, String> ftpFileUpload(List<FileContentDocumentWrapper> fileContentDocumentWrapperList){
        return service().ftpFileUpload(fileContentDocumentWrapperList);
    }
    /**
     * @description       :  Add Service Instance of Application Class
     * @return IFileUploadsService
     **/
    private static IFileUploadsService service(){
        return (IFileUploadsService) Application.SERVICE.newInstance(IFileUploadsService.class);
    }
}