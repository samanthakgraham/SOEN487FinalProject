<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Final Project - SOEN487 W17</title>

        <link rel="stylesheet" href="css/main.css">
        <script src="https://code.jquery.com/jquery-3.1.1.min.js"></script>

        <!-- Bootstrap CSS -->
        <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css" integrity="sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u" crossorigin="anonymous">

        <!-- Bootstrap JavaScript -->
        <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js" integrity="sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa" crossorigin="anonymous"></script>    
    </head>
    <body>
        <div class="container-fluid main-content">
            <h3>Trip Planner</h3>
            <form class="flight-search">
                <input type="text" name="source" id="source" placeholder="From (city/airport code)" class="form-control" />                
                <input type="text" name="destination" id="destination" placeholder="To (city/airport code)" class="form-control" />                
                <input type="date" name="flight-date" class="form-control" />
                <button class="btn btn-success">Search for flights</button>
                <div class="results">
                    <div class="source airport-result">asdf</div>
                    <div class="dest airport-result">1234</div>
                </div>                
            </form>
            <div class="flight-results">

            </div>
            <div class="weather-results">

            </div>
            <div class="photo-results">

            </div>
        </div>        
        <script type="text/javascript">
            $('#source').keyup(function () {
                searchAirports($(this).val());
            });
            $('#destination').keyup(function () {
                searchAirports($(this).val());
            });

            function searchAirports(searchTerm) {
                if (searchTerm.length > 2) {
                    $.ajax({
                        url: 'https://iatacodes.org/api/v6/autocomplete.jsonp',
                        type: 'GET',   
                        crossDomain: true,
                        dataType: 'JSONP',
                        data: {'api_key': 'c9a88c43-2e76-47ef-9779-54588569b52e', 'query': searchTerm},
                        success: function (data) {
                            console.log(data);
                        }
                    });
                }
            }
        </script>
    </body>
</html>
