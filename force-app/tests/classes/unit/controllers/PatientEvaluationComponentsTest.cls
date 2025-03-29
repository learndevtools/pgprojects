/**
 * @description       : 
 * @author            : salesforce
 * @group             : 
 * @last modified on  : 03-28-2025
 * @last modified by  : salesforce
**/
@isTest
@SuppressWarnings('PMD.TooManyFields')
private with sharing class PatientEvaluationComponentsTest {
    private static String VALIDATE_COMPONENT_RECORD = 'System should return component record for selected evaluation record Id';
    private static String VALIDATE_COMPONENT_RECORD_WITH_UNAUTHORIZED_USER = 'System should throw an error message';
    //Parameters for create New User
   	private static String USER_ALIAS = 'test28';
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
    private static String HRSA_PERMISISON_SET = 'HRSA_App_Access';
    @TestSetup
    static void setupEvaluationRecord(){

      User standardUser2 = createUser('2');
      Transplant_Patient__c transplanRecord = createTransplantPatientRecord();
      Evaluation__c evalRecord = createPatientEvaluationRecord(transplanRecord.Id);
      Patient_Document__c patientDocRecord = createPatientDocumentRecord(transplanRecord.Id,evalRecord.Id);
      Evaluation_Component__c  evalCompRecord = createEvaluationComponentRecord(evalRecord.Id);
    }
    @IsTest
    static void validateEvaluationComponentWhenEvaluationCreated() {
      List<Evaluation_Component__c> evalCompRecords = null;
      Id evaluationRecord = [SELECT ID FROM Evaluation__c LIMIT 1]?.Id;
      User standardUser = createUser('1');
      setPermissionSet(standardUser.Id);
        Test.startTest();
        System.runAs(getStandardUser(USER_ALIAS+'1')) {
            evalCompRecords = PatientEvaluationComponents.getEvaluationComponents(evaluationRecord);
        }
        Test.stopTest();
        System.Assert.isNotNull(evalCompRecords, VALIDATE_COMPONENT_RECORD);
        
    }
    @IsTest
    static void validateEvaluationComponentForWithoutHavingPermissionWhenEvaluationCreated() {
      List<Evaluation_Component__c> evalCompRecords = null;
      Boolean isError = false;
      Id evaluationRecord = [SELECT ID FROM Evaluation__c LIMIT 1]?.Id;
        Test.startTest();
          System.runAs(getStandardUser(USER_ALIAS+'2')) {
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
   private static User getStandardUser(String userAlias){
       System.debug('userAlias='+userAlias+'=');
       User userRecord=[
        SELECT Id FROM User WHERE Alias= :userAlias LIMIT 1
      ]?.get(0);
        System.debug('userAlias='+userAlias+'='+userRecord);
       return [
        SELECT Id FROM User WHERE Alias= :userAlias LIMIT 1
      ]?.get(0);
   }
   private static User createUser(String userNumber){
      User standardUser = new User();
      standardUser.ProfileId = standardUserProfile();
      standardUser.Alias= USER_ALIAS+userNumber;
      standardUser.Email=USER_EMAIL;
      standardUser.LastName =USER_LAST_NAME+userNumber;
      standardUser.FirstName = USER_FIRST_NAME+userNumber;
      standardUser.UserName=USER_NAME+userNumber;
      standardUser.LanguageLocaleKey=USER_LANGUAGE_LOCALE_KEY;
      standardUser.TimeZoneSidKey=USER_TIME_ZONE_SIDKEY;
      standardUser.EmailEncodingKey=USER_EMAIL_ENCODING_KEY;
      standardUser.LocaleSidKey=USER_LOCALE_SID_KEY;
      insert standardUser;
       System.debug('standardUser='+standardUser);
      return standardUser;
   }
   private static void setPermissionSet(Id userId){
      Id permissionsetId = [
         SELECT
           Id
         FROM
           PermissionSet
           WHERE
              Name = :HRSA_PERMISISON_SET
         LIMIT 1
       ]?.Id;
       insert new PermissionSetAssignment(AssigneeId = userId, PermissionSetId = permissionsetId);
   }
}