/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public class Application {
    public static final fflib_Application.UnitOfWorkFactory UOW = new fflib_Application.UnitOfWorkFactory(
        new List<SObjectType>{
            Account.SObjectType,
            Contact.SObjectType,
            File_Upload_Details__c.SObjectType,
            Task.SObjectType
        }
    );
    public static final fflib_Application.ServiceFactory SERVICE = new fflib_Application.ServiceFactory(
        new Map<Type,Type>{
            IFileUploadsService.class => FileUploadsServiceImpl.class,
            IExternalVendorsIntegrationService.class => ExternalVendorsIntegrationServiceImpl.class,
            IHttpRequestsGetService.class => HttpRequestsGetServiceImpl.class
        }
    );  
    public static final fflib_Application.SelectorFactory SELECTOR = new fflib_Application.SelectorFactory(
        new Map<SObjectType,Type>{
            External_Service_Params__mdt.SObjectType => ExternalServiceParamsSelector.class
        }
    ); 
    public static final fflib_Application.DomainFactory DOMAIN = new fflib_Application.DomainFactory(
        Application.Selector,
        new Map<SObjectType, Type>{
            ContactChangeEvent.SObjectType => ContactChangeEvents.Constructor.class
        }
    );
}