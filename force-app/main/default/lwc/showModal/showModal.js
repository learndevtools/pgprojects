import { LightningElement } from "lwc";
export default class ShowModal extends LightningElement {
    closeModal(){
        this.dispatchEvent(new CustomEvent('close',{
            detail: true
        }));
    }
    handleSlotFooterChange(){
        this.removeSection('slds-hide','.slds-modal__footer');
    }
    handleSlotHeaderChange(){
        this.removeSection('slds-hide','.slds-modal__header');
    }
    removeSection(removeItem,sectionName){
        const footerElement = this.template.querySelector(sectionName);
        if(footerElement){
            footerElement.classList.remove(removeItem);
        }
    }
}