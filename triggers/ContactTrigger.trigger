trigger ContactTrigger on Contact (before insert) {
    if(Trigger.isInsert && Trigger.isBefore){
        set<string> emailIds = new set<string>();
        set<string> phoneNums = new set<string>();
        for(Contact con : trigger.new){
            if(con.Email != NULL){
                emailIds.add(con.Email);
            }
            if(con.Phone != NULL){
                phoneNums.add(con.Phone);
            }
        }

        map<string, Contact> emailMap = new map<string, Contact>();
        map<string, Contact> phoneMap = new map<string, Contact>();
        for(Contact con1 : [SELECT Id, Name, Email, Phone from Contact WHERE Email IN :emailIds OR Phone IN :phoneNums]){
            if((emailIds.size() != NULL && emailIds.contains(con1.Email)) ){
                emailMap.put(con1.Email, con1);
            }
            if((phoneNums.size() != NULL && phoneNums.contains(con1.Phone))){
                phoneMap.put(con1.Phone, con1);
            }
        }

        for(Contact con : Trigger.New){
            if(emailMap != NULL && emailMap.get(con.Email) != NULL){
                con.addError('Duplicate contact with existing Email address');
            }
            if(phoneMap != NULL && phoneMap.get(con.Phone) != NULL){
                con.addError('Duplicate contact with existing Phone Number');
            }
        }
    }

}