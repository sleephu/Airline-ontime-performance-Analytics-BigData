<%@page import="com.google.gson.JsonArray"%>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<%@ page language="java" import="org.json.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>
<%@ page import="show.Airport"%>
<!DOCTYPE html>
<html>
<head>
<meta name="description" content="">
<meta name="author" content="">
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="initial-scale=1.0, user-scalable=no">
<meta charset="utf-8">
<title>Airports Overview</title>
<link href="resources/defaultGoogle.css" rel="stylesheet">
<script
	src="https://maps.googleapis.com/maps/api/js?v=3.exp&sensor=false"></script>
<script type="text/javascript" src="http://d3js.org/d3.v3.min.js"></script>

<!-- Bootstrap Core CSS -->
<link href="startbootstrap/css/bootstrap.min.css" rel="stylesheet">

<!-- Custom CSS -->
<link href="startbootstrap/css/simple-sidebar.css" rel="stylesheet">
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script
	src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
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
				<li><a href="ViewPage?type=carrier">Airline Popularity</a></li>
				<li><a href="performanceInfo.jsp">Performance Information</a></li>
				<li><a href="airportDelay.jsp">Airport Average Delay</a></li>
				<li><a href="carrierDelay.jsp">Airline Performance</a></li>
				<li><a href="delayReason.jsp">Delay Reason Analysis</a></li>
				<li><a href="https://www.linkedin.com/in/jingyunhu">Contact</a></li>
			</ul>
		</div>
		<!-- /#sidebar-wrapper -->
		<%	String ac= request.getParameter("airport").toUpperCase(); %>
		<!-- Page Content -->
		<div id="page-content-wrapper">
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-12">
						<h1><%out.print(request.getParameter("airport").toUpperCase());%> Airport Information </h1>
						<div id="map"></div>
						<div id="my-table"></div>
						<a href="#menu-toggle" class="btn btn-default" id="menu-toggle">Toggle
							Menu</a>
					</div>
				</div>
			</div>
		</div>
		<!-- /#page-content-wrapper -->

	</div>
	<!-- /#wrapper -->
	<%
		String host = "ec2-52-26-94-107.us-west-2.compute.amazonaws.com";
		String className = "org.apache.phoenix.jdbc.PhoenixDriver";
		String connectionName = "jdbc:phoenix:" + host;
		Airport airport = null;
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
			// select * from CARRIERPOPULARITY WHERE YEAR = '2008' ORDER BY NUM
			// DESC LIMIT 3;
		//	sql = "select * from " + "AIRPORTS";
		//	sql = "select * from " + "AIRPORTS" + " where state = '" + stateInput + "' AND country = 'USA'";
			sql = "select * from " + "AIRPORTS" + " where airportCode = '"+ac+"'";
		//	sql = "select * from " + "AIRPORTS" + " where airportCode IN (SELECT airportCode from AIRPORTS WHERE STATE ='" + stateInput + "' AND country = 'USA')";
		    System.out.println("query:" + sql);
	%>

	<%
		ResultSet rs = stmt.executeQuery(sql);
			String airportCode, airportName, city, state, country, lat, lon;
			// Extract data from result set
			airport = new Airport();

			jsonArray = new JSONArray();

			while (rs.next()) {
				// Retrieve by column name
				jsonObject = new JSONObject();
				airportCode = rs.getString("airportCode");
				airport.setAirportCode(airportCode);
				jsonObject.put("airportCode", airport.getAirportCode());

				airportName = rs.getString("airportName");
				airport.setAirportName(airportName);
				jsonObject.put("airportName", airport.getAirportName());
				city = rs.getString("city");
				airport.setCity(city);
				jsonObject.put("city", airport.getCity());
				state = rs.getString("state");
				airport.setState(state);
				jsonObject.put("state", airport.getState());
				country = rs.getString("country");
				airport.setCountry(country);
				jsonObject.put("country", airport.getCountry());
				lat = rs.getString("lat");
				airport.setLat(lat);
				jsonObject.put("lat", airport.getLat());
				lon = rs.getString("lon");
				airport.setLon(lon);
				jsonObject.put("lon", airport.getLon());

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
	<!-- jQuery -->
	<script src="startbootstrap/js/jquery.js"></script>

	<!-- Bootstrap Core JavaScript -->
	<script src="startbootstrap/js/bootstrap.min.js"></script>
	<script>
	var dataset =
		<%out.print(js);%>
		var table, map, airportKey = "airportCode";

		function initialize() {
			var myLatlng = new google.maps.LatLng(38., -100.);
			var mapOptions = {
				zoom : 2,
				center : myLatlng,
				mapTypeId : google.maps.MapTypeId.TERRAIN
			}
			map = new google.maps.Map(document.getElementById('map'),
					mapOptions);

			// Create a table for the results -- First row has the column labels
			table = document.createElement("table");
			row = table.insertRow(0);
			row.insertCell(0).innerHTML = "airportCode";
			row.insertCell(1).innerHTML = "airportName";
			row.insertCell(2).innerHTML = "city";
			row.insertCell(3).innerHTML = "state";
			row.insertCell(4).innerHTML = "country";
			row.insertCell(5).innerHTML = "lat";
			row.insertCell(6).innerHTML = "long";
			document.getElementById("my-table").appendChild(table);

			addData();
		}

		google.maps.event.addDomListener(window, 'load', initialize);

		// Add the data

	var data = dataset;
		function addData() {

			data.forEach(function(d, i) {
				var row = table.insertRow(i + 1);
				row.insertCell(0).innerHTML = d.airportCode;
				row.insertCell(1).innerHTML = d["airportName"];
				row.insertCell(2).innerHTML = d["city"];
				row.insertCell(3).innerHTML = d["state"];
				row.insertCell(4).innerHTML = d["country"];
				row.insertCell(5).setAttribute("id", i + "lat");
				row.insertCell(6).setAttribute("id", i + "long");
			});

			// Geocode the locations
			data.forEach(function(d, i) {

				// WARNING: geocoding & table population occur asynchronously
			//	codeAddress(d[airportKey], d["airport"], i);
				codeAddress(d[airportKey], d["airport"], i);

			});

			// geocode the address and populate the table with lng & lat
			function codeAddress(locationString, nameString, i) {
				setTimeout(
						function() {

							var urlString = "http://maps.googleapis.com/maps/api/geocode/json?address=", sensorString = "&sensor=false", request = urlString
									+ escape(locationString) + sensorString;
							console
									.log("Trying..." + i + ", "
											+ locationString);

							if (locationString == "") {
								document.getElementById(i + "long").innerHTML = location.lng;
								document.getElementById(i + "lat").innerHTML = location.lat;
								console.log("Returning early");
								return;
							}
							;

							// Create an XHR object
							var xhr = new XMLHttpRequest();
							xhr.open("GET", request, true);

							// Register the XHR event handler -- NOTE: this must be added before xhr.send()
							xhr
									.addEventListener(
											'load',
											function() {
												if (xhr.status === 200) {
													var googleResponse = JSON
															.parse(xhr.response)
													if (googleResponse.status == "OK") {
														var location = JSON
																.parse(xhr.response).results[0].geometry.location;
														console
																.log(i
																		+ ", "
																		+ locationString
																		+ ", "
																		+ location.lat
																		+ ", "
																		+ location.lng);
														var latLng = new google.maps.LatLng(
																location.lat,
																location.lng);

														// Plot the location on the map
														//var img = "resources/airportIcon.png";
														var marker = new google.maps.Marker(
																{
																	position : latLng,
																	map : map,
																	//	icon: img,
																	title : nameString
																			+ ", "
																			+ locationString

																});

														// Add Lat & Lng to the table
														document
																.getElementById(i
																		+ "long").innerHTML = location.lng;
														document
																.getElementById(i
																		+ "lat").innerHTML = location.lat;

													} else {
														geocodeErrorCount += 1;
														console
																.log("ERROR locating "
																		+ locationString
																		+ "..."
																		+ googleResponse.status);
														console
																.log("Problematic request #"
																		+ geocodeErrorCount
																		+ ": "
																		+ request);
													}
													;
												} else {
													console
															.log("XHR Error for "
																	+ locationString
																	+ ": XHR status: "
																	+ status);
												}
												;
											}, false);

							// Send the XHR request
							xhr.send();
						}, i * 200);
			}
			;

		};
		  $("#menu-toggle").click(function(e) {
		        e.preventDefault();
		        $("#wrapper").toggleClass("toggled");
		    });
	</script>
</body>
</html>

