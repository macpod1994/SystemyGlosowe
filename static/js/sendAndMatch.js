/**
 * Created by kalksever on 2016-11-30.
 */

'use strict';

var sendAndMatch = function () {
    var file = d3.select("#input-row input")[0][0].files[0];
    d3.select("#input-row input").remove();
    d3.select("#file-button button").html("Rozpoznaj gotowy plik");
    console.log(JSON.stringify(file));
    d3.request('/fileMatch/').post(JSON.stringify(file),function(data) {
        //distance = data.glob;
        //bestFit = data.nazwa;
        d3.select("#identification-result p").html("Rozpoznana komenda: " + bestFit);
        genChart();
    });
};