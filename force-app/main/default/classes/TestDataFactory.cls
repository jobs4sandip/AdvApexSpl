/**
 * @name TestDataFactory
 * @description Contains methods to construct and/or validate commonly used records
**/
public with sharing class TestDataFactory {

    /**
     * @name ConstructCollaborationGroup
     * @description
    **/
    public static CollaborationGroup ConstructCollaborationGroup(){
        //ToDo: Ensure this method returns a single Chatter CollaborationGroup
        //    whose Name starts with 'TEST' followed by the INVENTORY_ANNOUNCEMENTS constant
        //    and configured so anyone can join, see and post updates.
        CollaborationGroup chatterGroup = new CollaborationGroup(
            Name = 'TEST'+Constants.INVENTORY_ANNOUNCEMENTS,  
            CollaborationType = 'Public'
        );
        return chatterGroup;
    }

    /**
     * @name CreateProducts
     * @description Constructs a list of Product2 records for unit tests
    **/
    public static List<Product2>  ConstructProducts(Integer cnt){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Product2 records
        //  with all the required fields populated
        //  and IsActive = true
        //  an Initial Inventory set to 10
        //  and iterating through the product family picklist values throughout the list.

        List<Product2> lstProducts = new List<Product2>();
        for(Integer i = 1; i<=cnt ; i++){
            Product2 prodObj = new Product2(Name='Product'+i, Initial_Inventory__c = 10, isActive=true, family= Constants.PRODUCT_FAMILY.get(math.mod(i,4)).getValue());
            lstProducts.add(prodObj);
        }
        
        return lstProducts;
    }

    /**
     * @name CreatePricebookEntries
     * @description Constructs a list of PricebookEntry records for unit tests
    **/
    public static List<PriceBookEntry> ConstructPricebookEntries(List<Product2> prods){
        //ToDo: Ensure this method returns a corresponding list of PricebookEntries records
        //  related to the provided Products
        //  with all the required fields populated
        //  and IsActive = true
        //  and belonging to the standard Pricebook

        List<PriceBookEntry> lstPBEntries = new List<PriceBookEntry>();
        for(Product2 prod : prods) {
            PriceBookEntry entryObj = new PriceBookEntry();
            entryObj.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            entryObj.Product2Id = prod.Id;
            entryObj.IsActive = true;
            entryObj.UnitPrice = 100;
            lstPBEntries.add(entryObj);
        }
        
        return lstPBEntries;
    }

    /**
     * @name CreateAccounts
     * @description Constructs a list of Account records for unit tests
    **/
    public static List<Account> ConstructAccounts(Integer cnt){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Account records
        //  with all of the required fields populated.
        List<Account> lstAccounts = new List<Account>();
        for(Integer i = 0 ; i<cnt; i++) {
            Account accObj = new Account(name='Account' + i);
            lstAccounts.add(accObj);
        }
        return lstAccounts;
    }

    /**
     * @name CreateContacts
     * @description Constructs a list of Contacxt records for unit tests
    **/
    public static List<Contact> ConstructContacts(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list, of size cnt, of uniquely named Contact records
        //  related to the provided Accounts
        //  with all of the required fields populated.
        List<Contact> lstContacts = new List<Contact>();
        for(Integer i=0; i<cnt;i++) {
            Integer index = Math.mod(i, accts.size());
            Contact conObj = new Contact();
            conObj.LastName = 'TestContact'+i;
            conObj.AccountId = accts.get(index).Id;
            lstContacts.add(conObj);
        }
        
        return lstContacts;

    }

    /**
     * @name CreateOrders
     * @description Constructs a list of Order records for unit tests
    **/
    public static List<Order> ConstructOrders(Integer cnt, List<Account> accts){
        //ToDo: Ensure this method returns a list of size cnt of uniquely named Order records
        //  related to the provided Accounts
        //  with all of the required fields populated.

        List<Order> lstOrders = new List<Order>();
        for (Integer i=0; i <cnt ; i++) {
            Order ordObj = new Order();
            ordObj.AccountId = accts.get(math.mod(i, accts.size())).Id;
            ordObj.Pricebook2Id = Constants.STANDARD_PRICEBOOK_ID;
            ordObj.Status='Draft';
            ordObj.EffectiveDate = System.today();
            lstOrders.add(ordObj);
        }
        return lstOrders;
    }

    /**
     * @name CreateOrderItems
     * @description Constructs a list of OrderItem records for unit tests
    **/
    public static  List<OrderItem> ConstructOrderItems(integer cnt, list<pricebookentry> pbes, list<order> ords){
        //ToDo: Ensure this method returns a list of size cnt of OrderItem records
        //  related to the provided Pricebook Entries
        //  and related to the provided Orders
        //  with all of the required fields populated.
        //  Hint: Use the DEFAULT_ROWS constant for Quantity as it will be used in the next challenge
        List<OrderItem> lstItems = new List<OrderItem>();
        for(Integer i = 0; i <cnt; i++) {
            OrderItem ordObj = new OrderItem();
            ordObj.PricebookEntryId = pbes.get(math.mod(i, pbes.size())).Id;
            ordObj.OrderId = ords.get(math.mod(i, ords.size())).Id;
            ordObj.Quantity = Constants.DEFAULT_ROWS;
            ordObj.UnitPrice = 250;
            lstItems.add(ordObj);
        }
        
        return lstItems;
    }

    /**
     * @name SetupTestData
     * @description Inserts accounts, contacts, Products, PricebookEntries, Orders, and OrderItems.
    **/
    public static void InsertTestData(Integer cnt){
        //ToDo: Ensure this method calls each of the construct methods
        //  and inserts the results for use as test data.

        CollaborationGroup groups = TestDataFactory.ConstructCollaborationGroup();
        insert groups;
        
        List<Product2>  products= TestDataFactory.ConstructProducts(cnt);
        insert products;
        
        List<PriceBookEntry> entries = TestDataFactory.ConstructPricebookEntries(products);
        insert entries;
        
        List<Account> accts = TestDataFactory.ConstructAccounts(cnt);
        insert accts;
        
        List<Contact> contacts = TestDataFactory.ConstructContacts(cnt,accts);
        insert contacts;
        
        List<Order> orders = TestDataFactory.ConstructOrders( cnt,  accts);
        insert orders;
        
        List<OrderItem> items = TestDataFactory.ConstructOrderItems(cnt, entries, orders);
        insert items;

    }

    public static void VerifyQuantityOrdered(Product2 originalProduct, Product2 updatedProduct, Integer qtyOrdered) {
        System.assertEquals((updatedProduct.Quantity_Ordered__c - originalProduct.Quantity_Ordered__c), qtyOrdered);
    }

}