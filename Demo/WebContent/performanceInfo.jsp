<%@page import="com.google.gson.JsonArray"%>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<%@ page language="java" import="org.json.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="show.Performance"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<title>Performance Information</title>
<link href="resources/style.css" rel="stylesheet">
</head>
<body>
<div id="body">

<a href="#"><img src="resources/logo.png" width="122" height="31"></a>

<h1>2008 On-Time Performance</h1>

<!-- <h2>Fast Multidimensional Filtering for Coordinated Views</h2> -->

<p>How does time-of-day correlate with 
<a href="javascript:filter([null, [100, 150], null, null])">arrival delay</a>
? <br> Are 
<a href="javascript:filter([null, null, [1700, 2000], null])">longer</a>
 or <a href="javascript:filter([null, null, [0, 300], null])">shorter</a>
  flights more likely to arrive early? <br>What happened on
   <a href="javascript:filter([null, [80, 150], null, [new Date(2008, 2, 21), new Date(2008, 2, 22)]])">March 21</a>? <br>How do flight patterns differ between
    <a href="javascript:filter([null, null, null, [new Date(2008, 0, 27), new Date(2008, 0, 29)]])">weekends</a> 
    and <a href="javascript:filter([null, null, null, [new Date(2008, 0, 29), new Date(2008, 1, 3)]])">weekdays</a>, or 
    <a href="javascript:filter([[4, 7], null, null, null])">mornings</a> and 
    <a href="javascript:filter([[21, 24], null, null, null])">nights</a>?

<div id="charts">
  <div id="hour-chart" class="chart">
    <div class="title">Time of Day</div>
  </div>
  <div id="delay-chart" class="chart">
    <div class="title">Arrival Delay (min.)</div>
  </div>
  <div id="distance-chart" class="chart">
    <div class="title">Distance (mi.)</div>
  </div>
  <div id="date-chart" class="chart">
    <div class="title">Date</div>
  </div>
</div>

<aside id="totals"><span id="active">-</span> of <span id="total">-</span> flights selected.</aside>

<div id="lists">
  <div id="flight-list" class="list"></div>
</div>

<footer>
<!--   <span style="float:right;">
    Released under the <a href="http://www.apache.org/licenses/LICENSE-2.0.html">Apache License 2.0</a>.
  </span> -->
 <!--  @Github <a href="https://github.com/sleephu">Jingyun Hu</a> -->
</footer>

</div>

<a href="index.jsp"><img style="position: absolute; top: 0; right: 0; border: 0; width="200"; height="50";" src="resources/backlogo.jpg" alt="Back"></a>
<%

String host = "ec2-52-26-94-107.us-west-2.compute.amazonaws.com";
String className = "org.apache.phoenix.jdbc.PhoenixDriver";
String connectionName = "jdbc:phoenix:" + host;
Performance p = null;
JSONArray jsonArray = null;
JSONObject jsonObject = null;
String js = null;
try {
	// Register JDBC driver
	Class.forName(className).newInstance();
	// Open a connection
	java.sql.Connection con = DriverManager.getConnection(connectionName);
	System.out.println("got connection");
	// Execute SQL query
	Statement stmt = con.createStatement();
	String sql;
	// select * from ONTIMEPERFORMANCE2008 
	//  LIMIT 3;
	sql = "select * from " + "ONTIMEPERFORMANCE2008SP";
	System.out.println("query:" + sql);

%>
<%
		ResultSet rs = stmt.executeQuery(sql);
			String date, delay, distance, origin, destination;
			// Extract data from result set
			p = new Performance();
			List<Performance> selected = new ArrayList<Performance>();
			jsonArray = new JSONArray();
			
			while (rs.next()) {
				// Retrieve by column name
				jsonObject = new JSONObject();
				//date
				date = rs.getString("FLIGHTDATE");
				p.setFlightDate(date);
				jsonObject.put("date",p.getFlightDate());
				//delay
				delay = rs.getString("DELAY");
				p.setDelay(delay);
				jsonObject.put("delay", p.getDelay());
				//distance
				distance = rs.getString("DISTANCE");
				p.setDistance(distance);
				jsonObject.put("distance",p.getDistance());
				//origin
				origin = rs.getString("ORIGIN");
				p.setOrigin(origin);
				jsonObject.put("origin", p.getOrigin());
				//destination
				destination = rs.getString("DESTINATION");
				p.setDestination(destination);
				jsonObject.put("destination", p.getDestination());

				// Display values
				selected.add(p);
				jsonArray.put(jsonObject);

			}

			js = jsonArray.toString();
			System.out.println("js:" + js);
			// Clean-up environment
			rs.close();
			stmt.close();
			con.close();

		} catch (Exception e) {
			System.out.println("Error:" + e.getMessage());
			e.printStackTrace();
		}
	%>

