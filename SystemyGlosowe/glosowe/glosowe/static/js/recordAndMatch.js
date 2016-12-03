'use strict';

var distance = [0,1,2,3];
var bestFit = 'lewo';

var recordAndMatch = function() {
    d3.select("#input-row input").remove();
    d3.select("#file-button button").html("Rozpoznaj gotowy plik");
    d3.json('/wizualizacja/record/',function(data) {
        //distance = data.glob;
        //bestFit = data.nazwa;
        d3.select("#identification-result p").html("Rozpoznana komenda: " + bestFit);
        genChart();
    });
};