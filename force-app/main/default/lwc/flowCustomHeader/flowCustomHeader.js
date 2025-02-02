import { LightningElement, api } from "lwc";
export default class FlowCustomHeader extends LightningElement {
	@api headerText;
	@api subHeaderText;
	@api headerCss;
	@api subHeaderCss;
	@api isSubHeaderBackGroundColor;
	@api subHeaderStyle;
}