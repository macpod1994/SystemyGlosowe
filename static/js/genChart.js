/**
 * Created by kalksever on 2016-11-26.
 */
'use strict';

var d3 = Plotly.d3;

var genChart = function () {
    var trace1 = {
        x: [-10,10,0,0],
        y: [0, 0, 10, -10],
        text: ['lewo ' + distance[0], 'prawo ' + distance[1], 'start ' + distance[2], 'stop ' + distance[3]],
        mode: 'markers+text',
        marker: {
            color: ['rgb(93, 164, 214)', 'rgb(255, 144, 14)',  'rgb(44, 160, 101)', 'rgb(255, 65, 54)'],
            //size: [40, 60, 80, 100],
            size: [250/(1+distance[0]),250/(1+distance[1]),250/(1+distance[2]),250/(1+distance[3])],
        }
    };

    var data = [trace1];

    var layout = {
        title: 'Odległości od wzorców bazowych',
        showlegend: false,
        height: 600,
        width: '100%',
        xaxis: {
            autorange: true,
            showgrid: false,
            zeroline: false,
            showline: false,
            autotick: true,
            ticks: '',
            showticklabels: false
        },
        yaxis: {
            autorange: true,
            showgrid: false,
            zeroline: false,
            showline: false,
            autotick: true,
            ticks: '',
            showticklabels: false
        },
        paper_bgcolor: "rgb(229,229,229)",
        plot_bgcolor: "rgb(229,229,229)"
    };

    Plotly.newPlot('result-plot', data, layout, {staticPlot: true});

};
