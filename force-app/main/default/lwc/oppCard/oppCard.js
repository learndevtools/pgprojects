import { LightningElement, api } from "lwc";
import RecordModal from 'c/recordModal'
export default class OppCard extends LightningElement {
    @api recordId;
    @api objectApiName;
    handleClick(event){
        RecordModal.open(
            {
                size: 'small',
                headerLabel: 'Opportunity',
                columns: 2,
                headerIcon: 'standard:opportunity',
                formMode: 'edit',
                layoutType: 'Compact',
                recordId: this.recordId,
                objectApiName: this.objectApiName
            }
        )
        .then(result => {
            console.log(result);
            if(result !== 'modcancel'){
                console.log('Success');
            }else{
                console.log('Cancel');
            }
        })
        .catch(error => {
            console.error(error);
        });
    }
}