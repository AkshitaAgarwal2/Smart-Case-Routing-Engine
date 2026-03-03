public with sharing class SmartCaseRouter {

    public static void routeCases(List<Case> caseList){

        Map<String, Id> skillUserMap = getSkillUserMap();
        List<Smart_Routing_Rules__mdt> rules = getRoutingRules();

        for(Case c : caseList){

            if(String.isBlank(c.Description)){
                continue;
            }

            applyRoutingLogic(c, rules, skillUserMap);
        }
    }

    // ✅ Separate Method – Get Metadata Rules
    private static List<Smart_Routing_Rules__mdt> getRoutingRules(){

        if(!Schema.sObjectType.Smart_Routing_Rules__mdt.isAccessible()){
            throw new AuraHandledException('No access to Routing Rules');
        }

        return [
            SELECT Keyword__c, Skill__c, Priority__c
            FROM Smart_Routing_Rules__mdt
        ];
    }

    // ✅ Separate Method – Get Users With Skills
    private static Map<String, Id> getSkillUserMap(){

        Map<String, Id> skillUserMap = new Map<String, Id>();

        if(!Schema.sObjectType.User.isAccessible()){
            throw new AuraHandledException('No access to User');
        }

        for(User u : [
            SELECT Id, Skill__c
            FROM User
            WHERE Skill__c != NULL
            WITH SECURITY_ENFORCED
        ]){

            skillUserMap.put(u.Skill__c, u.Id);
        }

        return skillUserMap;
    }

    // ✅ Separate Method – Routing Logic
    private static void applyRoutingLogic(
        Case c,
        List<Smart_Routing_Rules__mdt> rules,
        Map<String, Id> skillUserMap
    ){

        String description = c.Description.toLowerCase();

        for(Smart_Routing_Rules__mdt rule : rules){

            if(description.contains(rule.Keyword__c.toLowerCase())){

                c.Priority = rule.Priority__c;

                if(skillUserMap.containsKey(rule.Skill__c)){
                    c.OwnerId = skillUserMap.get(rule.Skill__c);
                }

                break;
            }
        }
    }
}