<%@page import="com.google.gson.JsonArray"%>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<%@ page language="java" import="org.json.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%-- <%@ page import="show.ReasonAnalysis"%>  --%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Demo</title>
<style>
#chartdiv { margin: -.5em auto; text-align:center; width: 90%; height: 390px; font-size:11 px}
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
<!-- <script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script
	src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
<script type="text/javascript" src="http://d3js.org/d3.v3.min.js"></script>
<script
	src="http://cdnjs.cloudflare.com/ajax/libs/raphael/2.1.0/raphael-min.js"></script>
<script src="http://code.jquery.com/jquery-1.8.2.min.js"></script>
<script src="http://cdn.oesmith.co.uk/morris-0.4.1.min.js"></script>
<script src="//code.jquery.com/jquery-1.11.3.min.js"></script>
<script src="//code.jquery.com/jquery-migrate-1.2.1.min.js"></script> -->
<script src="resources/amcharts/amcharts.js"></script>
<script src="http://www.amcharts.com/lib/3/pie.js"></script>
<script src="http://www.amcharts.com/lib/3/themes/light.js"></script>

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

		<!-- Page Content -->
		<div id="page-content-wrapper">
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-12">
						<%
							String host = "ec2-52-26-94-107.us-west-2.compute.amazonaws.com";
							String className = "org.apache.hive.jdbc.HiveDriver";
							String connectionName = "jdbc:hive2://" + host + ":10000/default";
				//			AirlinePerformance cp = null;
				//			List<AirlinePerformance> cps = null;
							HashMap<String, String> map = null;
						//	ReasonAnalysis r  = null;
							JSONArray jsonArray = null;
							JSONObject jsonObject = null;
							JSONArray jsonArray_weather = null;
							JSONArray jsonArray_security = null;
							JSONArray jsonArray_nas = null;
							JSONArray jsonArray_carrier = null;
							JSONArray jsonArray_la = null;
							JSONObject jsonObject_weather = null;
							JSONObject jsonObject_security = null;
							JSONObject jsonObject_nas = null;
							JSONObject jsonObject_carrier = null;
							JSONObject jsonObject_la = null;
						//	JSONObject jsonObject_test = null;
							String js = null;
						//	StringBuilder jsarray = null;
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
								sql = "select count(if(nasDelay > 15, \"\", NULL)) / count(*) as nasDelay_pcent, count(if(carrierDelay > 15, \"\", NULL)) / count(*) as carrierDelay_pcent, count(if(weatherDelay > 15, \"\", NULL)) / count(*) as weatherDelay_pcent, count(if(securityDelay > 15, \"\", NULL)) / count(*) as securityDelay_pcent, count(if(lateAircraftDelay > 15, \"\", NULL)) / count(*) as lateAircraftDelay_pcent from Performance_2008";
								System.out.println("query:" + sql);
						%>
						<h2>Delay Reason Analysis</h2>
						<%
							ResultSet rs = stmt.executeQuery(sql);
								String nasDelay, carrierDelay, weatherDelay, securityDelay,lateAircraftDelay;
								// Extract data from result set
						//		cp = new AirlinePerformance();
						//		r = new ReasonAnalysis();
								jsonArray = new JSONArray();
								jsonArray_nas = new JSONArray();
								jsonArray_weather = new JSONArray();
								jsonArray_carrier = new JSONArray();
								jsonArray_security = new JSONArray();
								jsonArray_la = new JSONArray();
								
								//	jsonArray_test = new JSONArray();
								//	String data = null;
						//		cps = new ArrayList<AirlinePerformance>();
								map = new HashMap<String, String>();
								while (rs.next()) {
									// Retrieve by column name
									jsonObject = new JSONObject();
								 jsonObject_weather = new JSONObject();
									 jsonObject_security = new JSONObject();
									 jsonObject_nas = new JSONObject();
									 jsonObject_carrier = new JSONObject();
									 jsonObject_la = new JSONObject();
							//		jsarray = new StringBuilder();
									//year
									nasDelay = rs.getString("nasDelay_pcent");
						//			r.setType("NAS Delay");
								//	cp.setYear(year);
									jsonObject_nas.put("label","NAS Delay");
									jsonObject_nas.put("value",nasDelay);
								//	jsonArray.put(jsonObject_nas);
									//carrierCode
									carrierDelay = rs.getString("carrierDelay_pcent");
								//	cp.setCarrierCode(carrier);
									jsonObject_carrier.put("label","Carrier Delay");
									jsonObject_carrier.put("value", carrierDelay);
									//description
									weatherDelay = rs.getString("weatherDelay_pcent");
								//	cp.setCarrierDescription(description);
									jsonObject_weather.put("label","Weather Delay");
									jsonObject_weather.put("value", weatherDelay);
									//delayAvg
									securityDelay = rs.getString("securityDelay_pcent");
									jsonObject_security.put("label","Security Delay");
									jsonObject_security.put("value",securityDelay);
									
									lateAircraftDelay = rs.getString("lateAircraftDelay_pcent");
									//	cp.setDelayAvg(delayAvg);
									jsonObject_la.put("label","Late Aircraft");
								    jsonObject_la.put("value",lateAircraftDelay);				
						   		// Display values
									//System.out.println("jsonObject" + jsonObject.toString());
									//	System.out.println("jsonObject_test"+jsonObject_test.toString());
								//	jsonArray.put(jsonObject);
								jsonArray.put(jsonObject_nas);
								jsonArray.put(jsonObject_carrier);
								jsonArray.put(jsonObject_weather);
								jsonArray.put(jsonObject_security);
								jsonArray.put(jsonObject_la);

								}
								js = jsonArray.toString();
								System.out.println("js:" + js);
							//	System.out.println("map"+ map.toString());
								// Clean-up environment
								rs.close();
								stmt.close();
								con.close();

							} catch (Exception e) {
								System.out.println("Error:" + e.getMessage());
								e.printStackTrace();
							}
						%>

						 <!-- <div id="donut-example"></div> -->
						 <div id="chartdiv"></div>
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
	<%out.print(js);%>;
	var chart;
	var legend;
/* 	var data = [{"value":"0.36941329444956095","label":"NAS Delay"},{"value":"0.2632046343311889","label":"Carrier Delay"},{"value":"0.043807088407962394","label":"Weather Delay"},{"value":"0.0016369489605598546","label":"Security Delay"},{"value":"0.32172930041380093","label":"Late Aircraft"}]
	;
 */
	AmCharts.ready(function() {
	    // PIE CHART
	    chart = new AmCharts.AmPieChart();
	    chart.dataProvider = dataset;
	    chart.titleField = "label";
	    chart.valueField = "value";
	    chart.outlineColor = "";
	    chart.outlineAlpha = 0.8;
	    chart.outlineThickness = 2;
	    // this makes the chart 3D
	    chart.depth3D = 20;
	    chart.angle = 30;
	    // WRITE
	    chart.write("chartdiv");
	});
	/* var data = dataset
	/* [
	            {label: "Weather", value: 0.043807088407962394},
	            {label: "Carrier", value:0.2632046343311889},
	            {label: "Security", value: 0.0016369489605598546},
	           {label: "NAS", value: 0.36941329444956095},
	           {label: "LateAircraft", value: 0.32172930041380093}
	          ] */;
	    /*     Morris.Donut({
	          element: 'donut-example',
	          data:  data
	        });

	        Morris.Donut({
	          element: 'donut-example',
	          data:  data
	        }); */ 
		$("#menu-toggle").click(function(e) {
			e.preventDefault();
			$("#wrapper").toggleClass("toggled");
		});
	</script>
</body>
</html>