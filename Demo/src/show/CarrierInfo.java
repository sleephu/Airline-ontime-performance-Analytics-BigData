package show;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/**
 * Servlet implementation class CarrierInfo
 */
@WebServlet("/CarrierInfo")
public class CarrierInfo extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#HttpServlet()
	 */
	public CarrierInfo() {
		super();
		// TODO Auto-generated constructor stub
	}

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	public static final String host = "ec2-52-26-94-107.us-west-2.compute.amazonaws.com";
	// "52.26.94.107";
	// public static final String port = "2181";
	static final String className = "org.apache.phoenix.jdbc.PhoenixDriver";
	static final String connectionName = "jdbc:phoenix:" + host;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		// TODO Auto-generated method stub
		// response.getWriter().append("Served at:
		// ").append(request.getContextPath());
		// Set response content type
		String topNInput = request.getParameter("topN");
		int topN = Integer.parseInt(topNInput);
		String yearInput = request.getParameter("yearInput");
		String errorY = null;
		int yearIn = 0;
		if (yearInput.equals("") || yearInput == null) {
			errorY = "Please Input Year between 1987 - 2008";
		}else {
			 yearIn = Integer.parseInt(yearInput);
		}
			
		if (yearIn < 1987 || yearIn > 2008) {
			 errorY = "Please Input Year between 1987 - 2008";
		}
		 if(topNInput !=null && yearInput != null){
         	request.setAttribute("topN", topN);
         	request.setAttribute("yearInput", yearInput);
         	request.setAttribute("errorY", errorY);
         	 RequestDispatcher dispatcher =
      			    request.getRequestDispatcher("carrierInfo.jsp");
      			    dispatcher.forward(request, response);
         }
		/*
		response.setContentType("text/html;charset=utf-8");
		PrintWriter out = response.getWriter();
		out.println("<!DOCTYPE html>");
		out.println("<html>");
		out.println("<head><style>");
		out.println(".chart div { font: 10px sans-serif; background-color: steelblue; text-align: right; padding: 3px;margin: 1px; color: white;}");
	    out.println("</style></head>");
	    out.println("<body>");
	    out.println("<div class=\"chart\"></div>");
	    out.println("<script src=\"http://d3js.org/d3.v3.min.js\"  charset=\"utf-8\"></script>");
		out.print("<title>Demo</title>");
		String topNInput = request.getParameter("topN");
		int topN = Integer.parseInt(topNInput);
		String yearInput = request.getParameter("year");
		Carrier carrier = new Carrier();
		CarrierPop cp = new CarrierPop();
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
			sql = "select * from " + "CARRIERPOPULARITY WHERE YEAR = " + "'" + yearInput + "'"
					+ " ORDER BY NUM DESC LIMIT " + topN;
			System.out.println("query:" + sql);
			ResultSet rs = stmt.executeQuery(sql);
			String year, carrie, num;
			// Extract data from result set
			List<CarrierPop> selected = new ArrayList<CarrierPop>();
			while (rs.next()) {
				// Retrieve by column name
				year = rs.getString("YEAR");
				cp.setYear(year);
				carrie = rs.getString("CARRIER");
				cp.setCarrier(carrie);
				num = rs.getString("NUM");
				cp.setNum(num);
				// Display values
				selected.add(cp);
				out.println("Year: " + cp.getYear() + "<br>");
				out.println(", Carrier: " + cp.getCarrier() + "<br>");
				out.println(", num of flights: " + cp.getNum() + "<br>");

			}
			out.println("<script>");
			out.println("var data = [");
			for (CarrierPop c : selected){
				out.println("");
			}
			out.println("</script>");
			out.println("</body></html>");

			// Clean-up environment
			rs.close();
			stmt.close();
			con.close();
		} catch (Exception e) {
			System.out.println("Error:" + e.getMessage());
			e.printStackTrace();
		}
		*/
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
