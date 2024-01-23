public class Palindrome {
    public static boolean isPalindrome(string pString){
        string[] strArray = pString.split('');
        boolean isPstring = false;
        integer midStrLenght = (integer)(strArray.size()/2);
        system.debug(midStrLenght);
        integer modVal = math.mod(strArray.size(), 2);
        string str1 = '';
        string str2 = '';
       for(integer i = strArray.size() - 1 ; i >= midStrLenght ; i--){
            str1 = str1 + strArray[i];
            integer j = i - midStrLenght - modVal;
            if(j >= 0){
                str2 = str2 + strArray[j];
            }
            
        }
        system.debug(str1 + str2);
       if(pString == str1 + str2){
        isPstring = true;
       }
       system.debug(isPstring);
        return isPstring;
    }
}