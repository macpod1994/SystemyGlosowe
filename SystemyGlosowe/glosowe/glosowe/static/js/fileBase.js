/**
 * Created by kalksever on 2016-12-03.
 */

'use strict';

var fileBase = function() {
    d3.select('.plot-container').remove();
    d3.select("#identification-result p").html("");
    d3.json('/wizualizacja/file_model/', function () {});
};