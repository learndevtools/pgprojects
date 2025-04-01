import { LightningElement, api, wire } from "lwc";
import EVALUATION_COMPONENT from '@salesforce/schema/Appointment__c.Evaluation_Component__c';
import APPOINTMENT_TYPE from '@salesforce/schema/Appointment__c.Appointment_Type__c';
import START_TIME from '@salesforce/schema/Appointment__c.Start_Time__c';
import END_TIME from '@salesforce/schema/Appointment__c.End_Time__c';
import LOCATION from '@salesforce/schema/Appointment__c.Location__c';
import SPECIAL_LOCATION from '@salesforce/schema/Appointment__c.Special_Requirements__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { getRecord, getFieldValue } from "lightning/uiRecordApi";
import PATIENT_RECORD_ID from "@salesforce/schema/Evaluation__c.Patient__c";
export default class ScheduleAppointment extends LightningElement {
	@api recordId;
	@api objectApiName;
	isDisplayModal = false;
	//patientId='a05WK000007QxwUYAS';
	evaluationComponent;
	appointmentType;
	evaluationStartDateTime;
	evaluationEndDateTime;
	evaluationLocation;
	evaluationSpecialRequirement;
	openScheduleAppointment(){
		this.isDisplayModal = true;
	}
	closeModal(event){
		if(event.detail){
			this.isDisplayModal = false;
		}
	}
	handleSubmit(event){
		event.preventDefault();
        const fields = event.detail.fields;
		//this.template.querySelector('lightning-record-edit-form').submit(fields);
		this.refs.recordEditForm.submit(fields);
	}
	handleSave(event){
		this.refs.recordEditForm.submit();
		/*if(this.validate()){
			this.refs.recordEditForm.submit();
		}else{
			alert('Error');
			this.dispatchEvent(new ShowToastEvent({
				title: null,
				message:' Please fill out the required fields.',
				variant: 'error' //variant can be error
			}));
		}*/
		
	}
	handleSuccess(event){
		this.displayMessage();
	}
	displayMessage(){
		this.isDisplayModal = false;
		this.dispatchEvent(new ShowToastEvent({
			title: null,
			message:' Files have been uploaded successfully',
			variant: 'success' //variant can be error
		}));
	}
	handleCancel(event){
		this.isDisplayModal = false;
	}
	@wire(getRecord,{recordId: '$recordId',fields: [PATIENT_RECORD_ID]})
	evaluationRecord;

	get patientId(){
		return getFieldValue(this.evaluationRecord.data, PATIENT_RECORD_ID);
	}
	validate(){
        let isValid = true;
        let fields = this.template.querySelectorAll('lightning-input-field');
        fields.forEach(field => {
            if(!field.checkValidity()) {
                field.reportValidity();
                isValid = false;
            }
        });
        return isValid;  
    }
}