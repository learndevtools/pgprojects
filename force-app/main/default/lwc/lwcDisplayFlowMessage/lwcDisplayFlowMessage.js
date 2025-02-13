import { LightningElement, api } from "lwc";
export default class LwcDisplayFlowMessage extends LightningElement {
	@api type;
	@api message;
	get mainDivCSS(){
		return "slds-notify slds-notify_alert slds-alert_"+this.type;
	}
	get spanDivCSS(){
		return "slds-icon_container slds-icon-"+this.type+" slds-m-right_x-small";
	}
}