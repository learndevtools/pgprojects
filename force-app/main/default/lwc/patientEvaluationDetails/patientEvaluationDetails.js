import { LightningElement, api, wire , track } from "lwc";
import EvaluationImage from '@salesforce/resourceUrl/EvaluationImage'
import getEvaluationComponents from "@salesforce/apex/PatientEvaluationComponents.getEvaluationComponents";
export default class PatientEvaluationDetails extends LightningElement {
	@api recordId;
	@api objectApiName;
	@track storeEvaluationComponents;
	evaluationsImage = EvaluationImage;	
	@wire(getEvaluationComponents, { recordId: "$recordId" })
	evaluationComponents({ error, data }) {
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
}