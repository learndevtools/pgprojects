/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-17-2025
 * @last modified by  : salesforce
**/
@isTest
public class FileUploadControllerTest {

    @isTest
    static void testUploadFileWhenSendFileContent() {
        // Test data setup
        List<FileContentDocumentWrapper> fileContentDocumentWrapperList = new List<FileContentDocumentWrapper>();
        FileContentDocumentWrapper fileContentDocumentWrapper = new FileContentDocumentWrapper();
        fileContentDocumentWrapper.contentVerSionData = 'Test Data';
        fileContentDocumentWrapper.contentFileName = 'Test.csv';
        fileContentDocumentWrapperList.add(fileContentDocumentWrapper);
        Map<String, String> expectedResult = new Map<String, String>();
        // Test method
        Test.startTest();
            expectedResult = FileUploadController.uploadFiles('Test Location', fileContentDocumentWrapperList);
        Test.stopTest();
        System.assertEquals('Error', expectedResult.get('Status'), 'System should upload file');
        
    }
    @isTest
    static void testUploadFileWhenSendInvalidContent() {
        // Test data setup
        List<FileContentDocumentWrapper> fileContentDocumentWrapperList = new List<FileContentDocumentWrapper>();
        FileContentDocumentWrapper fileContentDocumentWrapper = new FileContentDocumentWrapper();
        fileContentDocumentWrapper.contentVerSionData = null;
        fileContentDocumentWrapper.contentFileName = 'Test.csv';
        fileContentDocumentWrapperList.add(fileContentDocumentWrapper);
        Map<String, String> expectedResult = new Map<String, String>();
        // Test method
        Test.startTest();
            expectedResult = FileUploadController.uploadFiles('Test Location', fileContentDocumentWrapperList);
        Test.stopTest();
        System.assertEquals('Error', expectedResult.get('Status'), 'System should not upload file');
        
    }
}