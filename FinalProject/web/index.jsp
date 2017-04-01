<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1">
        <title>Final Project - SOEN487 W17</title>

        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="css/pikaday.css">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>                    
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>

        <script src="js/moment.js" type="text/javascript"></script>
        <script src="js/pikaday.js" type="text/javascript"></script>
        <script src="js/skycons.js" type="text/javascript"></script>
        <script src="js/planner.js" type="text/javascript"></script>
    </head>
    <body>
        <div class="container-fluid main-content">
            <h3>Trip Planner</h3>
            <form class="flight-search">
                <div class="form-group">
                    <input type="text" name="source" id="source" placeholder="From (city)" class="form-control" />                    
                    <input type="text" name="destination" id="destination" placeholder="To (city)" class="form-control" />
                    <input type="hidden" name="destinationLat" id="destinationLat" />
                    <input type="hidden" name="destinationLong" id="destinationLong" />
                </div>
                <div class="form-group">
                    <input type="text" name="flight-date" id="flight-date" class="form-control" placeholder="Flight date" />
                    <input type="number" name="passengers" id="passengers" placeholder="Number of (adult) passengers" class="form-control" />
                </div>
                <div class="form-group">
                    <button class="btn btn-success search">Search for flights</button>  
                    <div class="loading"></div>
                </div>
                <div class="form-group form-error">
                    <p class="text-danger bg-danger error-empty-fields">You must fill in all fields</p>
                    <p class="text-danger bg-danger error-travel-date">Your travel date cannot be in the past</p>
                </div>
            </form>
            <table class="flight-results"></table>
            <div class="weather-results">
                <h4>Weather Forecast: </h4>
                <canvas id="weather-icon" width="75" height="75"></canvas>
                <div class="summary"></div>
                <div class="temp-max"></div>
                <div class="temp-min"></div>
                <div class="darksky-logo"></div>
            </div>
            <div class="photo-results"></div>
        </div>        
        <script type="text/javascript">
            $(document).ready(function () {
                planner.init();
                
                var picker = new Pikaday({ field: document.getElementById('flight-date') });
            });
        </script>  
    </body>
</html>
