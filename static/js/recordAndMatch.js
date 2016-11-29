'use strict';

var distance = [0,1,2,3];
var bestFit = 'lewo';

var recordAndMatch = function() {
    d3.json('/record/',function(data) {
        //distance = data.glob;
        //bestFit = data.nazwa;
        d3.select("#identification-result p").html("Rozpoznana komenda: " + bestFit);
        genChart();
    });
};