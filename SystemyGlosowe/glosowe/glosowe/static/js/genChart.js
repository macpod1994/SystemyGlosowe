/**
 * Created by kalksever on 2016-11-26.
 */
'use strict';

var d3 = Plotly.d3;

var genChart = function () {
    var names = distance;
    for(var i in distance){
        if(distance[i]==10000)
            names[i] = "Inf";
    }
    var trace1 = {
        x: [-5,5,0,0],
        y: [0, 0, 5, -5],
        text: ['lewo ' + names[0], 'prawo ' + names[1], 'start ' + names[2], 'stop ' + names[3]],
        mode: 'markers+text',
        marker: {
            color: ['rgb(93, 164, 214)', 'rgb(255, 144, 14)',  'rgb(44, 160, 101)', 'rgb(255, 65, 54)'],
            size: [1400/(1+distance[0]),1400/(1+distance[1]),1400/(1+distance[2]),1400/(1+distance[3])],
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
