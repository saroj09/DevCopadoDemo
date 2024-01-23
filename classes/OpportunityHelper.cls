public class OpportunityHelper {
    public static void CountNumberOfOpportunities(Set<Id> accountIds){
        list<Account> accoutList = new list<Account>();
        for(AggregateResult agg : [SELECT Count(Id) cnt, AccountId FROM Opportunity WHERE AccountId IN :accountIds GROUP BY AccountId]){
            Account acc = new Account();
            acc.Id = (Id)agg.get('AccountId');
            acc.Total_Opportunity_Count__c = (Decimal)agg.get('cnt');
            accoutList.add(acc);
            accountIds.remove(acc.Id);
        }
        if(accountIds.size() > 0){
            for(Id remainAcctId : accountIds){
                Account acc = new Account();
                acc.Id = remainAcctId;
                acc.Total_Opportunity_Count__c = 0;
                accoutList.add(acc);
            }
        }
        update accoutList;
    }

    public static void assignMaxOpptyToAccount(list<Opportunity> lstOppty){
        set<Id> accountIds = new set<Id>();
        for(Opportunity opp : lstOppty){
            accountIds.add(opp.accountId);
        }

        map<Id, account> accountMap = new map<Id, account>([SELECT Id, Max_Valued_Opportunity__c, Max_Valued_Opportunity__r.Amount FROM Account WHERE Id IN :accountIds]);
        
        for(Opportunity opp : lstOppty){
            if(opp.AccountId != NULL && accountMap != NULL && accountMap.get(opp.AccountId) != NULL){
                if(accountMap.get(opp.AccountId).Max_Valued_Opportunity__c != NULL && opp.Amount != NULL && opp.Amount > accountMap.get(opp.AccountId).Max_Valued_Opportunity__r.Amount){
                    accountMap.get(opp.AccountId).Max_Valued_Opportunity__c = opp.Id;
                }
                else if (accountMap.get(opp.AccountId).Max_Valued_Opportunity__c == NULL){
                    accountMap.get(opp.AccountId).Max_Valued_Opportunity__c = opp.Id;
                }
            }
        }
        update accountMap.values();
    }

    public static void assignMaxOpptyToAccountonDelete(set<Id> accts){
        map<id, Account> accountmap = new map<id, Account>([SELECT Id, Max_Valued_Opportunity__c, Max_Valued_Opportunity__r.Amount FROM Account WHERE Id IN :accts AND Max_Valued_Opportunity__c = NULL]);
        map<id, Opportunity> maxOpptyMap = new map<id, Opportunity>();
        if(accountmap.keyset().size() > 0){
            for(opportunity opp : [SELECT Amount, AccountId FROM opportunity WHERE AccountId IN :accountmap.keyset()]){
                if(opp.AccountId != NULL && maxOpptyMap != NULL && maxOpptyMap.get(opp.AccountId) != NULL){
                    if(opp.Amount > maxOpptyMap.get(opp.AccountId).Amount){
                        maxOpptyMap.put(opp.AccountId, opp);
                    }
                }
                else {
                    maxOpptyMap.put(opp.AccountId, opp);
                }
            }
            list<Account> lstAccts = new list<Account>();
            for(Id aId : maxOpptyMap.keyset()){
                 account acc = new account(Id = aId, Max_Valued_Opportunity__c = maxOpptyMap.get(aId).Id);
                 lstAccts.add(acc);
            }
            if(lstAccts.size() > 0){
                update lstAccts;
            }
        }
    }
}