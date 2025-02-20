/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 02-19-2025
 * @last modified by  : salesforce
**/
public class Application {
    public static final fflib_Application.UnitOfWorkFactory UOW = new fflib_Application.UnitOfWorkFactory(
        new List<SObjectType>{
            Account.SObjectType,
            Contact.SObjectType,
            File_Upload_Details__c.SObjectType
        }
    );
    public static final fflib_Application.ServiceFactory SERVICE = new fflib_Application.ServiceFactory(
        new Map<Type,Type>{
            IFileUploadsService.class => FileUploadsServiceImpl.class,
            IExternalVendorsIntegrationService.class => ExternalVendorsIntegrationServiceImpl.class,
            IHttpRequestsGetService.class => HttpRequestsGetServiceImpl.class
        }
    );   
}