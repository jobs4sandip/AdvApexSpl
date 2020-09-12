public class OrderHelper {

    
    public static void AfterUpdate(List<Order> newList, List<Order> oldList){
        Set<Id> orderIds = new Set<Id>();

        for ( Integer i=0; i<newList.size(); i++ ){
            if ( newList[i].Status ==  Constants.ACTIVATED_ORDER_STATUS && oldList[i].Status == Constants.DRAFT_ORDER_STATUS ){
                orderIds.add(newList[i].Id);
            }
        }

        RollUpOrderItems(orderIds);
    }

    
    public static void RollUpOrderItems(Set<Id> activatedOrderIds){
        
        
        Map<Id,Product2> productMap = new Map<Id,Product2>();
        Set<Id> productIds = new Set<Id>();  
        
        for(OrderItem oi: [Select Id,Quantity,Product2Id from OrderItem where OrderId in :activatedOrderIds]){
            productIds.add(oi.Product2Id);

        }

        productMap = new Map<Id,Product2>([Select id,Quantity_Ordered__c from product2 where id in :productIds]);
        List<AggregateResult> groupedResult = [Select Product2Id,sum(Quantity) totQnty 
                            from OrderItem where product2Id in :productMap.keySet() group by product2Id];
        
        for(AggregateResult result : groupedResult) {
            productMap.get((String)result.get('Product2Id')).Quantity_Ordered__c = Integer.valueOf(result.get('totQnty'));
        }
        
        update productMap.values();
        
    }

}