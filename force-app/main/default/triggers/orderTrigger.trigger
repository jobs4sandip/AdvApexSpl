trigger orderTrigger on Order (after update) {

    
    OrderHelper.AfterUpdate(trigger.new , trigger.old);


}