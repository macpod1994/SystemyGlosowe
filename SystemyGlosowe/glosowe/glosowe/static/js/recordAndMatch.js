'use strict';

var distance = [0,1,2,3];
var bestFit = 'lewo';
// var w = window.open('','','width=100,height=100');
// w.document.write('Message');
// w.focus();
// setTimeout(function() {w.close();}, 5000);

var recordAndMatch = function() {
    d3.select("#input-row input").remove();
    d3.select("#file-button button").html("Rozpoznaj gotowy plik");

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