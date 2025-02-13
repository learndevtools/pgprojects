import { LightningElement, api } from "lwc";
import { CloseActionScreenEvent } from 'lightning/actions';
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
//import { RefreshEvent } from "lightning/refresh";
import {
	RefreshEvent,registerRefreshContainer
  } from "lightning/refresh";
export default class LwcFileUploadToSelectedTarget extends LightningElement {
	@api recordId;
	@api objectApiName;
	isFileUploaded = false;
	refreshHandlerId;
	get inputVariables(){
		if(this.recordId === undefined){
			return null;
		}
		return [
			{
				name : 'recordId',
				type : 'String',
				value : this.recordId
			}
		]
	}
	get options() {
        return [
            { label: 'FTP Folder', value: 'FTP' },
            { label: 'S3 Bucket', value: 'S3' }
        ];
    }
	get acceptedFormats() {
        return ['.pdf', '.png', '.csv'];
    }
	closeModal() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}
	handleUploadFinished(event){
		this.isFileUploaded = true;
		//alert('Hello');
		this.dispatchEvent(new RefreshEvent());
		this.refs.displayFile.resumeFlow(this.recordId);
	}
	handleStatusChange(event){
		alert('Hello');
		this.dispatchEvent(new RefreshEvent());
	}
	handleChange(event){

	}
	uploadFile(event){
		if(!this.isFileUploaded){
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'File Uploaded',
					message: 'Please upload file before procedding with the next step',	
					variant: 'success'
				})
			);
		}
	}
	connectedCallback(){
		this.isFileUploaded = false;
		this.refreshHandlerId = registerRefreshContainer(this,this.refreshHandler);
	}
	refreshHandler(){
		this.isFileUploaded = false;
		return new Promise(resolve=>{
			resolve(true);
		})
	}
}