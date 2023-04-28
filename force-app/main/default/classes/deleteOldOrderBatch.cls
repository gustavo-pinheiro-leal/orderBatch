global with sharing class deleteOldOrderBatch implements Database.Batchable<SObject> {
    global deleteOldOrderBatch() {}

    global Database.QueryLocator start(Database.BatchableContext context){
        DevParameters__mdt params = [SELECT Value__c FROM DevParameters__mdt WHERE DeveloperName = 'MaxNumberMonthsOrder'];
        
        Date numberOfMonthsAgo = Date.today().addMonths(-1 * Integer.valueOf(params.Value__c));
        
        String query = 'SELECT Id FROM Order WHERE EffectiveDate <: numberOfMonthsAgo';
        
        return Database.getQueryLocator(query);
    }

    global void execute(Database.BatchableContext context, List<Order> scope){
        Set<Id> orderIds = new Set<Id>();
        
        for(Order order : scope){
            orderIds.add(order.Id);
        }
        
        List<ContentDocumentLink> contentDocumentLinkList = [
            SELECT Id, ContentDocumentId
            FROM ContentDocumentLink WHERE LinkedEntityId =: orderIds
        ];
        
        if(!contentDocumentLinkList.isEmpty()){
            Set<Id> contentDocumentIdSet = new Set<Id>();

            for(ContentDocumentLink link : contentDocumentLinkList){
                contentDocumentIdSet.add(link.ContentDocumentId);
            }

            List<ContentDocument> contentDocumentList = [
                SELECT Id
                FROM ContentDocument
                WHERE Id IN: contentDocumentIdSet
            ];

            delete contentDocumentList;
        }

        delete scope;
    }

    global void finish(Database.BatchableContext context){
    }

}