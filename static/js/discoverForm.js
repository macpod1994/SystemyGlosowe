/**
 * Created by kalksever on 2016-11-30.
 */

'use strict';

var discoverForm = function () {
    d3.select('.plot-container').remove();
    d3.select("#identification-result p").html("");
    d3.select("#input-row").append('input').attr('type','file');
    d3.select("#file-button button").html("Testuj").attr('onclick','sendAndMatch()');
};