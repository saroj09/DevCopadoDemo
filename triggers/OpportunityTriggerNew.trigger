trigger OpportunityTriggerNew on Opportunity (before insert, before update) {
    list<Opportunity> oldOpptyToUpdate = new list<Opportunity>();
    set<Id> acctIds = new Set<Id>();
    for(Opportunity opp : Trigger.New){
        if(Trigger.isInsert){
            acctIds.add(opp.AccountId);
        }
        if(Trigger.isUpdate && (opp.Amount != trigger.oldmap.get(opp.Id).Amount)){
            acctIds.add(opp.AccountId);
        }
    }

    map<Id, Opportunity> accountMaxOppMap = new map<Id, Opportunity>();
    for(Opportunity opp : [SELECT AccountId, Amount, Max_Value_Opportunity__c FROM Opportunity WHERE AccountId IN :acctIds AND Max_Value_Opportunity__c = true]){
        accountMaxOppMap.put(opp.AccountId, opp);
    }

    for(Opportunity opp : Trigger.new){
        if(accountMaxOppMap != NULL && accountMaxOppMap.get(opp.AccountId) != NULL){
            if(accountMaxOppMap.get(opp.AccountId).Amount < opp.Amount){
                opp.Max_Value_Opportunity__c = true;
                Opportunity oldOpp = new Opportunity(Id = accountMaxOppMap.get(opp.AccountId).Id, Max_Value_Opportunity__c = false);
                oldOpptyToUpdate.add(oldOpp);
            }
        }
        else{
            opp.Max_Value_Opportunity__c = true;
        }
    }
    if(oldOpptyToUpdate.size() > 0){
        update oldOpptyToUpdate;
    }
}