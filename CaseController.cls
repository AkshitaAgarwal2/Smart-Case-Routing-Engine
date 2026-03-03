public with sharing class CaseController {

    @AuraEnabled(cacheable=true)
    public static List<Case> getCases(){

        // Check CRUD Permission
        if(!Schema.sObjectType.Case.isAccessible()){
            throw new AuraHandledException('You do not have permission to access Case records.');
        }

        return [
            SELECT Id, Description, Priority, Owner.Name
            FROM Case
            ORDER BY CreatedDate DESC
            LIMIT 50
        ];
    }
}