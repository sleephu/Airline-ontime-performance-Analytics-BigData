<%@page import="com.google.gson.JsonArray"%>
<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<%@ page language="java" import="org.json.*"%>
<%@ page import="java.io.*,java.util.*,java.sql.*"%>
<%@ page import="javax.servlet.http.*,javax.servlet.*"%>

<%@ page import="show.AirportDelay"%>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
    <title>Airport Average Delay</title>
    <style>
      html { height: 100% }
      body { height: 100%; margin: 0; padding: 0; font-family:sans-serif; }
       #map-canvas {height: 95%; width:98%;} 
      h1 { position:absolute; background:black; color:white; padding:10px; font-weight:100; z-index:5000;}
      #all-examples-info { position:absolute; background:white; font-size:16px; padding:20px; bottom:20px; width:350px; line-height:150%; border:1px solid rgba(0,0,0,.2);}
    </style>
    <script type="text/javascript" src="https://maps.googleapis.com/maps/api/js?sensor=false"></script>
    <script src="resources/heatmap/build/heatmap.js"></script>
    <script src="resources/heatmap/plugins/gmaps-heatmap.js"></script>

<script type="text/javascript" src="http://d3js.org/d3.v3.min.js"></script>
  </head>
  <body>
  
    <h1>Airport Average Delay</h1>
     <div id="map-canvas"></div>
     <a href="index.jsp"><img style="position: absolute; top: 0; right: 0; border: 0;" src="resources/flight.ico" alt="Back"></a>
    		<%
		String host = "ec2-52-26-94-107.us-west-2.compute.amazonaws.com";
		String className = "org.apache.hive.jdbc.HiveDriver";
		String connectionName = "jdbc:hive2://" + host+ ":10000/default";
		AirportDelay cp = null;
		JSONArray jsonArray = null;
		JSONObject jsonObject = null;
		String js = null;
		try {
			// Register JDBC driver
			Class.forName(className).newInstance();
			// Open a connection
			Connection con = DriverManager.getConnection(connectionName,"hive","");
			System.out.println("got connection");
			// Execute SQL query
			Statement stmt = con.createStatement();
			String sql;
			// select * from CARRIERPOPULARITY WHERE YEAR = '2008' ORDER BY NUM
			// DESC LIMIT 3;
			sql = "select d.airportCode,d.delayAvg,a.lat,a.lon from hbase_airports a, average_arrival_delay_airport d where a.airportCode = d.airportCode";
			System.out.println("query:" + sql);
	%>

	<%
		ResultSet rs = stmt.executeQuery(sql);
			String airportCode, city, delayAvg,lat,lon;
			// Extract data from result set
			cp = new AirportDelay();
			jsonArray = new JSONArray();

			while (rs.next()) {
				// Retrieve by column name
				jsonObject = new JSONObject();
				airportCode = rs.getString("airportCode");
				cp.setAirportCode(airportCode);
				jsonObject.put("airportCode",cp.getAirportCode());
				
				delayAvg = rs.getString("delayAvg");
				cp.setDelayAvg(delayAvg);
				jsonObject.put("delayAvg", cp.getDelayAvg());
				
				lat = rs.getString("lat");
				cp.setLat(lat);
				jsonObject.put("lat", cp.getLat());
				
				lon = rs.getString("lon");
				cp.setLon(lon);
				jsonObject.put("lon", cp.getLon());
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

	
	<script src="startbootstrap/js/jquery.js"></script>

	<!-- Bootstrap Core JavaScript -->
	<script src="startbootstrap/js/bootstrap.min.js"></script>
	<script type="text/javascript">
	 
        // map center
        var myLatlng = new google.maps.LatLng(25.6586, -80.3568);
        // map options,
        var myOptions = {
          zoom: 3,
          center: myLatlng
        };
        // standard map
        map = new google.maps.Map(document.getElementById("map-canvas"), myOptions);
        // heatmap layer
        heatmap = new HeatmapOverlay(map, 
          {
            // radius should be small ONLY if scaleRadius is true (or small radius is intended)
            "radius": 2,
            "maxOpacity": 1, 
            // scales the radius based on map zoom
            "scaleRadius": true, 
            // if set to false the heatmap uses the global maximum for colorization
            // if activated: uses the data maximum within the current map boundaries 
            //   (there will always be a red spot with useLocalExtremas true)
            "useLocalExtrema": true,
            // which field name in your data represents the latitude - default "lat"
            latField: 'lat',
            // which field name in your data represents the longitude - default "lng"
            lngField: 'lon',
            // which field name in your data represents the data value - default "value"
            valueField: 'delayAvg'
          }
        );
        var dataset =
        	<%out.print(js);%>;
        var testData = {
          max: 100,
          data: dataset
        	  
        };

        heatmap.setData(testData);

</script>
  </body>
</html>