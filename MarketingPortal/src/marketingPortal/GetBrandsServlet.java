package marketingPortal;

import java.io.IOException;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.google.gson.Gson;
import java.sql.Connection;

public class GetBrandsServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		String subcategoryId = request.getParameter("subcategoryId");
		List<BrandModel> list = new ArrayList<BrandModel>();
		String json = null;

		String sql_subCat = "SELECT * FROM brands where subcategory_id=" + subcategoryId + " order by name";
		Connection con = null;
		PreparedStatement ps = null;
		ResultSet rs = null;

		String driverName = "com.mysql.jdbc.Driver";
		String url = "jdbc:mysql://localhost:3306/marketingportal";
		String user = "root";
		String dbpsw = "root";

		try {
			Class.forName(driverName);
			con = DriverManager.getConnection(url, user, dbpsw);
			ps = con.prepareStatement(sql_subCat);
			rs = ps.executeQuery();
			while (rs.next()) {
				list.add(new BrandModel(rs.getString("id"),rs.getString("name")));
			}
			rs.close();
			ps.close();
			con.close();
			json = new Gson().toJson(list);
			response.setContentType("application/json");
			response.getWriter().write(json);
		} catch (Exception e) {
			System.out.println(e);
		}
	}
}