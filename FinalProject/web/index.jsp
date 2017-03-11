<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Final Project - SOEN487 W17</title>

        <link rel="stylesheet" href="css/main.css">
        <link rel="stylesheet" href="//code.jquery.com/ui/1.12.1/themes/base/jquery-ui.css">
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

        <script src="https://code.jquery.com/jquery-1.12.4.js"></script>
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>                    
        <script src="https://code.jquery.com/ui/1.12.1/jquery-ui.js"></script>
    </head>
    <body>
        <div class="container-fluid main-content">
            <h3>Trip Planner</h3>
            <form class="flight-search">
                <div class="form-group">
                    <input type="text" name="source" id="source" placeholder="From (city/airport code)" class="form-control" />                    
                    <input type="text" name="destination" id="destination" placeholder="To (city/airport code)" class="form-control" />                        
                </div>
                <div class="form-group">
                    <input type="date" name="flight-date" id="flight-date" class="form-control" />
                    <input type="number" name="passengers" id="passengers" placeholder="Number of (adult) passengers" class="form-control" />
                </div>
                <div class="form-group">
                    <button class="btn btn-success search">Search for flights</button>  
                    <div class="loading"></div>
                </div>                
            </form>
            <ul class="flight-results"></ul>
            <div class="weather-results"></div>
            <div class="photo-results"></div>
        </div>        
        <script type="text/javascript">
            var airportList = [];

            $(document).ready(function () {
                $("#source").autocomplete({
                    source: function (request, resolve) {
                        resolve(airportList);
                    }
                });

                $("#destination").autocomplete({
                    source: function (request, resolve) {
                        resolve(airportList);
                    }
                });
            });

            $('#source').keyup(function () {
                searchAirports($(this).val());
            });

            $('#destination').keyup(function () {
                searchAirports($(this).val());
            });

            $('.search').click(function (e) {
                e.preventDefault();
                $('div.loading').show();
                
                var request = {
                    "request": {
                        "passengers": {
                            "adultCount": $('#passengers').val()
                        },
                        "slice": [
                            {
                                "origin": $('#source').val().substring(0, 3),
                                "destination": $('#destination').val().substring(0, 3),
                                "date": $('#flight-date').val()
                            }
                        ],
                        "solutions": "5"
                    }
                };
                
                $.ajax({
                    url: 'https://www.googleapis.com/qpxExpress/v1/trips/search?key=AIzaSyBtKuHsOFmU1YvGYZbcNvxL9D0BoAP2MQs',
                    type: 'POST',
                    data: JSON.stringify(request),
                    crossDomain: true,
                    contentType: 'application/json',
                    success: function (data) {
                        $('div.loading').hide();
                        console.log(data);
                        $.each(data.trips.tripOption, function(key, value) {
                            var price = value.saleTotal;
                            var duration = value.slice[0]['duration'];
                            $('ul.flight-results').append('<li>Price: ' + price + '; Duration: ' + duration / 60 + ' hours</li>');
                        });
                    }
                });
            });

            function searchAirports(searchTerm) {
                if (searchTerm.length > 1) {
                    $.ajax({
                        url: 'https://iatacodes.org/api/v6/autocomplete.jsonp',
                        type: 'GET',
                        crossDomain: true,
                        dataType: 'JSONP',
                        data: {'api_key': 'c9a88c43-2e76-47ef-9779-54588569b52e', 'query': searchTerm},
                        success: function (data) {
                            airportList = [];
                            $.each(data.response.airports, addAirportToList);
                            $.each(data.response.airports_by_cities, addAirportToList);
                        }
                    });
                }
            }

            function addAirportToList(key, value) {
                var fullName = value.code + ' - ' + value.name;

                if (jQuery.inArray(fullName, airportList) < 0) {
                    airportList.push(fullName);
                }
            }
        </script>
    </body>
</html>
