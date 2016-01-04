<%@page import="com.google.gson.JsonArray"%>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<%@ page language="java" import="org.json.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%@ page import="show.AirlinePerformance"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8">
<title>Demo</title>
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
							AirlinePerformance cp = null;
							List<AirlinePerformance> cps = null;
						//	HashMap<String, String> map = null;
							JSONArray jsonArray = null;
							JSONObject jsonObject = null;
							JSONArray jsonArray_test = null;
							JSONObject jsonObject_test = null;
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
								sql = "select a.year,a.carrier,a.delayAvg,c.description from hbase_carriers c, yearly_airline_performance a where c.carrierCode = a.carrier AND a.carrier IN ('WN','DL','UA','US','AA')";
								System.out.println("query:" + sql);
						%>
						<h2>Airline Performance by Year</h2>
						<%
							ResultSet rs = stmt.executeQuery(sql);
								String year, carrier, description, delayAvg;
								// Extract data from result set
								cp = new AirlinePerformance();
								jsonArray = new JSONArray();
								//	jsonArray_test = new JSONArray();
								//	String data = null;
								cps = new ArrayList<AirlinePerformance>();
							//	map = new HashMap<String, String>();
								while (rs.next()) {
									// Retrieve by column name
									jsonObject = new JSONObject();
									jsonObject_test = new JSONObject();
							//		jsarray = new StringBuilder();
									//year
									year = rs.getString("year");
									cp.setYear(year);
									jsonObject.put("year",cp.getYear());
									//carrierCode
									carrier = rs.getString("carrier");
									cp.setCarrierCode(carrier);
									jsonObject.put("carrier", cp.getCarrierCode());
									//description
									description = rs.getString("description");
									cp.setCarrierDescription(description);
									jsonObject.put("description", cp.getCarrierDescription());
									//delayAvg
									delayAvg = rs.getString("delayAvg");
									cp.setDelayAvg(delayAvg);
									jsonObject.put("delayAvg", cp.getDelayAvg());
									//data
									//data = cp.getCarrierCode() + ":" + cp.getDelayAvg();
									//	jsonObject.put("carrierCode",cp.getDelayAvg());
									//	jsonObject_test.put(cp.getYear(),cp.getCarrierCode()+":"+cp.getDelayAvg());
									// Display values
									//System.out.println("jsonObject" + jsonObject.toString());
									//	System.out.println("jsonObject_test"+jsonObject_test.toString());
									jsonArray.put(jsonObject);
								//	jsarray.append(jsonArray).substring(1, jsarray.length());
								//	System.out.println("jsonArray:"+jsonArray);
								//	System.out.println("jsarrayStringBuilder:"+ jsarray.toString());
									/* if (map.containsKey(cp.getYear())) {
										map.put(cp.getYear(),map.get(cp.getYear())+","+jsarray.toString());
									} else {
										map.put(cp.getYear(),jsarray.toString());
									} */

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

						 <div id="line-example"></div>
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
	var year = new Map();
	dataset.forEach(function(elem) {
	    //document.write(elem.c + "_");
	    var key = elem.year + elem.carrier;
	    var y = elem.year;
	    if (year.has(y)) {
	      year.get(y)[elem.carrier] = parseFloat(elem.delayAvg);
	    } else {
	      var newobj = {};
	      newobj[elem.carrier] = parseFloat(elem.delayAvg);
	      year.set(y, newobj);
	    } 
	  });

	var myres = [];
	var airlines = [];

	year.forEach(function(value,key){ 
	 // document.write("key:"+key+";value:"+value + "<br>");
	  var yy = {};
	  yy["year"]= key;
	  for (var k in value) { 
	 //   document.write("value["+k+"] = "+value[k]+"<br>");
	    yy[k] = value[k];
	    if (airlines.indexOf(k) == -1) {
	 //     document.write(k+ "???");
	      airlines.push(k);
	    }
	  }
	  myres.push(yy);
	}); 

	Morris.Line({
	  element: 'line-example',
	  data: myres,
	  xkey: 'year',
	  ykeys: airlines,
	  labels: airlines
	});
	
		$("#menu-toggle").click(function(e) {
			e.preventDefault();
			$("#wrapper").toggleClass("toggled");
		});
	</script>
</body>
</html>