<script src="resources/crossfilter.v1.min.js"></script>
<script src="resources/d3.v3.min.js"></script>   
<script>
var dataset = <%out.print(js);%>;
// (It's CSV, but GitHub Pages only gzip's JSON at the moment.)
//dataset
var flights = dataset;
  // Various formatters.
  var formatNumber = d3.format(",d"),
      formatChange = d3.format("+,d"),
      formatDate = d3.time.format("%B %d, %Y"),
      formatTime = d3.time.format("%I:%M %p");

  // A nest operator, for grouping the flight list.
  var nestByDate = d3.nest()
      .key(function(d) { return d3.time.day(d.date); });
  
  // A little coercion, since the CSV is untyped.
   flights.forEach(function(d,i) {
    d.index = i;
    d.date = parseDate(d.date);
    d.delay = +d.delay;
    d.distance = +d.distance;
  }); 
  /* flights.date = flights.map(function(d) {return parseDate(d.date);});
  flights.delay = flights.map(function(d) { return +d.delay; });
  flights.distance = flights.map(function(d) {return +d.distance;}); */ 
  // Create the crossfilter for the relevant dimensions and groups.
  var flight = crossfilter(dataset),
      all = flight.groupAll(),
      date = flight.dimension(function(d) { return d.date; }),
      dates = date.group(d3.time.day),
      hour = flight.dimension(function(d) { return d.date.getHours() + d.date.getMinutes() / 60; }),
      hours = hour.group(Math.floor),
      delay = flight.dimension(function(d) { return Math.max(-60, Math.min(149, d.delay)); }),
      delays = delay.group(function(d) { return Math.floor(d / 10) * 10; }),
      distance = flight.dimension(function(d) { return Math.min(1999, d.distance); }),
      distances = distance.group(function(d) { return Math.floor(d / 50) * 50; });

  var charts = [

    barChart()
        .dimension(hour)
        .group(hours)
      .x(d3.scale.linear()
        .domain([0, 24])
        .rangeRound([0, 10 * 24])),

    barChart()
        .dimension(delay)
        .group(delays)
      .x(d3.scale.linear()
        .domain([-60, 150])
        .rangeRound([0, 10 * 21])),

    barChart()
        .dimension(distance)
        .group(distances)
      .x(d3.scale.linear()
        .domain([0, 2000])
        .rangeRound([0, 10 * 40])),

    barChart()
        .dimension(date)
        .group(dates)
        .round(d3.time.day.round)
      .x(d3.time.scale()
        .domain([new Date(2008, 0, 1), new Date(2008, 3, 1)])
        .rangeRound([0, 10 * 90]))
        .filter([new Date(2008, 1, 1), new Date(2008, 2, 1)])

  ];

  // Given our array of charts, which we assume are in the same order as the
  // .chart elements in the DOM, bind the charts to the DOM and render them.
  // We also listen to the chart's brush events to update the display.
  var chart = d3.selectAll(".chart")
      .data(charts)
      .each(function(chart) { chart.on("brush", renderAll).on("brushend", renderAll); });

  // Render the initial lists.
  var list = d3.selectAll(".list")
      .data([flightList]);

  // Render the total.
  d3.selectAll("#total")
      .text(formatNumber(flight.size()));

  renderAll();

  // Renders the specified chart or list.
  function render(method) {
    d3.select(this).call(method);
  }

  // Whenever the brush moves, re-rendering everything.
  function renderAll() {
    chart.each(render);
    list.each(render);
    d3.select("#active").text(formatNumber(all.value()));
  }

  // Like d3.time.format, but faster.
  function parseDate(d) {
    return new Date(2008,
        d.substring(0, 2) - 1,
        d.substring(2, 4),
        d.substring(4, 6),
        d.substring(6, 8));
  }

  window.filter = function(filters) {
    filters.forEach(function(d, i) { charts[i].filter(d); });
    renderAll();
  };

  window.reset = function(i) {
    charts[i].filter(null);
    renderAll();
  };

  function flightList(div) {
    var flightsByDate = nestByDate.entries(date.top(40));

    div.each(function() {
      var date = d3.select(this).selectAll(".date")
          .data(flightsByDate, function(d) { return d.key; });

      date.enter().append("div")
          .attr("class", "date")
        .append("div")
          .attr("class", "day")
          .text(function(d) { return formatDate(d.values[0].date); });

      date.exit().remove();

      var flight = date.order().selectAll(".flight")
          .data(function(d) { return d.values; }, function(d) { return d.index; });

      var flightEnter = flight.enter().append("div")
          .attr("class", "flight");

      flightEnter.append("div")
          .attr("class", "time")
          .text(function(d) { return formatTime(d.date); });

      flightEnter.append("div")
          .attr("class", "origin")
          .text(function(d) { return d.origin; });

      flightEnter.append("div")
          .attr("class", "destination")
          .text(function(d) { return d.destination; });

      flightEnter.append("div")
          .attr("class", "distance")
          .text(function(d) { return formatNumber(d.distance) + " mi."; });

      flightEnter.append("div")
          .attr("class", "delay")
          .classed("early", function(d) { return d.delay < 0; })
          .text(function(d) { return formatChange(d.delay) + " min."; });

      flight.exit().remove();

      flight.order();
    });
  }

  function barChart() {
    if (!barChart.id) barChart.id = 0;

    var margin = {top: 10, right: 10, bottom: 20, left: 10},
        x,
        y = d3.scale.linear().range([100, 0]),
        id = barChart.id++,
        axis = d3.svg.axis().orient("bottom"),
        brush = d3.svg.brush(),
        brushDirty,
        dimension,
        group,
        round;

    function chart(div) {
      var width = x.range()[1],
          height = y.range()[0];

      y.domain([0, group.top(1)[0].value]);

      div.each(function() {
        var div = d3.select(this),
            g = div.select("g");

        // Create the skeletal chart.
        if (g.empty()) {
          div.select(".title").append("a")
              .attr("href", "javascript:reset(" + id + ")")
              .attr("class", "reset")
              .text("reset")
              .style("display", "none");

          g = div.append("svg")
              .attr("width", width + margin.left + margin.right)
              .attr("height", height + margin.top + margin.bottom)
            .append("g")
              .attr("transform", "translate(" + margin.left + "," + margin.top + ")");

          g.append("clipPath")
              .attr("id", "clip-" + id)
            .append("rect")
              .attr("width", width)
              .attr("height", height);

          g.selectAll(".bar")
              .data(["background", "foreground"])
            .enter().append("path")
              .attr("class", function(d) { return d + " bar"; })
              .datum(group.all());

          g.selectAll(".foreground.bar")
              .attr("clip-path", "url(#clip-" + id + ")");

          g.append("g")
              .attr("class", "axis")
              .attr("transform", "translate(0," + height + ")")
              .call(axis);

          // Initialize the brush component with pretty resize handles.
          var gBrush = g.append("g").attr("class", "brush").call(brush);
          gBrush.selectAll("rect").attr("height", height);
          gBrush.selectAll(".resize").append("path").attr("d", resizePath);
        }

        // Only redraw the brush if set externally.
        if (brushDirty) {
          brushDirty = false;
          g.selectAll(".brush").call(brush);
          div.select(".title a").style("display", brush.empty() ? "none" : null);
          if (brush.empty()) {
            g.selectAll("#clip-" + id + " rect")
                .attr("x", 0)
                .attr("width", width);
          } else {
            var extent = brush.extent();
            g.selectAll("#clip-" + id + " rect")
                .attr("x", x(extent[0]))
                .attr("width", x(extent[1]) - x(extent[0]));
          }
        }

        g.selectAll(".bar").attr("d", barPath);
      });

      function barPath(groups) {
        var path = [],
            i = -1,
            n = groups.length,
            d;
        while (++i < n) {
          d = groups[i];
          path.push("M", x(d.key), ",", height, "V", y(d.value), "h9V", height);
        }
        return path.join("");
      }

      function resizePath(d) {
        var e = +(d == "e"),
            x = e ? 1 : -1,
            y = height / 3;
        return "M" + (.5 * x) + "," + y
            + "A6,6 0 0 " + e + " " + (6.5 * x) + "," + (y + 6)
            + "V" + (2 * y - 6)
            + "A6,6 0 0 " + e + " " + (.5 * x) + "," + (2 * y)
            + "Z"
            + "M" + (2.5 * x) + "," + (y + 8)
            + "V" + (2 * y - 8)
            + "M" + (4.5 * x) + "," + (y + 8)
            + "V" + (2 * y - 8);
      }
    }

    brush.on("brushstart.chart", function() {
      var div = d3.select(this.parentNode.parentNode.parentNode);
      div.select(".title a").style("display", null);
    });

    brush.on("brush.chart", function() {
      var g = d3.select(this.parentNode),
          extent = brush.extent();
      if (round) g.select(".brush")
          .call(brush.extent(extent = extent.map(round)))
        .selectAll(".resize")
          .style("display", null);
      g.select("#clip-" + id + " rect")
          .attr("x", x(extent[0]))
          .attr("width", x(extent[1]) - x(extent[0]));
      dimension.filterRange(extent);
    });

    brush.on("brushend.chart", function() {
      if (brush.empty()) {
        var div = d3.select(this.parentNode.parentNode.parentNode);
        div.select(".title a").style("display", "none");
        div.select("#clip-" + id + " rect").attr("x", null).attr("width", "100%");
        dimension.filterAll();
      }
    });

    chart.margin = function(_) {
      if (!arguments.length) return margin;
      margin = _;
      return chart;
    };

    chart.x = function(_) {
      if (!arguments.length) return x;
      x = _;
      axis.scale(x);
      brush.x(x);
      return chart;
    };

    chart.y = function(_) {
      if (!arguments.length) return y;
      y = _;
      return chart;
    };

    chart.dimension = function(_) {
      if (!arguments.length) return dimension;
      dimension = _;
      return chart;
    };

    chart.filter = function(_) {
      if (_) {
        brush.extent(_);
        dimension.filterRange(_);
      } else {
        brush.clear();
        dimension.filterAll();
      }
      brushDirty = true;
      return chart;
    };

    chart.group = function(_) {
      if (!arguments.length) return group;
      group = _;
      return chart;
    };

    chart.round = function(_) {
      if (!arguments.length) return round;
      round = _;
      return chart;
    };

    return d3.rebind(chart, brush, "on");
  }
/* d3.json("resources/flights-3m.json", function(error,flights) {

}); */

</script>
</body>
</html>
