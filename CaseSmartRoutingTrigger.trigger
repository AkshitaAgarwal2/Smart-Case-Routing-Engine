trigger CaseSmartRoutingTrigger on Case (before insert, before update) {

    if(Trigger.isBefore){
        SmartCaseRouter.routeCases(Trigger.new);
    }

}