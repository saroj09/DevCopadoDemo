public class PatientHelper {
   public static  map<id, string> dataChangeFlags(map<id,Patient__c> newRecords, map<id,Patient__c> oldRecords){
        map<id, string> mapdata = new  map<id, string>();
        for(Patient__c pt : newRecords.values()){
            if(pt.Stage__c != oldRecords.get(Pt.Id).Stage__c && pt.Stage__c == 'Cured'){
                //pt.Cure_Date__c = System.today();
                mapdata.put(pt.id, 'Cured');
            }
            if(pt.Stage__c != oldRecords.get(Pt.Id).Stage__c && pt.Stage__c == 'Fatal'){
                //pt.fatal_Date__c = System.today();
                mapdata.put(pt.id, 'Fatal');
            }
        }
        return mapdata;
   }

   public static void AvgCalculate(set<Id> changeStatusIds){
        list<AggregateResult> aggs = [SELECT Area__c, Stage__c, AVG(Number_of_Days_to_Cure__c) avgCured, AVG(Number_of_Days_to_Fatal__c) avgFatal FROM Patient__c WHERE Area__c IN :changeStatusIds GROUP BY Area__c, Stage__c];
        map<Id, Area__c> mapAreas = new map<Id, Area__c>();
        for(AggregateResult agg : aggs ){
            Id areaId = (Id) agg.get('Area__c');
            Area__c area = new Area__c(Id = areaId);
            if(mapAreas != NULL && mapAreas.get(areaId) != NULL){
                area = mapAreas.get(areaId);
            }
            if((string)agg.get('Stage__c') == 'Cured'){
                area.Avg_Cure_Days__c = (double)agg.get('avgCured');
            }
            if((string)agg.get('Stage__c') == 'Fatal'){
                area.Avg_Fatal_Days__c = (double)agg.get('avgFatal');
            }
            mapAreas.put(areaId, area);
        }
        update mapAreas.values();
   }
}