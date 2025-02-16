import { LightningElement, api , wire } from "lwc";
import { CloseActionScreenEvent } from 'lightning/actions';
import { gql, graphql , refreshGraphQL } from 'lightning/uiGraphQLApi';
import {
	RefreshEvent,registerRefreshContainer
  } from "lightning/refresh";
import { ShowToastEvent } from 'lightning/platformShowToastEvent';
const columns=[
    { label: 'Path On Client', fieldName: 'PathOnClient', type: 'text' },
    { label: 'File Extension', fieldName: 'FileExtension', type: 'text' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' }
]

const target_columns=[
    { label: 'File Name', fieldName: 'FileName', type: 'text' },
    { label: 'Created Date', fieldName: 'CreatedDate', type: 'date' },
    { label: 'Source', fieldName: 'Source', type: 'text' },
]
export default class LwcFileUploadsWithoutFlow extends LightningElement {
	@api recordId;
	@api objectApiName;
    isFileUploaded = false;
    tabName='Salesforce';
    columns=columns;
    refreshHandlerId
    errors = undefined;
    graphQLContentVersionRecords = undefined;
    graphQLContentDocIds = undefined;
    contentDocIds= undefined;
    contentVersionRecords = undefined;
    fileFilterTargetRecords = undefined;
    graphQLUploadedRecords=undefined;
    fileUploadedRecords=undefined;
	closeModal() {
		this.dispatchEvent(new CloseActionScreenEvent());
	}
    get inputVariables(){
		if(this.recordId === undefined){
			return null;
		}
		return [
			{
				name : 'recordId',
				type : 'String',
				value : this.recordId
			}
		]
	}
	get options() {
        return [
            { label: 'Salesforce', value: 'Salesforce' },
            { label: 'FTP Folder', value: 'FTP Folder' },
            { label: 'S3 Bucket', value: 'S3 Bucket' },
            { label: 'Google Drive', value: 'Google Drive' },
            { label: 'Box', value: 'Box' },
            { label: 'iCloud', value: 'iCloud' },
            { label: 'One Drive', value: 'One Drive' },
        ];
    }
	get acceptedFormats() {
        return ['.pdf', '.png', '.csv'];
    }
    /*
    @ Getter for contentDocumentLink variable
    */
   get uploadFileDetailsVariable(){
        if(!this.recordId) return undefined
        return {
            uploadedRecordId: this.recordId
        }
   }
   get uploadFileDetailsQuery(){
    if(!this.recordId) return undefined
    return gql `query getFileUploadedDetails($uploadedRecordId: String) {
            uiapi {
                query {
                File_Upload_Details__c(
                    where: { 
                        Record_Id__c: { eq: $uploadedRecordId  }}
                        ) {
                        edges {
                            node {
                                Id
                                Target__c{
                                    value
                                }
                                Source__c{
                                    value
                                } 
                                File_Name__c{
                                    value
                                }       
                                CreatedDate {
                                    value
                                }
                            }
                        }
                    }
                }
            }
        }`
    }
    get contentDocumentLinksVariable(){
        if(!this.recordId) return undefined
        return {
            entityId: this.recordId
        }
    }
    get contentDocumentLinkQuery(){
        if(!this.recordId) return undefined
        return gql `query getContentDocumentLinks($entityId: ID) {
                uiapi {
                    query {
                        ContentDocumentLink(
                            where: { LinkedEntityId: { eq: $entityId } }
                        ) {
                            edges {
                                node {
                                    Id
                                    ContentDocumentId{
                                    value
                                    }
                                }
                            }
                        }
                    }
                }
            }`
    }
    get contentVersionsVariable(){
        if(!this.contentDocIds) return undefined
        return {
            contentDocIds: this.contentDocIds
        }
    }
    get contentVersionQuery(){
        if(!this.contentDocIds) return undefined
        return gql `query getContentDocumentLinks($contentDocIds: [ID]) {
                uiapi {
                    query {
                        ContentVersion(
                            where: { ContentDocumentId: { in: $contentDocIds } },
                            orderBy: {CreatedDate: {order : DESC}}
                        ) {
                            edges {
                                node {
                                    Id
                                    Title {
                                    value
                                    }
                                    FileType {
                                    value
                                    }
                                    FileExtension {
                                    value
                                    }
                                    VersionData {
                                    value
                                    }
                                    PathOnClient {
                                    value
                                    }
                                    CreatedDate {
                                    value
                                    }
                                }
                            }
                        }
                    }
                }
            }`
    }
    
    @wire(graphql, { query: '$contentDocumentLinkQuery', variables: '$contentDocumentLinksVariable' })
    contentDocumentLinks(result){
        this.graphQLContentDocIds = result;
        if(result?.data){
            this.contentDocIds = result.data?.uiapi?.query?.ContentDocumentLink?.edges?.map(edge => edge.node.ContentDocumentId?.value)
        }
        if(result.error){
            this.errors = result.error;
        }
    }
    @wire(graphql, { query: '$contentVersionQuery', variables: '$contentVersionsVariable' })
    contentVersions(result){
        this.graphQLContentVersionRecords = result;
        if(result?.data){
            this.contentVersionRecords = result?.data?.uiapi?.query?.ContentVersion?.edges.map((edge) => ({
                Id: edge.node.Id,
                PathOnClient: edge.node.PathOnClient.value,
                FileExtension: edge.node.FileExtension.value,
                VersionData: edge.node.VersionData.value,
                CreatedDate: edge.node.CreatedDate.value,
            }));
            this.fileFilterTargetRecords = this.contentVersionRecords;
        }
        if(result.error){
            this.errors = result.error;
        }
    }
    @wire(graphql, { query: '$uploadFileDetailsQuery', variables: '$uploadFileDetailsVariable' })
    fileUploadedRecords(result){
        this.graphQLUploadedRecords = result;
        if(result?.data){
            this.fileUploadedRecords = result?.data?.uiapi?.query?.File_Upload_Details__c?.edges.map((edge) => ({
                Id: edge.node.Id,
                Target: edge.node.Target__c.value,
                Source: edge.node.Source__c.value,
                FileName: edge.node.File_Name__c.value,
                CreatedDate: edge.node.CreatedDate.value
            }));
        }
        if(result.error){
            this.errors = result.error;
        }
    }

    /*get contentDocIds(){
        if(this.contentDocumentLinks?.data){
            return this.contentDocumentLinks?.data?.uiapi?.query?.ContentDocumentLink?.edges.map(edge => edge.node?.ContentDocumentId?.value)
        }
        return undefined
    }
    get contentVersionIds(){
        if(this.contentVersions?.data){
            return this.contentVersions?.data?.uiapi?.query?.ContentVersion?.edges.map((edge) => ({
                Id: edge.node.Id,
                Title: edge.node.Title.value,
                FileType: edge.node.FileType.value,
                PathOnClient: edge.node.PathOnClient.value,
                FileExtension: edge.node.FileExtension.value,
                VersionData: edge.node.VersionData.value,
            }));
        }
        return undefined
    }*/
    uploadFile(event){
        if(!this.isFileUploaded){
			this.dispatchEvent(
				new ShowToastEvent({
					title: 'File Uploaded',
					message: 'Please upload file before procedding with the next step',	
					variant: 'success'
				})
			);
		}
    }
    handleUploadFinished(event){
		this.isFileUploaded = true;
        refreshGraphQL(this.graphQLContentDocIds,this.graphQLContentVersionRecords,this.graphQLUploadedRecords);
		this.dispatchEvent(new RefreshEvent());
	}
    connectedCallback(){
		this.isFileUploaded = false;
		this.refreshHandlerId = registerRefreshContainer(this,this.refreshHandler);
	}
	refreshHandler(){
		this.isFileUploaded = false;
		return new Promise(resolve=>{
            alert('Test');
            refreshGraphQL(this.graphQLContentDocIds,this.graphQLContentVersionRecords,this.graphQLUploadedRecords);
			resolve(true);
		})
	}
    get tabs(){
        const tabs = [];
        this.options.forEach(function(option){
            tabs.push({
                label: option.label,
                value: option.value
            })
        });
        return tabs;
    }
    handleActive(event){
        this.tabName = event.target.value;
        if(this.tabName != 'Salesforce'){
            this.columns=target_columns;
            this.fileFilterTargetRecords = this.fileUploadedRecords === null || this.fileUploadedRecords === undefined?null : this.fileUploadedRecords.filter((file) => file.Target === this.tabName);
            console.log('this.fileFilterTargetRecords=', JSON.stringify(this.fileFilterTargetRecords));
        }else{
            this.columns=columns;
            this.fileFilterTargetRecords = this.contentVersionRecords;
        }
    }
}