# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
`$(function() {
	$.getJSON('stats/revenue_over_time', function(data) {
options = {
			chart : {
				renderTo : 'test',
        events: {
            redraw: function(){   // or load - refer to API documentation
		          window.revenue_over_time = new Highcharts.StockChart(window.revenue_over_time.options);
            }
        }
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
		}
		// Create the chart
		window.revenue_over_time = new Highcharts.StockChart(options);
	});
});`

`
$(function () {
	    $.getJSON('stats/category_revenue', function(data) {
       window.category_revenue = new Highcharts.Chart({
            chart: {
                renderTo: 'pie',
                plotBackgroundColor: null,
                plotBorderWidth: null,
                plotShadow: false,
                style: { height: '350px'},
                spacingRight: 450,
                events: {
                  redraw: function(){   // or load - refer to API documentation
		                window.category_revenue = new Highcharts.Chart(window.category_revenue.options);
                  }
             }
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
        window.user_revenue = new Highcharts.Chart({
            chart: {
                renderTo: 'bar',
                style: { height: '350px', width: '100%'},
                type: 'column',
                events: {
                  redraw: function(){   // or load - refer to API documentation
		                window.user_revenue = new Highcharts.Chart(window.user_revenue.options);
                  }
             }
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
                borderWidth: 1,
                backgroundColor: '#FFFFFF',
                shadow: true
            },
            credits: {
                enabled: false
            },
            series: data,
        });
    });
    });
`
$ ->
  $("#myTab a").click (e) ->
    e.preventDefault()
    $(this).tab "show"
    window.revenue_over_time.redraw();
    window.category_revenue.redraw();
    window.user_revenue.redraw();
