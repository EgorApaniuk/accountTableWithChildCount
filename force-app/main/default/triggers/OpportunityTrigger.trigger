trigger OpportunityTrigger on Opportunity (After Insert,After update,After Delete,After Undelete) {
    List<Opportunity> opportunities = Trigger.isDelete ? Trigger.old : Trigger.new;
    AccountController.opportunityCount(opportunities,opportunities);
}