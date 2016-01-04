<%@page import="com.google.gson.JsonArray"%>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<%@ page language="java" import="org.json.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%@ page import="show.CarrierPop"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
<script src="http://code.jquery.com/jquery-1.8.2.min.js"></script>
<script src="http://cdn.oesmith.co.uk/morris-0.4.1.min.js"></script>
<script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Demo</title>
<style>
.bar {
	fill: #5cb85c;
}

.bar:hover {
	fill: green;
}

.barText {
	fill: white;
	font: 10px sans-serif;
	/*text-anchor: end;*/
}

svg {
	border: 1px solid black;
}

.axis {
	font: 10px sans-serif;
}

.axis path, .axis line {
	fill: none;
	stroke: #000;
	shape-rendering: crispEdges;
}

.y.axis path {
	display: none;
}

div.tooltip {
	position: absolute;
	top: 70px;
	left: 100px;
	-moz-border-radius: 5px;
	border-radius: 5px;
	border: 2px solid green;
	background: #fff;
	color: black;
	padding: 10px;
	width: 250px;
	font-size: 12px;
	z-index: 10;
	word-wrap: break-word;
}

.tooltip .title {
	font-size: 13px;
}

.tooltip .name {
	font-weight: bold;
}

.tooltip .value {
	/*font-weight: bold;*/
	
}
</style>
<link href="startbootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom CSS -->
<link href="startbootstrap/css/simple-sidebar.css" rel="stylesheet">

<!-- HTML5 Shim and Respond.js IE8 support of HTML5 elements and media queries -->
<!-- WARNING: Respond.js doesn't work if you view the page via file:// -->
<!--[if lt IE 9]>
        <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
        <script src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
    <![endif]-->
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script
	src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
