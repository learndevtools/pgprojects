import { LightningElement, api } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';

export default class UploadFiles extends LightningElement {
	@api recordId;
	@api objectApiName;
	isDisplayModal = false;
	fileData;
	connectedCallback(){
		
	}
	disconnectedCallback(){
		//window.removeEventListener("message", this.openFileUpload(this));
	}
	uploadFile(){
		this.isDisplayModal = true;
	}
	closeModal(event){
		if(event.detail){
			this.isDisplayModal = false;
		}
	}
	handleFileUpload(event){
		const file = event.target.files[0];
		var reader = new FileReader();
		reader.onload =() =>{
			var base64 = reader.result.split(',')[1];
			this.fileData = {
				'filename' : file.name,
				'base64' : base64,
				'recordId' : this.recordId
			}
		}
		reader.readAsDataURL(file);
	}
	handleUploadFinished(event){
		const uploadedFiles = event.detail.files;
		this.isDisplayModal = false;
		this.dispatchEvent(new ShowToastEvent({
			title: null,
			message: uploadedFiles.length+' Files have been uploaded successfully',
			variant: 'success' //variant can be error
		}));
	}
}