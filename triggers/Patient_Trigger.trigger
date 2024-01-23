trigger Patient_Trigger on Patient__c (before Update, after Update) {
    map<id, string> dataChangeDecision = new  map<id, string>();
    set<Id> statusChangeIds = new set<Id>();
    switch on trigger.operationType{
        when BEFORE_UPDATE{
            dataChangeDecision = PatientHelper.dataChangeFlags(trigger.newMap, trigger.oldMap);
            for(Patient__c pt : Trigger.New){
                if(dataChangeDecision != NULL && dataChangeDecision.get(pt.id) != NULL && dataChangeDecision.get(pt.id) == 'Cured'){
                    pt.Cure_Date__c = System.today();
                }
                if(dataChangeDecision != NULL && dataChangeDecision.get(pt.id) != NULL && dataChangeDecision.get(pt.id) == 'Fatal'){
                    pt.fatal_Date__c = System.today();
                }
            }
        }
        when AFTER_UPDATE{
            dataChangeDecision = PatientHelper.dataChangeFlags(trigger.newMap, trigger.oldMap);
            for(Patient__c pt : Trigger.New){
                if(dataChangeDecision != NULL && dataChangeDecision.get(pt.id) != NULL && dataChangeDecision.get(pt.id) == 'Cured'){
                    statusChangeIds.add(pt.Area__c);
                }
                if(dataChangeDecision != NULL && dataChangeDecision.get(pt.id) != NULL && dataChangeDecision.get(pt.id) == 'Fatal'){
                    statusChangeIds.add(pt.Area__c);
                }
            }
            if(statusChangeIds.size() > 0){
                PatientHelper.AvgCalculate(statusChangeIds);
            }
        }
    }
}