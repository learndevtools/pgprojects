import { LightningElement, api } from "lwc";
import {subscribe, unsubscribe, onError, setDebugFlage , isEmpEnabled} from 'lightning/empApi'
import {RefreshEvent, registerRefreshHandler, unregisterRefreshHandler} from 'lightning/refresh';
export default class DisplayRefreshMessage extends LightningElement {
	@api recordId;
	@api objectApiName;
	@api channelName = '/data/ContactChangeEvent';
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
			this.handleChangeResponse()
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
	handleChangeResponse(){
		console.log('Received Response');
		this.isDisplayBanner = true;
	}
	refreshPage(event){
		this.isDisplayBanner = false;
		
		this.dispatchEvent(new RefreshEvent());
	}
}