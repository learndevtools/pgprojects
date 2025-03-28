import { LightningElement, api , wire } from "lwc";
import { getFieldValue, getRecord } from "lightning/uiRecordApi";
import PATIENT_NAME_FIELD from '@salesforce/schema/Evaluation__c.Patient__r.Name';
import DOB_FIELD from '@salesforce/schema/Evaluation__c.Patient__r.Date_of_Birth__c';
import BLOOD_TYPE_FIELD from '@salesforce/schema/Evaluation__c.Patient__r.Blood_Type__c';
import MRN_FIELD from '@salesforce/schema/Evaluation__c.Patient__r.MRN__c';
import ORGAN_TYPE_FIELD from '@salesforce/schema/Evaluation__c.Patient__r.Organ_Type__c';
import INSURANCE_FIELD from '@salesforce/schema/Evaluation__c.Patient__r.Insurance__c';
import STATUS_FIELD from '@salesforce/schema/Evaluation__c.Status__c';

export default class PatientEvaluationTile extends LightningElement {
	@api recordId;
	@api objectApiName;
	@wire(getRecord,{
		recordId: '$recordId',
		fields:[PATIENT_NAME_FIELD,DOB_FIELD,BLOOD_TYPE_FIELD,MRN_FIELD,ORGAN_TYPE_FIELD,INSURANCE_FIELD,STATUS_FIELD]
	})
	evaluationRecord;
	get name(){
		return 'Patient:' + getFieldValue(this.evaluationRecord.data,PATIENT_NAME_FIELD);
	}
	get status(){
		return getFieldValue(this.evaluationRecord.data,STATUS_FIELD);
	}
	get dob(){
		return getFieldValue(this.evaluationRecord.data,DOB_FIELD);
	}
	get mrn(){
		return getFieldValue(this.evaluationRecord.data,MRN_FIELD);
	}
	get organType(){
		return getFieldValue(this.evaluationRecord.data,ORGAN_TYPE_FIELD);
	}
	get insurance(){
		return getFieldValue(this.evaluationRecord.data,INSURANCE_FIELD);
	}
	get bloodType(){
		return getFieldValue(this.evaluationRecord.data,BLOOD_TYPE_FIELD);
	}
	get summary(){
		return `DOB: ${this.dob} | MRN: ${this.mrn} | Organ Type: ${this.organType} | Blood Type: ${this.bloodType} | Insurance: ${this.insurance} `
	}
	get evaluationStatus(){
		return this.status;
	}
	get panelStyle(){
		let color=this.evaluationStatus == 'Completed' ? 'green' : (this.evaluationStatus == 'In Progress' ? 'orange' : (this.evaluationStatus == 'Not Started' ? 'lightcoral' : 'gray'))
		return `text-color:white;text-wrap:nowrap;background-color:${color};height:45px`;
	}
}