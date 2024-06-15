/**
* The SOQL class serves as a primer into the Salesforce Object Query Language in Apex.
* It covers fundamental aspects such as SELECT statements, WHERE clauses, Relationship queries, and LIMIT keyword.
*
* This class introduces developers to the concept of retrieving data from Salesforce using SOQL. It provides
* a step-by-step guide on how to construct SOQL queries, filter results using WHERE clause, retrieve related
* records, and manage data volume using the LIMIT keyword.
* 
* Topics covered in this class include:
* - Understanding the structure of a SOQL query.
* - Crafting basic SELECT statements in SOQL.
* - Applying filters using the WHERE clause in SOQL.
* - Fetching related records using Relationship queries.
* - Controlling the amount of data retrieved using the LIMIT keyword.
* 
* Users of this class can expect to gain a solid understanding of SOQL in Apex and
* be prepared to handle data retrieval tasks in Salesforce development.
* 
* @author Summer Perkins
*/

public with sharing class SOQL {
    
    /**
     * Question 1
     * Update/Uncomment the template code to create a method
     * Returns all leads from Salesforce Org
     * @return List of all leads with Id, LastName, Company, Phone, Email
     * Update the corresponding test class and testGetAllLeads method to cover this method
     */
    public static List<Lead> getAllLeads() {
        List<Lead> allLeads = [SELECT Id, LastName, Company, Phone, Email FROM Lead];
        return allLeads;
    }

    /**
     * Question 2
     * Update/Uncomment the template code to create a method
     * Returns all contacts with first name of John.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByFirstName method to cover this method
     */
    public static List<Contact> getContactsByFirstName() {
        return [SELECT Id, Name, Email FROM Contact WHERE FirstName = 'John'];
    }

    /**
     * Question 3
     * Update/Uncomment the template code to create a method
     * Returns the Contact Id for all contacts with last name of Smith or Jones
     * @return A list of Contact Ids.
     * Update the corresponding test class and testGetContactIdsByLastName method to cover this method
     */
    public static List<Id> getContactIds() {
        List<Contact> contacts = [SELECT Id FROM Contact WHERE LastName IN ('Smith', 'Jones')];
        List<Id> contactIds = new List<Id>();
        for (Contact contact : contacts) {
            contactIds.add(contact.Id);
        }
        return contactIds;
    }


    /**
     * Question 4
     * Update/Uncomment the template code to create a method
     * Returns List of closed won opportunities for a specific Account.
     * Example: yourMethodName('001XXXXXXXXXXXX') should return the list of closed won opportunities for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Opportunities with important opportunities fields
     * Update the corresponding test class and testGetClosedWonOpportunityCountByAccount method to cover this method
     */
    public static List<Opportunity> getClosedWonOpps(Id accountId) {
        List<Opportunity> opportunities = [
            SELECT AccountId, Name, StageName, CloseDate, Amount
            FROM Opportunity
            WHERE AccountId = :accountId
            AND StageName = 'Closed Won'
        ];
        
        return opportunities;
    }

    /**
     * Question 5
     * Update/Uncomment the template code to create a method
     * Returns the total count of Account records.
     * @return The Integer count of Account records.
     * Update the corresponding test class and testGetAccountCount method to cover this method
     */
    public static Integer getAccountCount()  {
        return [SELECT COUNT() FROM Account];
    }

    /**
     * Question 6
     * Update/Uncomment the template code to create a method
     * Return Key Value pair of Task Id and Task records for any tasks due date within the next 7 days.
     * @return A map of Task Ids to Task records.
     * Update the corresponding test class and testGetTasksDueNextWeek method to cover this method
     */
    public static Map<Id, Task> getTasksNext7Days() {
        Date today = Date.today(); 
        Date in7Days = today.addDays(7); //  The body of the method

        List<Task> tasks = [SELECT Id, Subject, ActivityDate FROM Task WHERE ActivityDate >= :today AND ActivityDate <= :in7Days];
        Map<Id, Task> tasksMap = new Map<Id, Task>();
        for (Task task : tasks) {
            tasksMap.put(task.Id, task);
        }
        return tasksMap;
    }

    /**
     * Question 7
     * Update/Uncomment the template code to create a method
     * Retrieves all Contacts that have a example.com domain in their Email.
     * @return A list of Contact records.
     * Update the corresponding test class and testGetContactsByEmailDomain method to cover this method
     */
    public static List<Contact> getContactsEmail() {
        return [SELECT Id, Name, Email FROM Contact WHERE Email LIKE '%@example.com'];
    }

    /**
     * Question 8
     * Retrieves all Opportunities that have a specific keyword in their Name.
     * Example: getOpportunitiesByNameKeyword('keyword') should return all Opportunities that have 'keyword' in their Name.
     * @param keyword The keyword to search for in the Opportunity Name.
     * @return A list of Opportunity records.
     */
    public static List<Opportunity> getOpportunitiesByNameKeyword(String keyword) {
        String searchKeyword = '%' + keyword + '%';
        List<Opportunity> opportunities = [SELECT Id, Name, StageName, CloseDate, Amount 
                                           FROM Opportunity 
                                           WHERE Name LIKE :searchKeyword];
        return opportunities;
    }

    /**
     * Question 9
     * Retrieves all Cases that Case Origin is not Web or Email or Blank
     * @return A list of Case records.
     */
    public static List<Case> getFilterCaseOrigins() {
        return [SELECT ID, Subject, Description, Status, Origin FROM Case WHERE Origin NOT IN ('Web', 'Email') AND Origin != null]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 10
     * Update/Uncomment the template code to create a method
     * Retrieves all Leads that have a specific Lead Source or contain a specific keyword in their Title.
     * Example: yourMethodName('Web', 'Engineer') should return all Leads that have 'Web' in their Lead Source or 'Engineer' in their Title.
     * @param leadSource The Lead Source to search for.
     * @param keyword The keyword to search for in the Lead Title.
     * @return A list of Lead records.
     * Update the corresponding test class and testGetLeadsBySourceOrTitle method to cover this method
     */
    public static List<Lead> getLeadsBySourceOrTitle(String leadSource, String keyword) {
        String keywordLike = '%' + keyword + '%';
        List<Lead> leads = [SELECT LastName, Company, Phone, Email, Title, LeadSource 
                            FROM Lead 
                            WHERE (LeadSource = :leadSource OR Title LIKE :keywordLike)];

        return leads;
    }

    /**
     * Question 11
     * Returns the names of all Contacts associated with an Account.
     * Example: getContactNamesByAccount('001XXXXXXXXXXXX') should return the list of Contact LastNames for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A list of Contact LastName.
     */
    public static List<String> getContactNamesByAccount(Id accountId) {
        List<String> contactLastNames = new List<String>();

        List<Contact> contacts = [SELECT LastName FROM Contact WHERE AccountId = :accountId];
        for (Contact contact : contacts) {
            contactLastNames.add(contact.LastName);
        }
        return contactLastNames;   
        }

    /**
     * Question 12
     * Returns the total revenue for all Opportunities in a specific Stage or if the amount is greater than 10000.
     * Example: getTotalRevenueByStage('Closed Won') should return the total revenue for all Opportunities in the 'Closed Won' Stage.
     * @param stage The Stage value to filter Opportunities.
     * @return The total revenue.
     */
    public static Decimal getTotalRevenueByStage(String stage) {
        AggregateResult results = [SELECT SUM(Amount) totalAmount FROM Opportunity WHERE StageName = :stage OR Amount >= 10000];

        return (Decimal) results.get('totalAmount');
    }

    /**
     * Question 13
     * Retrieves the first 10 Accounts ordered by Name.
     * @return A list of the first 10 Accounts ordered by Name.
     */
    public static List<Account> getFirstTenAccounts() {
        return [SELECT Id, Name FROM Account ORDER BY Name ASC LIMIT 10];
    }
    
    /**
     * Question 14
     * Retrieves the Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     * @return A list of Opportunities with an Amount greater than 100,000, ordered by CloseDate, and limited to 5 records.
     */
    public static List<Opportunity> getHighValueOpportunities() {
        return [SELECT Id, Amount, CloseDate, StageName FROM Opportunity WHERE Amount > 100000 ORDER BY CloseDate ASC LIMIT 5];
    }
    
    /**
     * Question 15
     * Retrieves the Contacts with the most recent Birthdate, ordered by Birthdate, and limited to 3 records.
     * @return A list of Contacts
     */
    public static List<Contact> getBirthdateContacts() {
        return [SELECT ID, Birthdate FROM Contact WHERE Birthdate != null ORDER BY Birthdate DESC LIMIT 3];
    }
    
    /**
     * Question 16
     * Retrieves the Cases in the Open Status, ordered by CreatedDate, and limited to 10 records with an offset of 5.
     * @return A list of Cases
     */
    public static List<Case> getCasesWithStatus() {
        return [SELECT Id, Status, CreatedDate FROM Case WHERE Status = 'Open' ORDER BY CreatedDate LIMIT 10 OFFSET 5];
    }

    /**
     * Question 17
     * Returns Set of Case Ids for a specific Account.
     * Example: getCaseIdsByAccount('001XXXXXXXXXXXX') should return the set of Case Ids for the Account with the Id
     * @param accountId The ID of the Account.
     * @return A set of Case Ids.
     */
    public static Set<Id> getCaseIdsByAccount(Id accountId) {
        Set<Id> caseIds = new Set<Id>();

        List<Case> cases = [SELECT Id, AccountId FROM Case WHERE AccountId = :accountId];
        for (Case record : cases) {
            caseIds.add(record.Id);   
        }

        return caseIds;
    }

    /**
     * Question 18
     * Return Map of Account Ids to Account Names Not in a specific Country.
     * Example: getAccountIdsToNamesNotInCountry('United States') should return the map of Account Ids to Account Names for Accounts that are not in the United States.
     * @param country The country to filter Accounts.
     * @return A map of Account Ids to Account Names.
     */
    public static Map<Id, String> getAccountIdsToNamesNotInCountry(String country) {
        Map<Id, String> accountIdsToNames = new Map<Id, String>();
        List<Account> accounts = [SELECT Id, Name, BillingCountry FROM Account WHERE BillingCountry != :country];
        Map<Id, String> accountMap = new Map<Id, String>();
        for (Account record : accounts) {
            accountMap.put(record.Id, record.Name);
        }
        return accountMap;
    }

    /**
     * Question 19
     * Retrieves the Account Name for a given Contact.
     * Example: getAccountNameForContact('003XXXXXXXXXXXX') should return the Account Name for the Contact with the Id
     * @param contactId The Id of the Contact.
     * @return The Account Name of the Contact.
     */
    public static String getAccountNameForContact(String contactId) {
        String accountName = null;
        
        Contact contactrecord = [SELECT Account.Name FROM Contact WHERE Id = :contactId];
        if (contactRecord != null && contactRecord.Account != null) {
            accountName = contactRecord.Account.Name;
        }

        return accountName;
    }    

    /**
     * Question 20
     * Returns single Account that has related opportunities in the same query
     * Example: getAccountAndOpportunitiesFromAccountId('001XXXXXXXXXXXX') should return the Account Name for the Account with the Id and all related Opportunities
     * @param accountId The ID of the Account.
     * @return An Account record with related Opportunities.
     */
    public static Account getAccountAndOpportunitiesFromAccountId(Id accountId) {
        return [SELECT Id, Name, (SELECT Id, Name FROM Opportunities) FROM Account WHERE Id = :accountId]; // Replace null with the variable you used to store the result
    }

    /**
     * Question 21
     * Retrieves all contacts that have the Mailing State similar to the Account Billing State.
     * Example: getAccountsWithContactsByState('001XXXXXXXXXXXX') should return a list of Contacts that have the same Mailing State as the Account with the Id
     * @param Account Id
     * @return List of contacts with the same Mailing State as the Account Billing State
     */
    public static List<Contact> getAccountsWithContactsByState(Id accountId) {
        List<String> billingStates = new List<String>();
        for (Account acc : [SELECT BillingState FROM Account WHERE Id = :accountId]) {
            billingStates.add(acc.BillingState);
        }
    
        List<Contact> allContacts = [SELECT Id, FirstName, LastName, MailingState 
                                     FROM Contact 
                                     WHERE AccountId = :accountId];
    
        List<Contact> contactsByState = new List<Contact>();
        for (Contact con : allContacts) {
            if (billingStates.contains(con.MailingState)) {
                contactsByState.add(con);
            }
        }
    
        return contactsByState;
    }

    /**
     * Question 22
     * Extracts email domains from them leads, then finds Accounts with matching website domains
     * If Lead Email = test@test.com return account with website = www.test.com
     * Example: findAccountsByLeadEmailDomains([set of lead ids]) should return a list of Accounts with matching email domains
     * @param A set of Lead Ids.
     * @return A list of Accounts with matching email domains.
     */
    public static List<Account> findAccountsByLeadEmailDomains(Set<Id> leadIds) {
        List<Lead> leads = [SELECT Id, Email FROM Lead WHERE Id IN :leadIds]; 

        Set<String> emailDomains = new Set<String>(); 
        for (Lead lead : leads) {
            if (lead.Email != null) {
                String email = lead.Email.toLowerCase();
                Integer atIndex = email.indexOf('@');
                if (atIndex != -1) {
                String domain = email.substring(atIndex + 1);
                emailDomains.add(domain);
                }
            }
        }

        List<Account> matchingAccounts = new List<Account>();
        if (!emailDomains.isEmpty()) {
            Set<String> websitePatterns = new Set<String>();
            for (String domain : emailDomains) {
                websitePatterns.add('%.' + domain);
                websitePatterns.add('%' + domain);
            }

            matchingAccounts = [SELECT Id, Name, Website 
                                FROM Account 
                                WHERE Website != null 
                                AND (Website LIKE :websitePatterns)];
        }

        return matchingAccounts;
    }

    /**
     * Question 23
     * Clones and Inserts Opportunity Line Items from an original Opportunity to a list of cloned Opportunities.
     * Adds a randomized number between 1 to 3 to the quantity of each line item.
     * Example: cloneLineItems('001XXXXXXXXXXXX', [list of opportunity ids]) should clone the line items from the Opportunity with the Id to each Opportunity in the list
     * @param Original Opportunity Id
     * @param List of cloned Opportunity Ids
     */
    public static void cloneLineItems(Id origOppId, List<Id> cloneOppIds) {
        List<OpportunityLineItem> olis = [SELECT Id, Name, Quantity, UnitPrice, OpportunityId, PriceBookEntryId FROM OpportunityLineItem WHERE OpportunityId = :origOppId];

        List<OpportunityLineItem> clonedOlis = new List<OpportunityLineItem>();

        for (Id cloneOppId : cloneOppIds) {

            for (OpportunityLineItem oli : olis) {
                Integer randomQuantity = (Integer)Math.round(Math.random() * 2) + 1;

                OpportunityLineItem newOli = new OpportunityLineItem();
                newOli.Quantity = oli.Quantity + randomQuantity;
                newOli.UnitPrice = oli.UnitPrice;
                newOli.OpportunityId = cloneOppId;
                newOli.PricebookEntryId = oli.PricebookEntryId;

                clonedOlis.add(newOli);
            }
        }

        insert clonedOlis;
    }
    
    /**
     * Question 24
     * Retrieves the Opportunity Name, Account Name, and Owner Name for Opportunities that have a Stage of 'Closed Won'.
     * Example: getOpportunityDetailsForClosedWon()
     * @return A list of filtered Opportunity
     */
    public static List<Opportunity> getOpportunityDetailsForClosedWon() {        
        return [SELECT Name, AccountId, OwnerId, StageName FROM Opportunity WHERE StageName = 'Closed Won'];
    }

    /**
     * Question 25
     * Sets the 'Primary_Contact__c' field for all Closed Won Opportunities to first Contact on the Account.
     * Example: setPrimaryContact() should set the 'Primary_Contact__c' field for every Opportunity in the org
     */
    public static void setPrimaryContact() {
        //Use the getOpportunityDetailsForClosedWon() method to get the Opportunities
        List<Opportunity> closedWonOpps = getOpportunityDetailsForClosedWon();
        
        // Create a set of Account Ids from the Opportunities
        Set<Id> accountIds = new Set<Id>();
        for (Opportunity opp : closedWonOpps) {
            accountIds.add(opp.AccountId);
        }
        // Query the Contacts
        List<Contact> contacts = [SELECT Id, FirstName, LastName, AccountId FROM Contact WHERE AccountId IN :accountIds];
        // Create a map of Account Ids to the first Contact
        Map<Id, Id> accountToContactMap = new Map<Id, Id>();
        // Loop through each Contact and add the Account Id and Contact to the map
        for (Contact contact : contacts) {
            // If the Account Id is not already in the map, add it with the Contact Id
            if (!accountToContactMap.containsKey(contact.AccountId)) {
                accountToContactMap.put(contact.AccountId, contact.Id);
            }
        }
        List<Opportunity> oppsToUpdate = new List<Opportunity>();
        
        // Loop through each Opportunity        
        for (Opportunity opp : closedWonOpps) {
            if (accountToContactMap.containsKey(opp.AccountId)) {
                opp.Primary_Contact__c = accountToContactMap.get(opp.AccountId);
                oppsToUpdate.add(opp);
            }
        }
        // Update the Opportunities
        if (!oppsToUpdate.isEmpty()) {
            update oppsToUpdate;
        }
    }
}