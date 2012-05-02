# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
`$(function() {
	$.getJSON('stats/revenue_over_time', function(data) {

		// Create the chart
		window.chart = new Highcharts.StockChart({
			chart : {
				renderTo : 'test'
			},

			rangeSelector : {
				selected : 1,
        inputEnabled: false
			},

			title : {
				text : 'Revenue Over Time'
			},

			series : [{
				name : 'Revenue Over Time',
				data : data,
				type : 'area',
				threshold : null,
				tooltip : {
					valueDecimals : 2
				},

				fillColor : {
					linearGradient : {
						x1: 0, 
						y1: 0, 
						x2: 0, 
						y2: 1
					},
					stops : [[0, Highcharts.getOptions().colors[0]], [1, 'rgba(0,0,0,0)']]
				}
			}]
		});
	});
});`

`
$(function () {
	    $.getJSON('stats/category_revenue', function(data) {
       window.chart = new Highcharts.Chart({
            chart: {
                renderTo: 'pie',
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false
            },
            title: {
                text: 'Revenue by Category'
            },
            tooltip: {
                formatter: function() {
                    return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage, 2) +' %';
                }
            },
            plotOptions: {
                pie: {
                    allowPointSelect: true,
                    cursor: 'pointer',
                    dataLabels: {
                        enabled: true,
                        color: '#000000',
                        connectorColor: '#000000',
                        formatter: function() {
                            return '<b>'+ this.point.name +'</b>: '+ Math.round(this.percentage, 3) +' %';
                        }
                    }
                }
            },
            series: [{
                type: 'pie',
                name: 'Browser share',
                data: data
            }]
        });
    });
    
});
`
`
$(function () {
	    $.getJSON('stats/top_ten_user_revenue', function(data) {
        window.chart = new Highcharts.Chart({
            chart: {
                renderTo: 'bar',
                type: 'column'
            },
            title: {
                text: 'Top 10 Users by Spending'
            },
            xAxis: {
                categories: ['Users'],
                title: {
                    text: null
                }
            },
            yAxis: {
                min: 0,
                title: {
                    text: 'Spending',
                    align: 'middle'
                }
            },
            tooltip: {
                formatter: function() {
                    return ''+
                        this.series.name +': $'+ this.y;
                }
            },
            plotOptions: {
                bar: {
                    dataLabels: {
                        enabled: true
                    }
                }
            },
            legend: {
                layout: 'vertical',
                align: 'right',
                verticalAlign: 'top',
                x: -100,
                y: 100,
                floating: true,
                borderWidth: 1,
                backgroundColor: '#FFFFFF',
                shadow: true
            },
            credits: {
                enabled: false
            },
            series: data 
        });
    });
    });
`
$ ->
  $("#myTab a").click (e) ->
    e.preventDefault()
    $(this).tab "show"
