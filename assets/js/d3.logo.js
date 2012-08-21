addLoadEvent(function(){
var w = 400,
    h = 400,
    x = w/2,
    y = h/2,
    r = 100;

var svg = d3.select(".d3#logo")
        .append("svg")
        .attr("width", w)
        .attr("height", h)
        .append('g')
        .attr('transform', 'translate('+x+' '+y+')');

svg.append('circle')
        .attr('class', 'back')
        .attr('r', w/2);

var c = [
        {x: r, y: 0, r: r * 0.8},
        {x: 0, y: r*0.8, r: r*0.8},
        {x: -r, y: -r*0.4, r: r*0.3},
        {x: r, y: -r*0.4, r: r*0.3},
        {x: r, y: r*0.3, r: r*0.4},
        {x: -r, y: r*0.4, r: r*0.5},
        {x: -r*0.5, y: 0, r: r*0.1},
        {x: 0, y: 0, r: r}
    ];

svg.selectAll("circle.sphere")
    .data(c)
    .enter().append('circle')
    .attr('class', 'sphere')
    .attr("r", function(d, i){return d.r;})
    .attr("cx", function(d, i){return d.x;})
    .attr("cy", function(d, i){return d.y;})
    .classed('three', function(d, i){return (i>2 && i<5);});

var arc = d3.svg.arc()
    .innerRadius([r*0.4])
    .outerRadius([r*0.8]);

svg.append('path').attr("d", arc({startAngle: -0.2, endAngle:Math.PI + 0.2}, 0));
})
