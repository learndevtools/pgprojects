/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
@isTest
public with sharing class ContactChangeEventsHandlerTest {
    private static final String TEST_CONTACT_FIRST_NAME = 'Puneet';
    private static final String TEST_CONTACT_LAST_NAME = 'Gaur';
    private static final String TEST_CONTACT_EMAIL = 'gaur.puneet@gmail.com';
    private static final String TEST_PRIMARY_CONTACT_EMAIL = 'gaur.puneet.primary@gmail.com';
    private static final String VALIDATE_TASK_RECORD_ON_NEW_CONTACTS = 'System should create a Task for new Contact';
    private static final String VALIDATE_TASK_RECORD_ON_UPDATE_EMAIL_CONTACTS = 'System should create a Task for update Email for selected contact';
    /**
     * @description - Setup Contact record to validate update scenario
     */
    @TestSetup
    static void setUpRecord(){
        Contact conRecord = new Contact(Firstname=TEST_CONTACT_FIRST_NAME,Lastname=TEST_CONTACT_LAST_NAME, Email=TEST_PRIMARY_CONTACT_EMAIL);
        insert conRecord;
    }
    /**
     * @description - Setup Contact record to validate new contact record
     */
    @IsTest
    static void validateTaskRecordWhenNewContactRecordCreation() {
        List<Task> taskList = null;
        Contact conRecord = null;
        Test.enableChangeDataCapture();
            conRecord = new Contact(Firstname=TEST_CONTACT_FIRST_NAME,Lastname=TEST_CONTACT_LAST_NAME, Email=TEST_CONTACT_EMAIL);
            insert conRecord;
        Test.getEventBus().deliver();
        taskList=getTaskRecords(conRecord.Id);
        System.assertEquals(1,taskList.size(),VALIDATE_TASK_RECORD_ON_NEW_CONTACTS);
    }
    /**
     * @description - Setup Contact record to validate update contact record
     */
    @IsTest
    static void validateTaskRecordWhenUpdateContactRecordCreation() {
        List<Task> taskList = null;
        Contact conRecord = null;
        Test.enableChangeDataCapture();
            conRecord = getContactRecord(TEST_PRIMARY_CONTACT_EMAIL);
            conRecord.Email = TEST_CONTACT_EMAIL;
            update conRecord;
        	
        Test.getEventBus().deliver();
        taskList=getTaskRecords(conRecord.Id);
        System.assertEquals(1,taskList.size(),VALIDATE_TASK_RECORD_ON_UPDATE_EMAIL_CONTACTS);
    }
    static List<Task> getTaskRecords(Id contactRecordId){
        return [
            SELECT 
                Id
            FROM 
                Task
            WHERE 
                WhoId =:contactRecordId
        ];
    }
    static Contact getContactRecord(String contactEmail){
        return [
            SELECT
                Id,
                Email
            FROM
                Contact
            WHERE
                Email =:contactEmail    
        ]?.get(0);
    }
}