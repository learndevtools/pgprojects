import { LightningElement, api } from "lwc";
import { CloseActionScreenEvent } from 'lightning/actions';
import externalServiceCallout from "@salesforce/apex/LinkedInPostController.externalServiceCallout";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import postMessageBlank from '@salesforce/label/c.LINKED_IN_BLANK_POST_MESSAGE';
import userConnectionFailure from '@salesforce/label/c.LINKED_IN_CONNECTION_FAILURE';
import { createRecord } from "lightning/uiRecordApi";
import LINKED_IN_POST_MESSAGE_OBJECT from "@salesforce/schema/Linked_In_Post_Message__c";
import POST_MESSAGE_FIELD from "@salesforce/schema/Linked_In_Post_Message__c.LinkedIn_Post_Message__c";
import OBJECT_NAME_FIELD from "@salesforce/schema/Linked_In_Post_Message__c.Object_Name__c";
import RECORD_ID_FIELD from "@salesforce/schema/Linked_In_Post_Message__c.Record_Id__c";
import RESPONSE_BODY_FIELD from "@salesforce/schema/Linked_In_Post_Message__c.Response_Body__c";
import MESSAGE_FIELD from "@salesforce/schema/Linked_In_Post_Message__c.Response_Message__c";
import STATUS_FIELD from "@salesforce/schema/Linked_In_Post_Message__c.Status__c";
import STATUS_CODE_FIELD from "@salesforce/schema/Linked_In_Post_Message__c.Status_Code__c";
const LINKEDIN_GET ='LinkedIn_Get';
const LINKEDIN_POST ='LinkedIn_Post';
const SUCCESS = 'success';
const ERROR = 'error';
const REESPONSE_BODY ='ResponseBody';
const STATUS ='status';
const MESSAGE ='message';
const STATUS_CODE ='StatusCode'
const SUB ='sub';
export default class LwcLinkedInPostMessage extends LightningElement {
	@api recordId;
	@api objectApiName;
	userInfo =undefined;
	messageText = undefined;
	response = undefined;
	closeModal() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}
	connectedCallback() {
		if(!this.userInfo){
			this.getLinkedInUserInformation();
		}
	}
	getLinkedInUserInformation(){
		this.callLinkedInService(LINKEDIN_GET, null)
	}
	postMessages(event) {
			if(this.messageText && this.messageText.length>0){
				this.callLinkedInService(LINKEDIN_POST, JSON.stringify(this.postMessage))
			}				
			else{
				this.invokeToastMessage(null,postMessageBlank, ERROR, null, null);
			}
	}
	get postMessage(){
		return {
			"author": "urn:li:person:"+this.userInfo[SUB],
			"lifecycleState": "PUBLISHED",
			"specificContent": {
				"com.linkedin.ugc.ShareContent": {
					"shareCommentary": {
						"text": this.messageText
					},
					"shareMediaCategory": "NONE"
				}
			},
			"visibility": {
				"com.linkedin.ugc.MemberNetworkVisibility": "PUBLIC"
			}

		}
	}
	setMessageText(event){
		this.messageText = event.target.value;
	}
	invokeToastMessage(title, message , variant , messageData , mode){
        const toastEvent = new ShowToastEvent({
            title: title,
            message: message,
            variant: variant,
            messageData: messageData??null,
            mode: mode
        });
        this.dispatchEvent(toastEvent);
    }
	callLinkedInService(serviceName,
		jsonBody){
		externalServiceCallout({
			serviceName: serviceName,
			jsonBody:jsonBody,
			params: null})
		.then(result => {
			this.userInfo = undefined;
			if(result){
				if(serviceName === LINKEDIN_GET){
					this.userInfo = JSON.parse(result[REESPONSE_BODY]);
				}else{
					this.response = result;
					this.handleCreate();
					this.invokeToastMessage(null,result[MESSAGE], result[STATUS], null, null);					
					if(result[STATUS] === SUCCESS){
						this.dispatchEvent(new CloseActionScreenEvent());
					}
				}				
			}else{
				this.invokeToastMessage(null,userConnectionFailure, ERROR, null, null);
			}
		})
		.catch(error => {
			this.invokeToastMessage(null,JSON.stringify(error), ERROR,  null, null);
		});
	}

	async handleCreate(){
		const fields = {};
		fields[POST_MESSAGE_FIELD.fieldApiName] = this.messageText;
		fields[OBJECT_NAME_FIELD.fieldApiName] = this.objectApiName;
		fields[RECORD_ID_FIELD.fieldApiName] = this.recordId;
		fields[RESPONSE_BODY_FIELD.fieldApiName] =  JSON.stringify(this.response[REESPONSE_BODY]);
		fields[MESSAGE_FIELD.fieldApiName] = this.response[MESSAGE];
		fields[STATUS_FIELD.fieldApiName]= this.response[STATUS];
		fields[STATUS_CODE_FIELD.fieldApiName]= this.response[STATUS_CODE];
		const recordInput = { 
			apiName: LINKED_IN_POST_MESSAGE_OBJECT.objectApiName, 
			fields };
		try {
			const account =  await createRecord(recordInput);
		  } catch (error) {
				console.log('Error=>',JSON.stringify(error));
		  }
	}
}