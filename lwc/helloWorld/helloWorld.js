import { LightningElement, track, wire} from 'lwc';
import getAccountDetails from '@salesforce/apex/AccountController.getAccountDetails';


export default class HelloWorld extends LightningElement {
    //fetch data from getAccountDetails using @wire
    @track accounts;
    @track error;

    //wire method
    @wire(getAccountDetails)
    wiredAccounts({error, data}){
        if(data){
            this.accounts = data;
            this.error = undefined;
        }else if(error){
            this.error = error;
            this.accounts = undefined;
        }
    }
    

    //errorcallback
    errorCallback(error, stack){
        console.log(error);
        console.log(stack);
    }
    
    fullName = "Saroj Tripathy";
    @track address = {
        city : 'San Ramon',
        state : 'CA',
        zipcode : 94583
    };
    num1 = 10;
    num2 = 20;
    userList = ['Saroj', 'Sachin', 'Sourav'];

    get firstUser(){
        return this.userList[0].toUpperCase();
    }
    
    get multiply(){
        return this.num1 * this.num2;
    }

    nameChange(event){
        this.fullName = event.target.value;
    }

    trackHandler(event){
        this.address.city = event.target.value;
        //this.address = {...this.address, city : event.target.value};

        //create a custom event and dispatch it
        const customEvent = new CustomEvent('addresschange', {detail : this.address});
        this.dispatchEvent(customEvent);

        //spread operator
        let address ={
            city : "San Ramon",
            state : "CA",
            zipcode : 94583
        }
        this.address = {...this.address, city : event.target.value};

    }
}