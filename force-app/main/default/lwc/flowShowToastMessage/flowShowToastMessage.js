import { LightningElement, api } from "lwc";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
import { FlowNavigationNextEvent,FlowNavigationFinishEvent } from 'lightning/flowSupport';
import { NavigationMixin } from 'lightning/navigation';
export default class FlowShowToastMessage extends NavigationMixin(
    LightningElement
) {
	@api title;
    @api label;
	@api message;	
	@api variant;
	@api mode;
    @api recordId;
    @api availableActions = [];
    messageData=[];
    /**
     * This method is used to invoke the toast messae
     */
    connectedCallback() {
        this.showToastMessage();
        if(this.availableActions.includes('NEXT') || this.availableActions.includes('FINISH')){
            this.availableActions.includes('NEXT')?this.dispatchEvent(new FlowNavigationNextEvent()):this.dispatchEvent(new FlowNavigationFinishEvent());
        }
    }
    /**
     * This method is used to invoke the toast messae
     */
    showToastMessage(){
      
        if(this.recordId){
            this[NavigationMixin.GenerateUrl]({
                type: 'standard__recordPage',
                attributes: {
                    recordId: this.recordId,
                    actionName: 'view'
                }
            }).then((url)=>{
               
                this.messageData = [
                    'Salesforce',
                    {
                    url,
                    label: 'here'
                },];
                this.invokeToastMessage();
            })
        }else{
            this.invokeToastMessage();
        }
       
    }
    invokeToastMessage(){
        const toastEvent = new ShowToastEvent({
            title: this.title,
            message: this.message,
            variant: this.variant,
            messageData: this.messageData??null,
            mode: this.mode
        });
        this.dispatchEvent(toastEvent);
    }
}