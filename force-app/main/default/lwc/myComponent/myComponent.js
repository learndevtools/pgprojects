import { LightningElement, api } from "lwc";
export default class MyComponent extends LightningElement {
	@api recordId;
	@api objectApiName;
    //create a private property
    showContacts = false;
    contacts = [
        {
            Id: 1,
            Title: "CEO",
            FirstName: "Abhishek",
            LastName: "Bajaj",
            Phone:  "+91-9898989898"
        },
        {
            Id: 2,
            Title: "CEO",
            FirstName: "Rajendra",
            LastName: "Jaiswal",
            Phone: "+91-8989898989"
        },
        {
            Id: 3,
            Title: "CEO",
            FirstName: "Aakash",
            LastName: "Jain",
            Phone: "+91-8989898980"
        }

    ];
    toggleView(){
        this.showContacts = !this.showContacts;
    }
}