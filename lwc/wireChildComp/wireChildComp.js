import { LightningElement, wire } from 'lwc';
import getAccountList from  '@salesforce/apex/AccountHelper.getAccountList';

export default class WireChildComp extends LightningElement {
    @wire(getAccountList) accounts;
}