public class EinsteinVision_Admin {
    
    @AuraEnabled
    public static void createDatasetFromUrl(String zipUrl) {
        System.debug('@@@ createDatasetFromUrl()');
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        service.createDatasetFromUrlAsync(zipUrl);
        System.debug('*** zipUrl ' + zipUrl);
    }
    
    @AuraEnabled
    public static List<EinsteinVision_Dataset> getDatasets() {
        System.debug('@@@ getDatasets()');
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        System.debug('*** datasets ' + datasets);
        return datasets;
    }
    
    @AuraEnabled
    public static String trainDataset(Decimal datasetId) {
        System.debug('@@@ trainDataset()');
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Model model = service.trainDataset(Long.valueOf(String.valueOf(datasetId)), 'Training', 0, 0, '');
        System.debug('*** model.modelId ' + model.modelId);
        return model.modelId;
    }
    
    @AuraEnabled
    public static void deleteDataset(Long datasetId) {
        System.debug('@@@ deleteDataset()');
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        System.debug('*** datasetId ' + datasetId);
        service.deleteDataset(datasetId);
    }
    
    @AuraEnabled
    public static List<EinsteinVision_Model> getModels(Long datasetId) {
        System.debug('@@@ getModels()');
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Model[] models = service.getModels(datasetId);
        System.debug('*** models ' + models);
        return models;
    }
    
    @AuraEnabled
    public static void getCatPrediction(Id catId, String fileName, String base64) {
        System.debug('@@@ getCatPrediction()');
        Blob fileBlob = EncodingUtil.base64Decode(base64);
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        for (EinsteinVision_Dataset dataset : datasets) {
            if (dataset.Name.equals('Cats')) {
                EinsteinVision_Model[] models = service.getModels(dataset);
                EinsteinVision_Model model = models.get(0);
                EinsteinVision_PredictionResult result = service.predictBlob(model.modelId, fileBlob, '');
                EinsteinVision_Probability probability = result.probabilities.get(0);

                System.debug('*** dataset ' + dataset);
                System.debug('*** models ' + models);
                System.debug('*** model ' + model);
                System.debug('*** model.modelId ' + model.modelId);
                System.debug('*** result ' + result);
                System.debug('*** result1 ' + result.probabilities[0]);
                System.debug('*** result2 ' + result.probabilities[1]);
                System.debug('*** result3 ' + result.probabilities[2]);
                System.debug('*** result4 ' + result.probabilities[3]);
                System.debug('*** result5 ' + result.probabilities[4]);
                System.debug('*** probability ' + probability);
                System.debug('*** probability.label ' + probability.label);
                
                Cat__c cat = [SELECT Id FROM Cat__C WHERE Id=:catId];
                cat.Cat_Breed__c = probability.label;
                cat.modelId__c = model.modelId;
                cat.Probability01__c = result.probabilities[0].probability;
                cat.Probability02__c = result.probabilities[1].probability;
                cat.Probability03__c = result.probabilities[2].probability;
                cat.Probability04__c = result.probabilities[3].probability;
                cat.Probability05__c = result.probabilities[4].probability;
                cat.label01__c = result.probabilities[0].label;
                cat.label02__c = result.probabilities[1].label;
                cat.label03__c = result.probabilities[2].label;
                cat.label04__c = result.probabilities[3].label;
                cat.label05__c = result.probabilities[4].label;
                update cat;
                Attachment[] attsOld = [SELECT Id FROM Attachment WHERE ParentId=:catId];
                delete attsOld;
                Attachment att = new Attachment();
                att.Body = fileBlob;
                att.ParentId = cat.Id;
                att.Name = fileName;
                System.debug('*** att ' + att);
                insert att;
            }
        }
    }
    
    @AuraEnabled
    public static List<EinsteinVision_Label> getCatLabels() {
        System.debug('@@@ getCatLabels()');
        EinsteinVision_PredictionService service = new EinsteinVision_PredictionService();
        EinsteinVision_Dataset[] datasets = service.getDatasets();
        for (EinsteinVision_Dataset dataset : datasets) {
            System.debug('*** dataset.labelSummary ' + dataset.labelSummary);
            System.debug('*** dataset.labelSummary.labels ' + dataset.labelSummary.labels);
            if (dataset.Name.equals('Cats')) {
                return dataset.labelSummary.labels;
            }
        }
        return null;
    }
    
    @AuraEnabled
    public static String getImageUrlFromAttachment(Id catId) {
        System.debug('@@@ getImageUrlFromAttachment()');
        List<Attachment> atts = [SELECT Id FROM Attachment WHERE ParentId=:catId];
        if (atts.size()>0) {
            System.debug('*** atts.get(0) ' + atts.get(0));
            return atts.get(0).Id;
        }
        return '';
    }
    
}