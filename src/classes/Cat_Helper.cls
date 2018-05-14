public class Cat_Helper {
    
    @future(callout=true)
    public static void catBreedFeedback(Id catId){
        System.debug('@@@ Cat_Helper catBreedFeedback()');
        
        Cat__c cat = [SELECT Id, modelId__c, Cat_Breed__c FROM Cat__c WHERE Id = :catId LIMIT 1];
        System.debug('*** cat.modelId__c ' + cat.modelId__c);
        System.debug('*** cat.Cat_Breed__c ' + cat.Cat_Breed__c);
        
        String name = cat.Id;
        String expectedLabel = cat.Cat_Breed__c;
        String modelId = cat.modelId__c;
        Blob fileBlob = getImageBlobFromAttachment(cat.Id);
        
        Einstein_PredictionService Service = new Einstein_PredictionService(Einstein_PredictionService.Types.IMAGE);
        Einstein_Example feedbackResult = Service.createFeedbackImageExample(name, expectedLabel, modelId, fileBlob);
        
        cat.ExampleCreatedAt__c = feedbackResult.createdAt;
        cat.ExampleId__c = String.valueOf(feedbackResult.id);
        cat.ExampleDatasetId__c = String.valueOf(feedbackResult.label.datasetId);
        cat.ExampleLabelName__c = feedbackResult.label.name;
        cat.ExampleLabelId__c = String.valueOf(feedbackResult.label.Id);
        cat.ExampleNum__c = feedbackResult.label.numExamples;
        
        cat.Feedback__c = false;
        update cat;

        System.debug('*** cat.ExampleCreatedAt__c ' + cat.ExampleCreatedAt__c);
        System.debug('*** cat.ExampleId__c ' + cat.ExampleId__c);
        System.debug('*** cat.ExampleDatasetId__c ' + cat.ExampleDatasetId__c);
        System.debug('*** cat.ExampleLabelName__c ' + cat.ExampleLabelName__c);
        System.debug('*** cat.ExampleLabelId__c ' + cat.ExampleLabelId__c);
        System.debug('*** cat.ExampleNum__c ' + cat.ExampleNum__c);
        
    }
    
    public static Blob getImageBlobFromAttachment(Id catId) {
        System.debug('@@@ getImageBlobFromAttachment()');
        List<Attachment> atts = [SELECT Id, body FROM Attachment WHERE ParentId=:catId];
        if (atts.size()>0) {
            System.debug('*** atts.get(0) ' + atts.get(0));
            return atts.get(0).body;
        }
        return null;
    }
    
}