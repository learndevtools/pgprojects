/**
 * @description       : 
 * @author            : salesforce
 * @group             : gaurp
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public interface IFileUploadsService {
    /**
     * @description       :  Method to load file to FTP locations
     * @param fileContentDocumentWrapperList
     * @return String
     **/
    Map<String, String> ftpFileUpload(List<FileContentDocumentWrapper> fileContentDocumentWrapperList);
}