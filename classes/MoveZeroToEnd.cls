public  class MoveZeroToEnd {
    public static void MoveZero(list<Integer> lst){
        integer index = 0;
        list<integer> lstNew = lst;
        for(Integer i = 0; i < lst.size() ; i++){
            if(lst[i] == 0){
                lst.remove(i);
                lst.add(0);
            }
            //index++;
        }
        system.debug(lst);
    }
}