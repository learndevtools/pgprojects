/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public inherited sharing class ContactChangeEvents extends fflib_SObjects implements IContactChangeEvents {
    /*
    */
    private static final string STATUS_NEW = 'New';
    private static final string CREATE_OPS = 'CREATE';
    private static final string UPDATE_OPS = 'UPDATE';
    private static final string UPSERT_OPS = 'UPSERT';
    private static final string TASK_MESSAGE_FOR_CREATE = System.label.TASK_MESSAGE_FOR_CREATE;
    private static final string TASK_MESSAGE_FOR_UPDATE = System.label.TASK_MESSAGE_FOR_UPDATE;

    public static Boolean stopRecursion = false;
    private static fflib_ISObjectUnitOfWork uow = null;
    /*
    * @description This method is being used to create a new Instance of the class
    * @param recordList List<ContactChangeEvent>
    * @return IContactChangeEvents
    */
    /*public static IContactChangeEvents newInstance(List<ContactChangeEvent> recordList){
        return (IContactChangeEvents) Application.DOMAIN.newInstance(recordList);
    }*/
    /*
    * @description This method is being used to create a new Instance of the class
    * @param recordSet Set<Id>
    * @return IContactChangeEvents
    */
     /*public static IContactChangeEvents newInstance(Set<Id> recordSet){
        return (IContactChangeEvents) Application.DOMAIN.newInstance(recordSet);
    }*/
    /*
    * @description - Parameterized constructor for the class
    * @param recordSet List<ContactChangeEvent>
    * @return void
    */
    public ContactChangeEvents(List<ContactChangeEvent> sObjectList){
        super(sObjectList, ContactChangeEvent.SObjectType);
    }
    /*
    * @description This method is being used to return the IOpportunities instance
    * @param recordSet Set<Id>
    * @return IOpportunities
    */
    public static void createContactChangeEventsTasks(List<ContactChangeEvent> contactChangeEventsRecords){
        List<Task> newTasksRecords = null;
        uow = Application.UOW.newInstance();
        newTasksRecords = new List<Task>();
        for(ContactChangeEvent contactChangeEventRecord : contactChangeEventsRecords){
                EventBus.ChangeEventHeader changeEventeHeader = contactChangeEventRecord.ChangeEventHeader;
                if(changeEventeHeader.changeType != CREATE_OPS && changeEventeHeader.changeType != UPDATE_OPS){
                    continue;
                }               
                for(String recordId : changeEventeHeader.recordIds){
                    uow.registerNew(
                        new Task(
                            Status = STATUS_NEW,
                            Subject = changeEventeHeader.changeType == CREATE_OPS ? TASK_MESSAGE_FOR_CREATE : TASK_MESSAGE_FOR_UPDATE,
                            OwnerId = changeEventeHeader.commituser,
                            WhoId = recordId
                        )
                    );
                }
        }
        commitWork(uow);
    }
    /*
    * @description This method is being used to return the IOpportunities instance
    * @param recordSet Set<Id>
    * @return IOpportunities
    */
    private static void commitWork(fflib_ISObjectUnitOfWork unitOfWork){
        unitOfWork.commitWork();
    }
    /*private static fflib_IDomainConstructor constructorMock;
    @TestVisible
    private static void setDomainMock(fflib_IDomainConstructor mock){
        constructorMock = mock;
    }*/
    public class Constructor implements fflib_IDomainConstructor{
        public fflib_SObjects construct(List<Object> objectList){
            return new ContactChangeEvents((List<SObject>)objectList);
        }
    }
}