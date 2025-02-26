import { LightningElement, api } from "lwc";
import { CloseActionScreenEvent } from 'lightning/actions';
import externalServiceCallout from "@salesforce/apex/LinkedInPostController.externalServiceCallout";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import postMessageBlank from '@salesforce/label/c.LINKED_IN_BLANK_POST_MESSAGE';
import userConnectionFailure from '@salesforce/label/c.LINKED_IN_CONNECTION_FAILURE';
const LINKEDIN_GET ='LinkedIn_Get';
const LINKEDIN_POST ='LinkedIn_Post';
const SUCCESS = 'success';
const ERROR = 'error';
const REESPONSE_BODY ='ResponseBody';
const STATUS ='status';
const MESSAGE ='message';
const SUB ='sub';
export default class LwcLinkedInPostMessage extends LightningElement {
	@api recordId;
	userInfo =undefined;
	messageText = undefined;
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
}