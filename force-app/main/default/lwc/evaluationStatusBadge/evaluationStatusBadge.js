import { LightningElement, api } from 'lwc';

export default class EvaluationStatusBadge extends LightningElement {
    @api status;
    @api componentId;
    
    get statusClass() {
        switch(this.status) {
            case 'Completed':
                return 'slds-badge slds-badge_success';
            case 'In Progress':
                return 'slds-badge slds-badge_warning';
            case 'Scheduled':
                return 'slds-badge slds-badge_lightest';
            case 'Not Started':
                return 'slds-badge slds-badge_error';
            case 'Not Required':
                return 'slds-badge slds-badge_inverse';
            default:
                return 'slds-badge';
        }
    }
    
    handleStatusChange(event) {
        const newStatus = event.target.value;
        
        // Dispatch event to parent component
        const statusUpdateEvent = new CustomEvent('statusupdate', {
            detail: {
                componentId: this.componentId,
                newStatus: newStatus
            }
        });
        this.dispatchEvent(statusUpdateEvent);
    }
}