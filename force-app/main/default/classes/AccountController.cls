public class AccountController {
    @AuraEnabled(cacheable=true)
    public static List<Account> getAccountsByRevenue() {
        List<Account> accountList = [SELECT Id, Name, AnnualRevenue,
        (SELECT Id, Name, AnnualRevenue 
        FROM Opportunities 
        WHERE StageName = 'Closed Won')
        FROM Account 
        WHERE AnnualRevenue > 50000 
        ORDER BY AnnualRevenue LIMIT 10];
        return accountList;
    }
}