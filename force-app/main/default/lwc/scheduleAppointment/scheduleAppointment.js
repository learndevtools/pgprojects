import { LightningElement, api } from "lwc";
import EVALUATION_COMPONENT from '@salesforce/schema/Appointment__c.Evaluation_Component__c';
import APPOINTMENT_TYPE from '@salesforce/schema/Appointment__c.Appointment_Type__c';
import START_TIME from '@salesforce/schema/Appointment__c.Start_Time__c';
import END_TIME from '@salesforce/schema/Appointment__c.End_Time__c';
import LOCATION from '@salesforce/schema/Appointment__c.Location__c';
import SPECIAL_LOCATION from '@salesforce/schema/Appointment__c.Special_Requirements__c';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
export default class ScheduleAppointment extends LightningElement {
	@api recordId;
	@api objectApiName;
	isDisplayModal = false;
	patientId='a05WK000007QxwUYAS';
	evaluationComponent;
	appointmentType;
	evaluationStartDateTime;
	evaluationEndDateTime;
	evaluationLocation;
	evaluationSpecialRequirement;
	scheduleAppointment(){
		this.isDisplayModal = true;
	}
	closeModal(event){
		if(event.detail){
			this.isDisplayModal = false;
		}
	}
	handleSubmit(event){
		alert('handleSubmit');
		//event.preventDefault();
		alert('Hello');
		const fields = this.template.querySelector('lightning-record-edit-form').fields;
		//const fields = event.target.fields;
		this.template.querySelector('lightning-record-edit-form').submit(fields);
		alert('Show Message');
		this.displayMessage();
	}
	saveForm(event){
		alert('Hello');
		this.handleSubmit();
	}
	handleSuccess(event){
		alert('Success');
		
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
}