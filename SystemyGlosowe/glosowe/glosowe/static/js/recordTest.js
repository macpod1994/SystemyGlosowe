/**
 * Created by kalksever on 2016-12-03.
 */

'use strict';

var recordTest = function () {

    d3.select('.plot-container').remove();
    d3.select("#identification-result p").html("");

    alert("Po kliknięciu OK masz 3 sekundy na nagranie komendy");

    d3.json('/wizualizacja/record/',function(response) {
        console.log(response);
        distance = response.glob;
        for(var i in distance) {
            distance[i] = distance[i].toFixed(3);
        }
        bestFit = response.nazwa;
        d3.select("#identification-result p").html("Rozpoznana komenda: " + bestFit);
        genChart();
    });
};