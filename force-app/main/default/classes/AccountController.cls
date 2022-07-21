public with sharing class AccountController {

    @AuraEnabled(cacheable=true)
    public static List<Account> getAccounts() {
        List<Account> accounts = new List<Account>();
        accounts = [SELECT Id, Name, Industry, Opportunity_Count__c, Contact_Count__c FROM Account];
        return accounts;
    }

    public static void contactCount(List<SObject> newItems, List<SObject> oldItems) {

        Map<Id,Account> AccountMap = new Map<Id,Account>();
            set<String> updateContactCount = new Set<String>();
            set<String> accId=new Set<String>();
            for(SObject newObj :newItems) {
                Contact newCntObj = (Contact)newObj;
                Contact oldCntObj = null;
                if (newCntObj.Id != null && oldItems != null) {
                    oldCntObj = (Contact)newObj;
                }
                if (newCntObj.AccountId != null) {
                    accId.add(newCntObj.AccountId);
                }
            }

                for (Account ac: [Select Id,Contact_Count__c,(SELECT Id FROM Contacts) FROM Account WHERE Id IN:accId]) {
                    ac.Contact_Count__c=ac.Contacts.size();
                    AccountMap.put(ac.Id,ac);
                }

            update AccountMap.values();
    }

    public static void opportunityCount(List<SObject> newItems, List<SObject> oldItems) {

        Map<Id,Account> AccountMap = new Map<Id,Account>();
            set<String> updateOpportunityCount = new Set<String>();
            set<String> accId = new Set<String>();
            for (SObject newObj :newItems) {
                Opportunity newOppObj = (Opportunity)newObj;
                Opportunity oldOppObj = null;
                if (newOppObj.Id!=null && oldItems != null) {
                    oldOppObj = (Opportunity)newObj;
                }
                if (newOppObj.AccountId != null) {
                    accId.add(newOppObj.AccountId);
                }
            }

                for (Account ac:[Select Id,Opportunity_Count__c, (SELECT Id FROM Opportunities) FROM Account WHERE Id IN:accId]) {
                    ac.Opportunity_Count__c=ac.Opportunities.size();
                    AccountMap.put(ac.Id,ac);
                }

            update AccountMap.values();
    }
}