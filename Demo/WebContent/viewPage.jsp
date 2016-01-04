<%@ page language="java" contentType="text/html; charset=US-ASCII"
	pageEncoding="US-ASCII"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=US-ASCII">
<!--     <meta charset="utf-8"> -->
<meta http-equiv="X-UA-Compatible" content="IE=edge">
<meta name="viewport" content="width=device-width, initial-scale=1">
<meta name="description" content="">
<meta name="author" content="">
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
    <style>
    .select-style {
    padding: 0;
    margin: 200 px;
    border: 1px solid #ccc;
    width: 120px;
    border-radius: 3px;
    overflow: hidden;
    background-color: #fff;

    background: #fff url("http://www.scottgood.com/jsg/blog.nsf/images/arrowdown.gif") no-repeat 90% 50%;
}

.select-style select {
   /*  padding: 5px 8px; */
    width: 130%;
    border: none;
    box-shadow: none;
    background-color: transparent;
    background-image: none;
    -webkit-appearance: none;
       -moz-appearance: none;
            appearance: none;
}

.select-style select:focus {
    outline: none;
}
    </style>
<script src="https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js"></script>
<script
	src="https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js"></script>
	 <script src="http://d3js.org/d3.v3.min.js" charset="utf-8"></script>
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
		<%
			String type = request.getParameter("type");
		%>
		
		<!-- Page Content -->
		<div id="page-content-wrapper">
			<div class="container-fluid">
				<div class="row">
					<div class="col-lg-12">
						<%-- <h1>${type}</h1> --%>
				<%
			if (type.equals("airport")) {
		%>
		<h2>Airports Information</h2>
	<%-- 	<p>Info for ${type}</p> --%>
		<form action="AirportInfo" method="get">
			<label>Search By State:</label> <input type="text" name="state" /> <input
				type="submit" value="Search" />
		</form>
		<%
			} else if (type.equals("carrier")) {
		%>
	<%-- 	<p>Info for ${type}</p> --%>
		<h2>Airline Popularity By Year</h2>
		<form action="CarrierInfo" method="get">
			<label>Top N:</label><br> <input type="text" name="topN" /><br>
			<label>Year:</label>
			 <div class="select-style">
  <select name = "yearInput">
 <option value="1989">1989</option>
 <option value="1990">1990</option> 
<option value="1991">1991</option>
 <option value="1992">1992</option>
 <option value="1993">1993</option>
 <option value="1994">1994</option>
 <option value="1995">1995</option>
 <option value="1996">1996</option> 
<option value="1997">1997</option>
 <option value="1998">1998</option>
 <option value="1999">1999</option>
 <option value="2000">2000</option>
 <option value="2001">2001</option>
 <option value="2002">2002</option>
 <option value="2003">2003</option>
 <option value="2004">2004</option>
 <option value="2005">2005</option> 
<option value="2006">2006</option>
 <option value="2007">2007</option> 
<option value="2008">2008</option>
 
  </select>
</div><br>
	<!-- 		 <input type="text" name="yearInput" /> --> 
			 <input type="submit" value="View" />
		</form>
		<%
			}
		%>
				<!-- 		<a href="#menu-toggle" class="btn btn-default" id="menu-toggle">Toggle
							Menu</a> -->
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

	<!-- Menu Toggle Script -->
	<script>
		$("#menu-toggle").click(function(e) {
			e.preventDefault();
			$("#wrapper").toggleClass("toggled");
		});
		
		/* var data = ["1987", "1988", "1989","1990","1991","1992","1993","1994","1995","1996","1997","1998","1999","2000","2001","2002","2003","2004","2005","2006","2007","2008"];

		var select = d3.select('body')
		  .append('select')
		  	.attr('class','select')
		    .on('change',onchange)

		var options = select
		  .selectAll('option')
			.data(data).enter()
			.append('option')
				.text(function (d) { return d; });

		function onchange() {
			selectValue = d3.select('select').property('value')
			d3.select('body')
				.append('p')
				.text(selectValue + ' is the last selected option.')
		}; */
	</script>

</body>
</html>