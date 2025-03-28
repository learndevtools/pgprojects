/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 03-28-2025
 * @last modified by  : salesforce
**/
@isTest
private with sharing class PatientEvaluationComponentsTest {
    private static String VALIDATE_COMPONENT_RECORD = 'System should return component record for selected evaluation record Id';
    private static String VALIDATE_COMPONENT_RECORD_WITH_UNAUTHORIZED_USER = 'System should throw an error message';
    //Parameters for create New User
   	private static String USER_ALIAS = 'test2803';
    private static String USER_EMAIL = 'learndeavtools@outlook.com';
    private static String USER_LAST_NAME = 'Testing';
    private static String USER_FIRST_NAME = 'Testing';
    private static String USER_NAME = 'testing28032025@outlook.com';
    private static String USER_LANGUAGE_LOCALE_KEY = 'en_US';
    private static String USER_TIME_ZONE_SIDKEY = 'America/Chicago';
    private static String USER_EMAIL_ENCODING_KEY = 'UTF-8';
    private static String USER_LOCALE_SID_KEY = 'en_US';
    private static String USER_STANDARD_PROFILE = 'Standard User';
    private static String EVC_TYPE = 'Labs/Bloodwork';
    private static String EVC_STATUS = 'In Progress';
    private static String EVC_NOTES = 'Testing notes';
    private static String PD_DOCUMENT_TYPE = 'Medical Records';
    private static String EV_STATUS = 'In Progress';
    private static Decimal EV_PROGRESS = 10.2;
    private static String TP_BLOOD_TYPE = 'B-';
    private static String TP_CURRENT_STATUS = 'Referred';
    private static String TP_INSURANCE = 'Medicare';
    private static String TP_MRN = 'MRN-00001';
    private static String TP_ORGAN_TYPE = 'Kidney';
    @TestSetup
    static void setupEvaluationRecord(){
      User standardUser = new User(
          ProfileId = standardUserProfile(),
          Alias= USER_ALIAS,
          Email=USER_EMAIL,
          LastName =USER_LAST_NAME,
          FirstName = USER_FIRST_NAME,
          UserName=USER_NAME,
          LanguageLocaleKey=USER_LANGUAGE_LOCALE_KEY,
          TimeZoneSidKey=USER_TIME_ZONE_SIDKEY,
          EmailEncodingKey=USER_EMAIL_ENCODING_KEY,
          LocaleSidKey=USER_LOCALE_SID_KEY         
      );
      insert standardUser;
      Transplant_Patient__c transplanRecord = createTransplantPatientRecord();
      Evaluation__c evalRecord = createPatientEvaluationRecord(transplanRecord.Id);
      Patient_Document__c patientDocRecord = createPatientDocumentRecord(transplanRecord.Id,evalRecord.Id);
      Evaluation_Component__c  evalCompRecord = createEvaluationComponentRecord(evalRecord.Id);
    }
    @IsTest
    static void validateEvaluationComponentWhenEvaluationCreated() {
      List<Evaluation_Component__c> evalCompRecords = null;
      Id evaluationRecord = [SELECT ID FROM Evaluation__c LIMIT 1]?.Id;
        Test.startTest();
            evalCompRecords = PatientEvaluationComponents.getEvaluationComponents(evaluationRecord);
        Test.stopTest();
        System.Assert.isNotNull(evalCompRecords, VALIDATE_COMPONENT_RECORD);
        
    }
    @IsTest
    static void validateEvaluationComponentForWithoutHavingPermissionWhenEvaluationCreated() {
      List<Evaluation_Component__c> evalCompRecords = null;
      Boolean isError = false;
      Id evaluationRecord = [SELECT ID FROM Evaluation__c LIMIT 1]?.Id;
        Test.startTest();
          System.runAs(getStandardUser()) {
              try{
                  evalCompRecords = PatientEvaluationComponents.getEvaluationComponents(evaluationRecord);
              }catch(Exception ex){
                isError = true;
              }
          }
          Test.stopTest();
          System.Assert.isTrue(isError, VALIDATE_COMPONENT_RECORD_WITH_UNAUTHORIZED_USER);
    }
    private static Transplant_Patient__c createTransplantPatientRecord(){
      Transplant_Patient__c transplanRecord = new  Transplant_Patient__c();
      transplanRecord.Blood_Type__c = TP_BLOOD_TYPE;
      transplanRecord.Date_of_Birth__c = Date.newInstance(1977,6,7);
      transplanRecord.Current_Status__c=TP_CURRENT_STATUS;
      transplanRecord.Insurance__c = TP_INSURANCE;
      transplanRecord.MRN__c=TP_MRN;
      transplanRecord.Organ_Type__c =TP_ORGAN_TYPE;
      insert transplanRecord;
      return transplanRecord;
   }
   private static Evaluation__c createPatientEvaluationRecord(Id patientRecordId){
       Evaluation__c evalRecord = new Evaluation__c();
       evalRecord.Patient__c = patientRecordId;
       evalRecord.Progress__c = EV_PROGRESS;
       evalRecord.Status__c = EV_STATUS;
       evalRecord.Start_Date__c = Date.today();
       insert evalRecord;
       return evalRecord;
   }
   private static Patient_Document__c createPatientDocumentRecord(Id patientRecordId, Id eveluationId){
      Patient_Document__c patientDocRecord = new Patient_Document__c();
      patientDocRecord.Date_Received__c = DateTime.now();
      patientDocRecord.Document_Type__c = PD_DOCUMENT_TYPE;
      patientDocRecord.Patient__c = patientRecordId;
      patientDocRecord.Evaluation__c = eveluationId;
      insert patientDocRecord;
      return patientDocRecord;
   }
   private static Evaluation_Component__c createEvaluationComponentRecord(Id eveluationId){
       Evaluation_Component__c evalCompRecord = new Evaluation_Component__c();
       evalCompRecord.Completion_Date__c = System.today();
       evalCompRecord.Evaluation__c = eveluationId;
       evalCompRecord.Notes__c = EVC_NOTES;
       evalCompRecord.Status__c = EVC_STATUS;
       evalCompRecord.Type__c = EVC_TYPE;
        insert evalCompRecord;
       return evalCompRecord; 
   }
   private static Id standardUserProfile(){
      return [
        SELECT
          Id
        FROM
          Profile
        WHERE
          Name = :USER_STANDARD_PROFILE
        LIMIT 1
      ]?.Id;
   }
   private static User getStandardUser(){
      return [
        SELECT Id FROM User WHERE Alias= :USER_ALIAS LIMIT 1
      ]?.get(0);
   }
}