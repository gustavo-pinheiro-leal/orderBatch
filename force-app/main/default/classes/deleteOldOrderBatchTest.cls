@IsTest
public with sharing class deleteOldOrderBatchTest {
    @TestSetup
    public static void makeData(){
        TestFactorySObject sobjectFactory = TestFactorySObject.getInstance();

        Account newAccount = (Account)sobjectFactory.createSObject(new Account());
        insert newAccount;

        //order created today
        Order newOrder = (Order)sobjectFactory.createSObject(
            new Order (AccountId = newAccount.Id, Pricebook2Id = Test.getStandardPricebookId())
        );

        //order created more than 6 months ago
        Order newOrderOld = (Order)sobjectFactory.createSObject(
            new Order (AccountId = newAccount.Id, Pricebook2Id = Test.getStandardPricebookId(), EffectiveDate = Date.today().addMonths(-7))
        );
        insert (new List<Order>{newOrder, newOrderOld});

        ContentVersion newFile = (ContentVersion)sobjectFactory.createSObject(new ContentVersion());
        insert newFile;

        ContentDocumentLink newLink = new ContentDocumentLink(
            ContentDocumentId = [SELECT Id FROM ContentDocument WHERE LatestPublishedVersionId =: newFile.Id LIMIT 1].Id,
            LinkedEntityId = newOrderOld.Id
        );
        insert newLink;
    }

    @IsTest
    public static void deleteOldOrderBatchTest(){
        Test.startTest();
        Database.executeBatch(new deleteOldOrderBatch(), 10);
        Test.stopTest();

        List<Order> remainingOrders = [SELECT Id FROM Order];
        List<ContentDocument> remainingDocuments = [SELECT Id FROM ContentDocument];
        System.assertEquals(1, remainingOrders.size(), 'Expected one order remaining only.');
        System.assertEquals(0, remainingDocuments.size(), 'Expected no remaining documents.');
    }

}