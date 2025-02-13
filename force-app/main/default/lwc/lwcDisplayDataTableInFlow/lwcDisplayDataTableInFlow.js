import { LightningElement, api } from "lwc";
const columns = [
    { label: 'Channel Id', fieldName: 'channelId' },
    { label: 'Channel Title', fieldName: 'channelTitle'},
    { label: 'Description', fieldName: 'description' },
    { label: 'Title', fieldName: 'title' }
];
export default class LwcDisplayDataTableInFlow extends LightningElement {
	@api displayDataCollection=null;
    outPutResult=[];
    columns = columns
    connectedCallback(){
        console.log('connectedCallback');
        if(this.displayDataCollection === null){
            console.log("Empty JSON Request");
        }
        if(this.displayDataCollection){
            console.log('Hello');
            console.log('outtput.length'+this.displayDataCollection);
            console.log( JSON.parse(this.displayDataCollection));
            let outtput = JSON.parse(this.displayDataCollection);
            //let inputCollection = outtput.
            console.log('outtput.length='+JSON.stringify(outtput[0].inputCollection));
            this.outPutResult = outtput[0].inputCollection;
            /*results.forEach(function(item){
                comsole.log('Item=>',JSON.stringify(item))
                console.log(item)
                this.outPutResult = [...this.outPutResult, {
                        channelId: item[0].channelId,
                        channelTitle: item[0].channelTitle,
                        description: item[0].description,
                        title: item[0].title
                }]
            })*/
            //results.forEach(function(item){
            //    comsole.log('Item=>')
            //});
        }
       

    }
    handleRowAction(event){
        console.log('event is '+event);
    }
}