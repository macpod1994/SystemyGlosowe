'use strict';

var distance = [0,1,2,3];
var bestFit = 'lewo';

var recordAndMatch = function() {
    d3.select('.plot-container').remove();
    d3.select("#identification-result p").html("");

    alert("Po kliknięciu OK masz po 3 sekundy na nagranie każdego wzorca");

    d3.select("#input-row").append('div').html('Powiedz: lewo');
    d3.json('/wizualizacja/record_model/lewo/', function () {
        d3.select("#input-row div").html('Powiedz: prawo');
        d3.json('/wizualizacja/record_model/right/', function () {
            d3.select("#input-row div").html('Powiedz: start');
            d3.json('/wizualizacja/record_model/start/', function () {
                d3.select("#input-row div").html('Powiedz: stop');
                d3.json('/wizualizacja/record_model/stop/', function () {
                    d3.select("#input-row div").remove();
                });
            });
        });
    });
};