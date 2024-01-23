trigger OpportunityTrigger on Opportunity (after insert, after update, after delete, after undelete) {
    set<Id> acctIds = new set<Id>();
    set<Id> maxOppAccountIds = new set<Id>();
    if((Trigger.isInsert || Trigger.isUndelete) && Trigger.isAfter){
        for(Opportunity opp : Trigger.New){
            if(opp.AccountId != NULL){
                acctIds.add(opp.AccountId);
            }
        }
    }

    if(Trigger.isUpdate && Trigger.isAfter){
        for(Opportunity opp : Trigger.New){
            if(opp.AccountId != Trigger.OldMap.get(opp.Id).AccountId){
                acctIds.add(opp.AccountId);
                if(Trigger.OldMap.get(opp.Id).AccountId != NULL){
                    acctIds.add(Trigger.OldMap.get(opp.Id).AccountId);
                    maxOppAccountIds.add(Trigger.OldMap.get(opp.Id).AccountId);
                }
            }
        }
    }
    if(Trigger.isDelete && Trigger.isAfter){
        for(Opportunity opp : Trigger.Old){
            acctIds.add(opp.AccountId);
            maxOppAccountIds.add(opp.AccountId);
        }
    }

    if(acctIds.size() > 0){
        OpportunityHelper.CountNumberOfOpportunities(acctIds);
    }
    if((Trigger.isInsert || Trigger.isUpdate || Trigger.isUndelete) && Trigger.isAfter){
        OpportunityHelper.assignMaxOpptyToAccount(Trigger.New);
    }
    if(maxOppAccountIds.size() > 0){
        OpportunityHelper.assignMaxOpptyToAccountonDelete(maxOppAccountIds);
    }
}