import { LightningElement , api } from "lwc";
export default class PatientEvaluationCard extends LightningElement {
    @api componentType;
    @api status;
    @api dateValue;
    @api notes;
    @api color;
    @api imagepath;
    get panelStyle(){
        return "text-color:white;text-wrap:nowrap;background-color:"+this.color+";";
    }
}