import { LightningElement , api } from 'lwc';

export default class OppRecordForm extends LightningElement {
    @api recordId;
    @api objectApiName;
    handleSuccess(event){
            const evt = new CustomEvent('refresh');
    }
    handleError(event){
        
    }
}