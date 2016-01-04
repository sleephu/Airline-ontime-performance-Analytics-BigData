package show;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class AirportInfo
 */
@WebServlet("/AirportInfo")
public class AirportInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public AirportInfo() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	public static final String host = "ec2-52-26-94-107.us-west-2.compute.amazonaws.com";
	// "52.26.94.107";
	//public static final String port = "2181";
	static final String className = "org.apache.phoenix.jdbc.PhoenixDriver";
	static final String connectionName = "jdbc:phoenix:"+ host;

	//static final String connectionName = "jdbc:phoenix:localhost";
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		//response.getWriter().append("Served at: ").append(request.getContextPath());

		// Set response content type
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE html>");
		out.println("<html>");
		out.println("<head> <meta charset=\"utf-8\"><meta http-equiv=\"X-UA-Compatible\" content=\"IE=edge\"><meta name=\"viewport\" content=\"width=device-width, initial-scale=1\"> <meta name=\"description\" content=\"\"><meta name=\"author\" content=\"\"><title>Demo</title>");
		out.println("<link href=\"startbootstrap/css/bootstrap.min.css\" rel=\"stylesheet\">");
		out.println("<link href=\"startbootstrap/css/simple-sidebar.css\" rel=\"stylesheet\">");
		out.println("<script src=\"https://oss.maxcdn.com/libs/html5shiv/3.7.0/html5shiv.js\"></script><script src=\"https://oss.maxcdn.com/libs/respond.js/1.4.2/respond.min.js\"></script>");
		out.println("<style>");
		out.println("#loading {position: absolute; width: 100%; height: 100%; background: url('spinner.gif') no-repeat center center;}");
		out.println("</style>");
		out.println("</head>");
		out.println("<body>");
		out.println("<div id=\"wrapper\">");
		out.println("<div id=\"sidebar-wrapper\"><ul class=\"sidebar-nav\"><li class=\"sidebar-brand\"><a href=\"airport.jsp\">Airports Overview</a></li><li><a href=\"ViewPage?type=airport\">Airport Information </a></li><li><a href=\"ViewPage?type=carrier\">Airline Popularity</a></li><li><a href=\"performanceInfo.jsp\">Performance Information</a></li><li><a href=\"airportDelay.jsp\">Airport Average Delay</a></li><li><a href=\"carrierDelay.jsp\">Airline Performance</a></li><li><a href=\"delayReason.jsp\">Delay Reason Analysis</a></li><li><a href=\"#\">Contact</a></li></ul></div>");
		out.println("<div id=\"page-content-wrapper\"><div class=\"container-fluid\"><div class=\"row\"><div class=\"col-lg-12\">");
		String stateInput = request.getParameter("state").toUpperCase();
		if (stateInput == null){
			out.println("please input state");
		}
	//	request.setAttribute("stateInput",stateInput);
		out.println("<a href=\"#menu-toggle\" class=\"btn btn-default\" id=\"menu-toggle\">Toggle Menu</a>");
		out.println("<form action=\"visualize.jsp\"><label>See airport location by code:</label> <input type=\"text\" name=\"airport\" /><input type=\"submit\" value=\"See Airport Location\"></form>");
//		out.println("<input button=\"submit\" class=\"btn btn-default\" action=onc>Visulize</a>");
		out.println("<div id=\"loading\"></div>");
		Airport airport = new Airport();
		try {
			// Register JDBC driver
			Class.forName(className).newInstance();
			// Open a connection
			java.sql.Connection con = DriverManager.getConnection(connectionName);
			System.out.println("got connection");
			// Execute SQL query
			Statement stmt = con.createStatement();
			String sql;
			sql = "select * from " + "AIRPORTS" + " where state = '" + stateInput + "'";
			System.out.println("query:"+ sql);
			ResultSet rs = stmt.executeQuery(sql);
			
			// Extract data from result set
			if (!rs.wasNull()){
				out.println("<h1>Airport Information at ");
				out.println(stateInput);
				out.println("</h1>");
				out.println("<table>");
				out.println("<tr>");
				out.println("<th>airportCode</th>");
				out.println("<th>airportName</th>");
				out.println("<th>city</th>");
				out.println("<th>state</th>");
				out.println("<th>country</th>");
				out.println("<th>lat</th>");
				out.println("<th>lon</th>");
				out.println("</tr>");
			}
			
			while (rs.next()) {
				// Retrieve by column name
				String airportAbbre = rs.getString("airportCode");
				airport.setAirportCode(airportAbbre);
				String airportName = rs.getString("airportName");
				airport.setAirportName(airportName);
				String city = rs.getString("city");
				airport.setCity(city);
				String state = rs.getString("state");
				airport.setState(state);
				String country = rs.getString("country");
				airport.setCountry(country);
				String lat = rs.getString("lat");
				airport.setLat(lat);
				String lon = rs.getString("lon");
				airport.setLon(lon);

				// Display values
				out.println("<tr>");
				out.println("<td>");
				out.println(airport.getAirportCode());
				out.println("</td>");
				out.println("<td>");
				out.println(airport.getAirportName());
				out.println("</td>");
				out.println("<td>");
				out.println(airport.getCity());
				out.println("</td>");
				out.println("<td>");
				out.println(airport.getState());
				out.println("</td>");
				out.println("<td>");
				out.println(airport.getCountry());
				out.println("</td>");
				out.println("<td>");
				out.println(airport.getLat());
				out.println("</td>");
				out.println("<td>");
				out.println(airport.getLon());
				out.println("</td>");
				out.println("</tr>");
//				out.println("airportCode: " + airport.getAirportCode() + "<br>");
//				out.println(", airportName: " + airport.getAirportName() + "<br>");
//				out.println(", city: " + airport.getCity() + "<br>");
//				out.println(", state: " + airport.getState() + "<br>");
//				out.println(", country: " + airport.getCountry() + "<br>");
//				out.println(", lat: " + airport.getLat() + "<br>");
//				out.println(", lon: " + airport.getLon() + "<br>");

			}
			
			out.println("</table>");
			out.println("</div></div></div></div></div>");
			out.println("<script src=\"startbootstrap/js/jquery.js\"></script><script src=\"startbootstrap/js/bootstrap.min.js\"></script><script>$(\"#menu-toggle\").click(function(e) {e.preventDefault(); $(\"#wrapper\").toggleClass(\"toggled\"); });</script>");
			out.println("<script>");
			out.println("$(window).ready(function() {$('#loading').hide();});");
			out.println("</script>");
			out.println("</body></html>");

			// Clean-up environment
			rs.close();
			stmt.close();
			con.close();
		} catch (Exception e) {
			System.out.println("Error:"+e.getMessage());
			e.printStackTrace();
		}
	}

	/**
	 * @see HttpServlet#doPost(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		doGet(request, response);
	}

}
