import { LightningElement, wire } from 'lwc';
import getCases from '@salesforce/apex/CaseController.getCases';

const columns = [
    { label: 'Description', fieldName: 'Description', type: 'text',wrapText: true },
    { label: 'Priority', fieldName: 'Priority', type: 'text' },
    { label: 'Owner', fieldName: 'OwnerName', type: 'text' }
];

export default class SmartCaseDashboard extends LightningElement {

    cases;
    columns = columns;

    @wire(getCases)
    wiredCases({ error, data }) {

        if (data) {

            this.cases = data.map(row => {
                return {
                    ...row,
                    OwnerName: row.Owner?.Name
                };
            });

        } else if (error) {
            console.error(error);
        }
    }
}