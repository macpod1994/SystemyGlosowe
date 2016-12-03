/**
 * Created by kalksever on 2016-11-30.
 */

'use strict';

var sendAndMatch = function () {

    d3.select('.plot-container').remove();
    d3.select("#identification-result p").html("");

    var nr = Math.ceil(Math.random()*4);
    var name = Math.ceil(Math.random()*4);
    switch(name) {
        case 1:
            name = 'lewo';
            break;
        case 2:
            name = 'prawo';
            break;
        case 3:
            name = 'start';
            break;
        case 4:
            name = 'stop';
            break;
        default:
    }

    name = name + '_Karolina_' + nr + '.mat';
    alert('Wylosowany plik: ' + name);

    d3.json('/wizualizacja/fileMatch/' + name + '/',function(response) {
        distance = response.glob;
        for(var i in distance) {
            distance[i] = distance[i].toFixed(3);
        }
        bestFit = response.nazwa;
        d3.select("#identification-result p").html("Rozpoznana komenda: " + bestFit);
        genChart();
    });
};