/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-17-2025
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