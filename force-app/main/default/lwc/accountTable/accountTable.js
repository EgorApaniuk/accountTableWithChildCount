import { LightningElement, wire, track } from 'lwc';
import getAccounts from '@salesforce/apex/AccountController.getAccounts';
import ID_FIELD from '@salesforce/schema/Account.Id';
import NAME_FIELD from '@salesforce/schema/Account.Name';
import INDUSTRY_FIELD from '@salesforce/schema/Account.Industry';
import CONTACT_COUNT_FIELD from '@salesforce/schema/Account.Contact_Count__c';
import OPPORTUNITY_COUNT_FIELD from '@salesforce/schema/Account.Opportunity_Count__c';

const COLUMNS = [
    {label: 'Name', fieldName: 'Name', type: 'text', editable: false},
    {label: 'Industry', fieldName: 'Industry', type: 'text', editable: false },
    {label: 'Contact Count', fieldName: 'Contact_Count__c', type: 'number', editable: false },
    {label: 'Opportunity Count', fieldName: 'Opportunity_Count__c', type: 'number', editable: false },
];

export default class AccountTable extends LightningElement {
    @track data;
    columns = COLUMNS;
    wiredAccounts;

    @wire(getAccounts)
    refreshWiredAccounts(value){
        this.wiredAccounts = value;
        const {data, error} = value;
        if (data) {
            this.data=data;
        } else if (error) {
            console.log(error);
        }
    }

    handleActive(event) {
        if (event.target.value == 0) {
            this.columns = [...COLUMNS].filter(col => col.fieldName != 'Opportunity_Count__c'); 
        } else { 
            this.columns = [...COLUMNS].filter(col => col.fieldName != 'Contact_Count__c');
        } 
    }
}