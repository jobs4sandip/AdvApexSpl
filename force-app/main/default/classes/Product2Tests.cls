@isTest (seeAllData=false)
private class Product2Tests {

    /**
     * @name product2Extension_UnitTest
     * @description UnitTest for product2Extension
    **/
    
    static TestMethod void Product2Extension_UnitTest(){
        PageReference pageRef = page.Product2New;
        Product2 prod = new Product2(Name='test', isActive= true);
        ApexPages.StandardController controller = new ApexPages.StandardController(prod);
        Test.startTest();
        Product2Extension ext = new Product2Extension(controller);
        System.assertEquals(Constants.DEFAULT_ROWS, ext.productsToInsert.size());
        ext.addRows();
        System.assertEquals(2*Constants.DEFAULT_ROWS, ext.productsToInsert.size());
        
        for(Integer i=0; i< Constants.DEFAULT_ROWS; i++) {
            
            Product2 newProduct = new Product2(Name='Product'+i, Initial_Inventory__c = 10, isActive=true, family= Constants.PRODUCT_FAMILY.get(math.mod(i,4)).getValue());
            ext.productsToInsert.get(i).productRecord = newProduct;
            
            PriceBookEntry entry = new PriceBookEntry(UnitPrice = 100, isActive=true);
            ext.productsToInsert.get(i).pricebookEntryRecord = entry;
            
        }
        ext.save();
        ext.GetFamilyOptions();
        ext.GetInventory();
        List<Product2> selectedProd = [Select id from Product2];
        System.assertEquals(Constants.DEFAULT_ROWS, selectedProd.size());
        Test.stopTest();
    }

    
    static TestMethod void Product2Trigger_UnitTest() {
        Test.startTest();
        Product2 aProduct = new Product2();
        aProduct.Name = 'Test';
        aProduct.Family = 'Dessert';
        aProduct.IsActive = true;
        aProduct.Quantity_Ordered__c = 5;
        aProduct.Initial_Inventory__c = 10;
        insert aProduct;
        
        CollaborationGroup cg = new CollaborationGroup();
        cg.Name = 'TEST' + Constants.INVENTORY_ANNOUNCEMENTS;
        cg.Description = 'Description';
        cg.CollaborationType = 'Public';
        insert cg;
        
        aProduct.Quantity_Ordered__c=96;
        update aProduct;
        Test.stopTest();
    } 

}