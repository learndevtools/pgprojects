import { LightningElement, api, wire, track } from 'lwc';
import { getRecord, getFieldValue } from 'lightning/uiRecordApi';
import { refreshApex } from '@salesforce/apex';
import getEvaluationComponents from '@salesforce/apex/EvaluationController.getEvaluationComponents';
import getPatientDocuments from '@salesforce/apex/EvaluationController.getPatientDocuments';
import getUpcomingAppointments from '@salesforce/apex/EvaluationController.getUpcomingAppointments';
import updateEvaluationComponentStatus from '@salesforce/apex/EvaluationController.updateEvaluationComponentStatus';
import calculateEvaluationProgress from '@salesforce/apex/EvaluationController.calculateEvaluationProgress';

// Field imports for patient
import PATIENT_NAME_FIELD from '@salesforce/schema/Transplant_Patient__c.Name';
import DOB_FIELD from '@salesforce/schema/Transplant_Patient__c.Date_of_Birth__c';
import MRN_FIELD from '@salesforce/schema/Transplant_Patient__c.MRN__c';
import ORGAN_FIELD from '@salesforce/schema/Transplant_Patient__c.Organ_Type__c';
import BLOOD_TYPE_FIELD from '@salesforce/schema/Transplant_Patient__c.Blood_Type__c';
import STATUS_FIELD from '@salesforce/schema/Transplant_Patient__c.Current_Status__c';

// Field imports for evaluation
import EVAL_STATUS_FIELD from '@salesforce/schema/Evaluation__c.Status__c';
import EVAL_PROGRESS_FIELD from '@salesforce/schema/Evaluation__c.Progress__c';
import EVAL_START_DATE_FIELD from '@salesforce/schema/Evaluation__c.Start_Date__c';

const PATIENT_FIELDS = [PATIENT_NAME_FIELD, DOB_FIELD, MRN_FIELD, ORGAN_FIELD, BLOOD_TYPE_FIELD, STATUS_FIELD];
const EVALUATION_FIELDS = [EVAL_STATUS_FIELD, EVAL_PROGRESS_FIELD, EVAL_START_DATE_FIELD];

export default class EvaluationManagements extends LightningElement {
    @api recordId; // The Evaluation Id
    @api patientId; // The Patient Id
    
    @track evaluationComponents;
    @track patientDocuments;
    @track upcomingAppointments;
    @track activeTab = 'clinicalEvaluations';
    @track isLoading = true;
    @track error;
    @track evaluationProgress = 0;
    
    wiredPatientResult;
    wiredEvaluationResult;
    wiredComponentsResult;
    wiredDocumentsResult;
    wiredAppointmentsResult;
    
    // Get patient information
    @wire(getRecord, { recordId: '$patientId', fields: PATIENT_FIELDS })
    wiredPatient(result) {
        this.wiredPatientResult = result;
        if (result.data) {
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
        }
    }
    
    // Get evaluation information
    @wire(getRecord, { recordId: '$recordId', fields: EVALUATION_FIELDS })
    wiredEvaluation(result) {
        this.wiredEvaluationResult = result;
        if (result.data) {
            this.evaluationProgress = getFieldValue(result.data, EVAL_PROGRESS_FIELD);
            this.error = undefined;
        } else if (result.error) {
            this.error = result.error;
        }
    }
    
    // Get evaluation components
    @wire(getEvaluationComponents, { evaluationId: '$recordId' })
    wiredComponents(result) {
        this.wiredComponentsResult = result;
        if (result.data) {
            this.evaluationComponents = result.data;
            this.error = undefined;
            this.isLoading = false;
        } else if (result.error) {
            this.error = result.error;
            this.isLoading = false;
        }
    }
    
    // Get patient documents
    @wire(getPatientDocuments, { evaluationId: '$recordId' })
    wiredDocuments(result) {
        this.wiredDocumentsResult = result;
        if (result.data) {
            this.patientDocuments = result.data;
        } else if (result.error) {
            // Handle error
        }
    }
    
    // Get upcoming appointments
    @wire(getUpcomingAppointments, { evaluationId: '$recordId' })
    wiredAppointments(result) {
        this.wiredAppointmentsResult = result;
        if (result.data) {
            this.upcomingAppointments = result.data;
        } else if (result.error) {
            // Handle error
        }
    }
    
    get patientName() {
        return this.wiredPatientResult.data ? 
            getFieldValue(this.wiredPatientResult.data, PATIENT_NAME_FIELD) : '';
    }
    
    get patientDOB() {
        return this.wiredPatientResult.data ? 
            getFieldValue(this.wiredPatientResult.data, DOB_FIELD) : '';
    }
    
    get patientMRN() {
        return this.wiredPatientResult.data ? 
            getFieldValue(this.wiredPatientResult.data, MRN_FIELD) : '';
    }
    
    get patientOrgan() {
        return this.wiredPatientResult.data ? 
            getFieldValue(this.wiredPatientResult.data, ORGAN_FIELD) : '';
    }
    
    get patientBloodType() {
        return this.wiredPatientResult.data ? 
            getFieldValue(this.wiredPatientResult.data, BLOOD_TYPE_FIELD) : '';
    }
    
    get patientStatus() {
        return this.wiredPatientResult.data ? 
            getFieldValue(this.wiredPatientResult.data, STATUS_FIELD) : '';
    }
    
    get evaluationStatus() {
        return this.wiredEvaluationResult.data ? 
            getFieldValue(this.wiredEvaluationResult.data, EVAL_STATUS_FIELD) : '';
    }
    
    get startDate() {
        return this.wiredEvaluationResult.data ? 
            getFieldValue(this.wiredEvaluationResult.data, EVAL_START_DATE_FIELD) : '';
    }
    
    get progressStyle() {
        return `width: ${this.evaluationProgress}%`;
    }
    
    handleTabChange(event) {
        this.activeTab = event.target.value;
    }
    
    handleStatusUpdate(event) {
        const { componentId, newStatus } = event.detail;
        
        this.isLoading = true;
        
        updateEvaluationComponentStatus({ 
            componentId: componentId,
            status: newStatus
        })
        .then(() => {
            // After status update, calculate new progress
            return calculateEvaluationProgress({ evaluationId: this.recordId });
        })
        .then(result => {
            // Refresh components and evaluation data
            this.evaluationProgress = result;
            return refreshApex(this.wiredComponentsResult);
        })
        .then(() => {
            return refreshApex(this.wiredEvaluationResult);
        })
        .catch(error => {
            this.error = error;
        })
        .finally(() => {
            this.isLoading = false;
        });
    }
    
    handleScheduleAppointment() {
        // Navigate to appointment scheduling UI
        // Code to open modal or navigate to scheduling page
    }
    
    handleUploadDocument() {
        // Open document upload modal
        // Code to open document upload interface
    }
}