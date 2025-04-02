import { LightningElement, api } from "lwc";
import {subscribe, unsubscribe, onError, setDebugFlage , isEmpEnabled} from 'lightning/empApi'
import {RefreshEvent, registerRefreshHandler, unregisterRefreshHandler} from 'lightning/refresh';
import lightningConfirm from 'lightning/confirm';
import { notifyRecordUpdateAvailable } from 'lightning/uiRecordApi';
export default class DisplayRefreshMessage extends LightningElement {
	@api recordId;
	@api objectApiName;
	@api channelName = '/data/ContactChangeEvent';
	jsonResponse;
	isDisplayBanner = false;
	subscription = {}

	connectedCallback(){
		this.handleSubscribe();
		this.registerErrorListener();
	}

	disconnectedCallback(){
		this.handleUnsubscribe();
	}

	handleSubscribe(){
		const messageCallBack = (response)=>{
			console.log("New Message Received=", JSON.stringify(response));
			//this.isDisplayBanner = true;
			this.handleChangeResponse(response)
		}
		subscribe(this.channelName,-1,messageCallBack).then((response) =>{
			console.log("Subscription Request Sent", JSON.stringify(response));
			this.subscription = response;
		});
	}

	handleUnsubscribe(){
		unsubscribe(this.subscription, (response)=>{
			console.log("Unsubscription Request Sent", JSON.stringify(response));
		});
	}

	registerErrorListener(){
		onError((error) => {
            console.log('Received error from server: ', JSON.stringify(error));
            // Error contains the server-side error
        });
	}
	handleChangeResponse(response){
		if(response.hasOwnProperty('data')){
			let jsonObj = response.data;
			if(jsonObj.hasOwnProperty("payload")){
				let payload = jsonObj.payload;
				const isRecordFound = payload.ChangeEventHeader.recordIds.find((currItem)=> currItem === this.recordId);
				if(isRecordFound){
					this.isDisplayBanner = true;
				}
			}
		}
	}
	async refreshPage(event){
		const result = await lightningConfirm.open({
				message: 'Are you sure you want to refresh the page?',
				variant: 'header', //header or headerless
				label:'Please confirm',
				theme: 'error', //Valid values are "default", "shade","inverse", "alt-inverse", "success","success", "info", "warning", "error",and "offline".
				cancelLabel: 'No',
				confirmLabel: 'Yes'
		});
		if(result){
			//this.isDisplayBanner = false;
			//this.dispatchEvent(new RefreshEvent());
			await notifyRecordUpdateAvailable([{
				recordId: this.recordId
			}]).then(result=>{
				this.isDisplayBanner = false;
			}).catch(error=>{

			})
		}
		
	}
}