<script type="text/javascript" src="http://d3js.org/d3.v3.min.js"></script>
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
<script src="http://code.jquery.com/jquery-1.8.2.min.js"></script>
<script src="http://cdn.oesmith.co.uk/morris-0.4.1.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script>
</head>
<body>
	<div id="wrapper">

		<!-- Sidebar -->
				<div id="sidebar-wrapper">
			<ul class="sidebar-nav">
				<li class="sidebar-brand">
				<a href="airport.jsp">Airports Overview</a>
				</li>
					<li><a href="ViewPage?type=airport">Airport Information </a></li>
				<li><a href="ViewPage?type=carrier">Carrier Popularity</a></li>
				<li><a href="performanceInfo.jsp">Performance Information</a></li>
				<li><a href="airportDelay.jsp">Airport Average Delay</a></li>
				<li><a href="carrierDelay.jsp">Airline Performance</a></li>
				<li><a href="delayReason.jsp">Delay Reason Analysis</a></li>
				<li><a href="https://www.linkedin.com/in/jingyunhu">Contact</a></li>
			</ul>
		</div>




		<!-- Page Content -->
		<div id="page-content-wrapper">
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-12">
						<!-- 	<h1></h1> -->
						<%
							String errorY = request.getParameter("errorY");
							if (errorY != null) {
						%>
						<p>{errorY}</p>
						<%
							}
							String topN = request.getParameter("topN");
							String yearInput = request.getParameter("yearInput");
							String host = "ec2-52-26-94-107.us-west-2.compute.amazonaws.com";
							String className1 = "org.apache.phoenix.jdbc.PhoenixDriver";
							String connectionName1 = "jdbc:phoenix:" + host;
							CarrierPop cp1 = null;
							JSONArray jsonArray1 = null;
							JSONObject jsonObject1 = null;
							String js1 = null;
							StringBuilder sbcarrier = null;
							String carrier = null;
							boolean showhive = false;
							//hive configuration
							/*  String className_hive = "org.apache.hive.jdbc.HiveDriver";
							String connectionName_hive = "jdbc:hive2://" + host+ ":10000/default";
							JSONArray jsonArray_hive = null;
							JSONObject jsonObject_hive = null;
							CarrierPop cp_hive = null;
							String js_hive = null;  */
							try {
								// Register JDBC driver
								Class.forName(className1).newInstance();
								// Open a connection
								java.sql.Connection con1 = DriverManager.getConnection(connectionName1);
								System.out.println("got connection");
								// Execute SQL query
								Statement stmt1 = con1.createStatement();
								String sql1;
								// select * from CARRIERPOPULARITY WHERE YEAR = '2008' ORDER BY NUM
								// DESC LIMIT 3;
								sql1 = "select * from " + "CARRIERPOPULARITY WHERE YEAR = " + "'" + yearInput + "'"
										+ " ORDER BY NUM DESC LIMIT " + topN;
								System.out.println("query1:" + sql1);
						%>
						<h2>${yearInput} Top ${topN} Airlines</h2>
						<%
							ResultSet rs1 = stmt1.executeQuery(sql1);
								String year, carrie, num;
								// Extract data from result set
								cp1 = new CarrierPop();
								List<CarrierPop> selected = new ArrayList<CarrierPop>();
								jsonArray1 = new JSONArray();
								sbcarrier = new StringBuilder();
								while (rs1.next()) {
									// Retrieve by column name
									jsonObject1 = new JSONObject();
									year = rs1.getString("YEAR");
									cp1.setYear(year);
									carrie = rs1.getString("CARRIER");
									cp1.setCarrier(carrie);
									sbcarrier.append("'").append(cp1.getCarrier()).append("'").append(",");
									jsonObject1.put("carrier", cp1.getCarrier());
									num = rs1.getString("NUM");
									cp1.setNum(num);
									jsonObject1.put("num", cp1.getNum());
									// Display values
									selected.add(cp1);
									jsonArray1.put(jsonObject1);

								}
								js1 = jsonArray1.toString();
								System.out.println("js:" + js1);
								sbcarrier = sbcarrier.deleteCharAt(sbcarrier.length() - 1);
								System.out.println("sbcarrier" + sbcarrier.toString());
								carrier = sbcarrier.toString();
								System.out.println("carrier" + carrier);

								// Clean-up environment
								rs1.close();
								stmt1.close();
								con1.close();

							} catch (Exception e) {
								System.out.println("Error:" + e.getMessage());
								e.printStackTrace();
							}
							if (carrier != null && carrier.length() > 0) {
								session.setAttribute("carrier", carrier);

							}
						%>

						<%
							String className = "org.apache.hive.jdbc.HiveDriver";
							String connectionName = "jdbc:hive2://" + host + ":10000/default";
							CarrierPop cp = null;
							JSONArray jsonArray = null;
							JSONObject jsonObject = null;
							String js = null;
							/* 	String carriersTitle = carrier.replace("'", ""); */
							//	System.out.println("carrierTitle:"+carriersTitle);
							//		String carrier = (String)session.getAttribute("carrier");

							try {
								// Register JDBC driver
								Class.forName(className).newInstance();
								// Open a connection
								Connection con = DriverManager.getConnection(connectionName, "hive", "");
								System.out.println("got connection");
								// Execute SQL query
								Statement stmt = con.createStatement();
								String sql;
								// select * from CARRIERPOPULARITY WHERE YEAR = '2008' ORDER BY NUM
								// DESC LIMIT 3;
								sql = "select d.airlineCode,d.delayAvg,c.description from hbase_carriers c, average_arrival_delay_airline d where c.carrierCode = d.airlineCode AND d.airlineCode IN"
										+ " (" + carrier + ")";
								System.out.println("query:" + sql);
						%>
						<%-- <h2><%out.print(carriersTitle);%> Average Delay</h2> --%>
						<%
							ResultSet rs = stmt.executeQuery(sql);
								String carrierCode, description, delayAvg;
								// Extract data from result set
								cp = new CarrierPop();
								jsonArray = new JSONArray();

								while (rs.next()) {
									// Retrieve by column name
									jsonObject = new JSONObject();
									carrierCode = rs.getString("airlineCode");
									cp.setCarrier(carrierCode);
									jsonObject.put("carrierCode", cp.getCarrier());

									description = rs.getString("description");
									cp.setDescription(description);
									jsonObject.put("description", cp.getDescription());

									delayAvg = rs.getString("delayAvg");
									cp.setDelay(delayAvg);
									jsonObject.put("delayAvg", cp.getDelay());

									// Display values
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
						<!-- <svg id="chart" class="chart"></svg> -->
						<!-- <div id="chart" class="bar"></div> -->
						 <div class="chart"></div>
						  <h5>Average Delay Information</h5>
						<div id="bar-example"></div>
						
						<a href="#menu-toggle" class="btn btn-default" id="menu-toggle">Toggle
							Menu</a>

					</div>
				</div>
			</div>
		</div>
		<!-- /#page-content-wrapper -->

	</div>
	<!-- /#wrapper -->
	<!-- jQuery -->
	<script src="startbootstrap/js/jquery.js"></script>

	<!-- Bootstrap Core JavaScript -->
	<script src="startbootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript">
		var dataset =
	<%out.print(js1);%>
		;

		$("#menu-toggle").click(function(e) {
			e.preventDefault();
			$("#wrapper").toggleClass("toggled");
		});

		//	d3.select("body").append("span").text("Hello, world!");	
		var hivedataset =
	<%out.print(js);%>
		;
		Morris.Bar({
			element : 'bar-example',
			data : hivedataset,
			xkey : 'carrierCode',
			ykeys : [ 'delayAvg' ],
			labels : [ 'Average Delay (min)' ]
		});
		//flights
		function fnMakeD3barChart(data) {
			var margin = {
				top : 20,
				right : 20,
				bottom : 30,
				left : 70
			}, width = 400 - margin.left - margin.right, height = 200
					- margin.top - margin.bottom;

			var x = d3.scale.linear().domain([ 0, d3.max(data, function(d) {
				return d.num;
			}) ]).range([ 0, width ]);

			var y = d3.scale.ordinal().domain(data.map(function(d) {
				return d.carrier;
			})).rangeRoundBands([ 0, height ], .1);

			var xAxis = d3.svg.axis().scale(x).orient("bottom").ticks(5);

			var yAxis = d3.svg.axis().scale(y).orient("left");

			var svg = d3.select(".chart").append("svg").attr("width",
					width + margin.left + margin.right).attr("height",
					height + margin.top + margin.bottom).append("g").attr(
					"transform",
					"translate(" + margin.left + "," + margin.top + ")");

			var bars = svg.selectAll("g").data(data).enter().append("g").attr(
					"transform", function(d, i) {
						return "translate(" + x(0) + "," + y(d.carrier) + ")";
					});

			bars.append("rect").attr("class", "bar").attr("width", function(d) {
				return x(d.num);
			}).attr("height", y.rangeBand());
			/*
			  var bars = svg.selectAll(".bar")
			    .data(data)
			    .enter()
			    .append("rect")
			    .attr("class", "bar")
			    .attr("x", x(0))
			    .attr("width", function(d) {
			      return x(d.value);
			    })
			    .attr("y", function(d) {
			      return y(d.name);
			    })
			    .attr("height", y.rangeBand());
			 */
			svg.append("g").attr("class", "y axis").call(yAxis);

			svg.append("g").attr("class", "x axis").attr("transform",
					"translate(0," + height + ")").call(xAxis);

			var divTTip = d3.select("body").append("div").attr("class",
					"tooltip").style("opacity", 0);

			bars.on(
					"mousemove",
					function(d) {
						divTTip.transition().duration(100)
								.style("opacity", .95).style("left",
										(d3.event.pageX + 10) + "px").style(
										"top", (d3.event.pageY + 10) + "px")
						//.style("font-color", "white");

						var string = "<span class=\"name\">" + d.carrier
								+ "&nbsp;:&nbsp;</span><span class=\"value\"> "
								+ d.num + "</span>";
						divTTip.html(string)

					}).on("mouseout", function(d) { // when the mouse leaves a circle, do the following
				divTTip.transition().duration(200).style("opacity", 0);
			});
		}
		fnMakeD3barChart(dataset);
		/* d3.select("body") // Selecting the body tag
		 .append("h1") 
		 .text("Airline Flights" + ":")
		 ; 
		 var margin = {
		 top : 20,
		 right : 60,
		 bottom : 30,
		 left : 40
		 }, width = 960 - margin.left - margin.right, height = 500 - margin.top
		 - margin.bottom;	
		 var chart = d3.selectAll("#chart").attr("width",
		 width + margin.left + margin.right).attr("height",
		 height + margin.top + margin.bottom).append("g").attr(
		 "transform",
		 "translate(" + margin.left + "," + margin.top + ")");
		 d3.selectAll(".bar")
		 .data(dataset) 
		 .enter().append("rect").attr(
		 "class", "bar")
		 .append("div") 
		 .transition()
		 .duration(2000) 
		 .style("width", function(d) { return d.num/100000 * 75 + "px"; }) 
		 .each("end", function(d) { 
		 d3.select(this)
		 .append("span")
		 .text(d.carrier + ": " + d.num) 
		 .transition()
		 .style("opacity", 1); 
		 }); */

		/* 		var chart = document.getElementById("chart"), axisMargin = 20, margin = 20, valueMargin = 4, width = chart.offsetWidth, height = chart.offsetHeight, barHeight = (height
		 - axisMargin - margin * 2)
		 * 0.4 / dataset.length, barPadding = (height - axisMargin - margin * 2)
		 * 0.6 / dataset.length, data, bar, svg, scale, xAxis, labelWidth = 0;

		 max = d3.max(dataset.map(function(d) {
		 return d.num;
		 }));

		 svg = d3.select(chart).append("svg").attr("width", width).attr(
		 "height", 400);

		 bar = svg.selectAll("g").data(dataset).enter().append("g");

		 bar
		 .attr("class", "bar")
		 .attr("cx", 0)
		 .attr(
		 "transform",
		 function(d, i) {
		 return "translate("
		 + margin
		 + ","
		 + (i * (barHeight + barPadding) + barPadding)
		 + ")";
		 });

		 bar.append("text").attr("class", "label").attr("y", barHeight / 2)
		 .attr("dy", ".35em") //vertical align middle
		 .text(function(d) {
		 return d.carrier;
		 }).each(
		 function() {
		 labelWidth = Math.ceil(Math.max(labelWidth, this
		 .getBBox().width));
		 });

		 scale = d3.scale.linear().domain([ 0, max ]).range(
		 [ 0, width - margin * 2 - labelWidth ]);

		 xAxis = d3.svg.axis().scale(scale).tickSize(
		 -height + 2 * margin + axisMargin).orient("bottom");

		 bar.append("rect")
		 .attr("transform", "translate(" + labelWidth + ", 0)").attr(
		 "height", barHeight).attr("width", function(d) {
		 return scale(d.num);
		 });

		 bar.append("text").attr("class", "value").attr("y", barHeight / 2)
		 .attr("dx", -valueMargin + labelWidth) //margin right
		 .attr("dy", ".35em") //vertical align middle
		 .attr("text-anchor", "end").text(function(d) {
		 return d[1];
		 }).attr("x", function(d) {
		 var width = this.getBBox().width;
		 return Math.max(width + valueMargin, scale(d[1]));
		 });

		 svg.insert("g", ":first-child").attr("class", "axis").attr(
		 "transform",
		 "translate(" + (margin + labelWidth) + ","
		 + (height - axisMargin - margin) + ")").call(xAxis); */
	</script>
</body>
</html>