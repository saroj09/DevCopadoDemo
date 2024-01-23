trigger AccountTrigger on Account (After Update, Before Delete) {
    if(Trigger.isUpdate && Trigger.isAfter){
        list<Account> accounts = new list<Account>();
        list<Contact> contacts = new list<Contact>();
        for(Account acc : Trigger.New){
            if(acc.BillingState != Trigger.OldMap.get(acc.Id).BillingState){
                accounts.add(acc);
            }
        }
        if(accounts.size() > 0){
            for(Contact con : [SELECT CustomBillingState__c, AccountId FROM Contact WHERE AccountId IN :accounts]){
                con.CustomBillingState__c = Trigger.NewMap.get(con.AccountId).BillingState;
                contacts.add(con);
            }
        }
        if(contacts.size() > 0){
            update contacts;
        }
    }

    if(Trigger.isDelete && Trigger.isBefore){
        map<Id, Case> accountwithCase = new map<Id, Case>();
        for(Case cs : [SELECT Id, AccountId FROM Case WHERE AccountId IN :Trigger.Old AND Status != 'Closed']){
            accountwithCase.put(cs.AccountId, cs);
        }
        for(Account acc : Trigger.Old){
            if(accountwithCase != NULL && accountwithCase.get(acc.Id) != NULL){
                acc.addError('Unable to delete the account as there is an open Case availale');
            }
            if(userinfo.getUserId() != acc.OwnerId){
                acc.addError('Only Account owner can delete the account');
            }
        }
    }
}