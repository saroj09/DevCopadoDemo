import { LightningElement, wire} from 'lwc';
import getAccountList from '@salesforce/apex/AccountController.getAccountList'
import findAccounts from '@salesforce/apex/AccountController.findAccounts'

export default class CopilotDemo extends LightningElement {
    //wire apex method to a property
    @wire(getAccountList) accounts;

    //wire apex method getAccountList to a function
    accountList
    @wire(getAccountList) wiredAccounts({error, data}){
        if(data){
            this.accountList = data;
        }else if(error){
            console.log(error);
        }
    }

    //call apex method findAccounts imperatively
    searchKey = '';
    searchKeyChange(event){
        this.searchKey = event.target.value;
        findAccounts({searchKey: event.target.value})
        .then(result => {
            this.accountList = result;
        })
        .catch(error => {
            console.log(error);
        });
    } 
}