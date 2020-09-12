@isTest (seeAllData=false)
private class OrderTests {

    @testSetup
    static void SetupTestData() {
        TestDataFactory.InsertTestData(20);
    }

    
    static TestMethod void OrderUpdate_UnitTest() {
    	Order selectedOrder = [Select name,Status, Id from Order limit 1];
        Product2 oldProd = [Select Quantity_Ordered__c, Name, Id from Product2 limit 1];
        
        selectedOrder.Status = Constants.ACTIVATED_ORDER_STATUS;
        update selectedOrder;
        
        Product2 updatedProd = [Select Quantity_Ordered__c, Name, Id from Product2 limit 1];
        
        TestDataFactory.VerifyQuantityOrdered(oldProd,updatedProd,Constants.DEFAULT_ROWS);
    }

    
    static TestMethod void OrderExtension_UnitTest() {
        PageReference reference = Page.OrderEdit;
        Test.setCurrentPage(reference);
        Order CurOrder = [Select Id,Status from Order limit 1];
        ApexPages.StandardController controller = new Apexpages.StandardController(CurOrder);
        OrderExtension ext = new OrderExtension(controller);
        System.assertEquals(5, ext.orderItemList.size());
        ext.selectedFamily = 'Dessert';
        ext.SelectFamily();
        ext.OnFieldChange();
        ext.First();
        ext.Next();
        ext.Previous();
        ext.Last();
        ext.GetHasNext();
        ext.GetPageNumber();
        ext.GetHasPrevious();
        ext.GetTotalPages();
        ext.GetFamilyOptions();
        ext.Save();
        ChartHelper.GetInventory();
    }

    
}