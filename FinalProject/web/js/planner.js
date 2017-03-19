var airportList = [];

var planner = {
    init: function () {
        var object = this;

        $('.flight-search input').focus(function () {
            $('.form-error').hide();
            $(this).removeClass('error');
        });

        $("#source").autocomplete({
            source: function (request, resolve) {
                resolve(airportList);
            }
        });

        $("#destination").autocomplete({
            source: function (request, resolve) {
                resolve(airportList);
            },
            select: function (event, ui) {
                var airportName = ui.item.value.split(' - ')[1];
                object.getDestinationGpsCoordinates(airportName);
            }
        });

        $('#source').keyup(function () {
            object.searchAirports($(this).val());
        });

        $('#destination').keyup(function () {
            object.searchAirports($(this).val());
        });

        $('.search').click(function (e) {
            e.preventDefault();
            var validation = object.validateForm();
            $('.form-error p').hide();

            if (!validation.length) {
                object.getFlights();
            } else {
                $('.form-error').show();
                $('p.error-' + validation).show();
            }
        });

        $('#flight-date').change(function () {
            planner.getDestinationWeatherForecast($(this).val());
        });
    },
    validateForm: function () {
        var error = '';

        if (!$('#source').val().length) {
            $('#source').addClass('error');
            error = 'empty-fields';
        }

        if (!$('#destination').val().length) {
            $('#destination').addClass('error');
            error = 'empty-fields';
        }

        if (!$('#passengers').val().length) {
            $('#passengers').addClass('error');
            error = 'empty-fields';
        }

        if (!$('#flight-date').val().length) {
            $('#flight-date').addClass('error');
            error = 'empty-fields';
        } else {
            var travelDate = new Date($('#flight-date').val()).getTime();

            if (travelDate < jQuery.now()) {
                error = 'travel-date';
            }
        }

        return error;
    },
    searchAirports: function (searchTerm) {
        if (searchTerm.length > 1) {
            $.ajax({
                url: 'https://iatacodes.org/api/v6/autocomplete.jsonp',
                type: 'GET',
                crossDomain: true,
                dataType: 'JSONP',
                data: {'api_key': 'c9a88c43-2e76-47ef-9779-54588569b52e', 'query': searchTerm},
                success: function (data) {
                    airportList = [];

                    $.each(data.response.airports, planner.addAirportToList);
                    $.each(data.response.airports_by_cities, planner.addAirportToList);
                }
            });
        }
    },
    getDestinationGpsCoordinates: function (airportName) {
        $.ajax({
            url: 'https://maps.googleapis.com/maps/api/geocode/json?address=' + encodeURI(airportName) + '&key=AIzaSyDgqKpfsG6ksNZtVGIEgJ9c_nlibI44X6k',
            type: 'GET',
            success: function (data) {
                var coordinates = data.results[0].geometry.location;
                $('#destinationLong').val(coordinates.lng);
                $('#destinationLat').val(coordinates.lat);
            }
        });
    },
    getDestinationWeatherForecast: function (date) {
        var timestamp = new Date(date).getTime() / 1000;
        var skycons = new Skycons();

        if ($('#destinationLat').val().length && $('#destinationLong').val().length) {
            $.ajax({
                url: 'https://api.darksky.net/forecast/5a187554ebca604cf5d2625f2e9d9c40/' + $('#destinationLat').val() + ',' + $('#destinationLong').val() + ',' + timestamp,
                type: 'GET',
                crossDomain: true,
                dataType: 'JSONP',
                data: {'units': 'si'},
                success: function (data) {
                    $('div.weather-results div.summary').html(data.daily.data[0].summary);
                    $('div.weather-results div.temp-max').html('High: ' + Math.round(data.daily.data[0].temperatureMax) + ' C (feels like ' + Math.round(data.daily.data[0].apparentTemperatureMax) + ' C)');
                    $('div.weather-results div.temp-min').html('Low: ' + Math.round(data.daily.data[0].temperatureMin) + ' C (feels like ' + Math.round(data.daily.data[0].apparentTemperatureMin) + ' C)');

                    skycons.add("weather-icon", data.daily.data[0].icon);
                    skycons.play();
                }
            });
        }
    },
    getFlights: function () {
        $('div.loading').show();
        $('table.flight-results').hide();
        $('div.weather-results').hide();
        $('#flight-date').trigger('change');

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
            contentType: 'application/json',
            success: function (data) {
                $('div.loading').hide();
                $('table.flight-results').html('<tr><th>Price</th><th>Departs / Arrives</th><th>Duration</th><th>Flight Number</th></tr>');

                $.each(data.trips.tripOption, function (key, value) {
                    var price = value.saleTotal;
                    var duration = value.slice[0]['duration'];
                    var hours = Math.floor(duration / 60);
                    var minutes = (duration % 60);

                    var departureDate = value.slice[0]['segment'][0]['leg'][0]['departureTime'];
                    var lastElement = value.slice[0]['segment'].length - 1;
                    var arrivalDate = value.slice[0]['segment'][lastElement]['leg'][0]['arrivalTime']

                    var carrierCode = value.slice[0]['segment'][0]['flight']['carrier'];
                    var flightNumber = value.slice[0]['segment'][0]['flight']['number'];

                    $('table.flight-results').append('<tr><td>' + price + '</td><td>' + planner.parseDate(departureDate) + ' / ' + planner.parseDate(arrivalDate) + '</td><td>' + hours + ' hrs ' + minutes + ' mins</td><td>' + carrierCode + flightNumber + '</td></tr>');
                    $('table.flight-results').show();
                    $('div.weather-results').show();
                });
            }
        });
    },
    addAirportToList: function (key, value) {
        var fullName = value.code + ' - ' + value.name;

        if (jQuery.inArray(fullName, airportList) < 0) {
            airportList.push(fullName);
        }
    },
    parseDate: function (date) {
        return date.split('T')[1].substring(0, 5);
    }
};


