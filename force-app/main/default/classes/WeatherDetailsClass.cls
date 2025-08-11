public class WeatherDetailsClass {
    
    @AuraEnabled
    public static WeatherDetailsWrapper getWeatherDetails(String cityName) {
        String apiKey = '91013d1701d3e2fd77063c22949a2790';
        String endpoint = 'https://api.openweathermap.org/data/2.5/weather';
        endpoint += '?q=' + cityName;
        endpoint += '&units=metric';
        endpoint += '&APPID=' + apiKey;

        System.debug('Endpoint URL: ' + endpoint);

        // Callout to Weather API
        Http http = new Http();
        HttpRequest req = new HttpRequest();
        req.setEndpoint(endpoint);
        req.setMethod('GET');

        HttpResponse res = http.send(req);
        System.debug('Response: ' + res.getBody());

        WeatherDetailsWrapper weatherDet = new WeatherDetailsWrapper();

        if (res.getStatusCode() == 200) {
            Map<String, Object> result = (Map<String, Object>) JSON.deserializeUntyped(res.getBody());
            weatherDet.city = String.valueOf(result.get('name'));

            Map<String, Object> mainResult = (Map<String, Object>) result.get('main');
            weatherDet.temperature = String.valueOf(mainResult.get('temp'));
            weatherDet.pressure = String.valueOf(mainResult.get('pressure'));
            weatherDet.humidity = String.valueOf(mainResult.get('humidity'));
            weatherDet.feelsLike = String.valueOf(mainResult.get('feels_like'));
            weatherDet.tempMin = String.valueOf(mainResult.get('temp_min'));
            weatherDet.tempMax = String.valueOf(mainResult.get('temp_max'));
        }

        System.debug('Weather Details: ' + weatherDet);
        return weatherDet;
    }

    // Wrapper class to store weather details
    public class WeatherDetailsWrapper {
        @AuraEnabled public String city { get; set; }
        @AuraEnabled public String temperature { get; set; }
        @AuraEnabled public String pressure { get; set; }
        @AuraEnabled public String humidity { get; set; }
        @AuraEnabled public String feelsLike { get; set; }
        @AuraEnabled public String tempMin { get; set; }
        @AuraEnabled public String tempMax { get; set; }
    }
}