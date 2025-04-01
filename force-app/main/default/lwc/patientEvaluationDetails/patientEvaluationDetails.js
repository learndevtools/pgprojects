import { LightningElement, api, wire , track } from "lwc";
import EvaluationImage from '@salesforce/resourceUrl/EvaluationImage'
import getEvaluationComponents from "@salesforce/apex/PatientEvaluationComponents.getEvaluationComponents";
import {refreshApex} from '@salesforce/apex';
import {RefreshEvent, registerRefreshHandler, unregisterRefreshHandler} from 'lightning/refresh';
import {
	subscribe,
	unsubscribe,
	onError,
	setDebugFlag,
	isEmpEnabled
} from 'lightning/empApi';
export default class PatientEvaluationDetails extends LightningElement {
	@api recordId;
	@api objectApiName;
	@track storeEvaluationComponents;
	@track storeEvaluationComponentResults;
	evaluationsImage = EvaluationImage;	
	subscription={}
	channelName = '/event/Lightning_Component_Refresh__e';
	isSubscribeDisabled = false;
	isUnsubscribeDisabled = !this.isSubscribeDisabled;
	
	@wire(getEvaluationComponents, { recordId: "$recordId" })
	evaluationComponents(result) {
		this.storeEvaluationComponentResults = result;
		console.log('result=',result);
		let data = result.data;
		let error = result.error;
		if (data) {
			let readEvaluationComponents = [];
			let imageStaticPath = this.evaluationsImage;
			data.forEach(function(item){
				readEvaluationComponents = [...readEvaluationComponents,{
					type: item.Type__c,
					status: item.Status__c.toUpperCase(),
					date: item.Completion_Date__c,
					notes: item.Notes__c,
					imagepath: imageStaticPath+'/Images/'+item.Image_Path__c,
					color: 	item.Status__c == 'Completed' ? 'green' : (item.Status__c == 'In Progress' ? 'orange' : (item.Status__c == 'Not Started' ? 'lightcoral' : 'gray'))
				}]
			});
			console.log('readEvaluationComponents=',readEvaluationComponents);
			this.storeEvaluationComponents = readEvaluationComponents;
		}
		else if (error) {
			this.error = error;
			this.evaluationComponents = undefined;
		}}
		connectedCallback(){
			this.handleSubscribe();
		}
		disconnectedCallback(){
			this.handleUnsubscribe();
		}
		registerErrorListener(){
			onError((error)=>{
				console.log('Received error from server', JSON.stringify(error))
			});
		}
		handleSubscribe(){
			const self = this;
			const messageCallback = (response) => {
				console.log('Subscription sent to =>',JSON.stringify(response));
				self.refreshData();
			};
			subscribe(this.channelName, -1 ,messageCallback).then((response)=>{
				console.log('Subscription sent to2 =>',JSON.stringify(response));
				this.subscription = response;
			}).catch((error)=>{
				console.log('Subscription failed =>',JSON.stringify(error));
			});
		}
		handleUnsubscribe(){
			unsubscribe(this.subscription,(response)=>{
				console.log('Unsubscribed Successfully');
				
			});
		}
		refreshPage(){
			this.dispatchEvent(new RefreshEvent());
		}
		refreshData(){
			refreshApex(this.storeEvaluationComponentResults);
		}
}