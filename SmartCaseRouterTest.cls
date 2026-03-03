@isTest
private class SmartCaseRouterTest {

    @isTest static void testRouting(){

        Skill__c skill = new Skill__c(Name='Technical');
        insert skill;

        User u = [SELECT Id FROM User WHERE IsActive = true LIMIT 1];

        Test.startTest();

        Case c = new Case(
            
            Description = 'User facing login error'
        );

        insert c;

        Test.stopTest();

        Case updatedCase = [SELECT OwnerId FROM Case WHERE Id = :c.Id];

        System.assertNotEquals(null, updatedCase.OwnerId);
    }
}