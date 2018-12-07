package com.search.controller;

import java.io.IOException;


import java.sql.Connection;
import java.util.ArrayList;
import java.util.List;
import java.sql.*;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import com.google.gson.Gson;

/**
 * Servlet implementation class search
 */

public class search extends HttpServlet {
	private static final long serialVersionUID = 1L;

	/**
	 * @see HttpServlet#doGet(HttpServletRequest request, HttpServletResponse
	 *      response)
	 */
	protected void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		response.setContentType("text/html");
		String str = request.getParameter("name");
		System.out.println(str);
		HttpSession session = request.getSession();
		String website_id = session.getAttribute("website_id").toString();

		try {
			String connectionURL = "jdbc:mysql://localhost:3306/marketingportal";
			Connection con;
			Class.forName("com.mysql.jdbc.Driver");
			// Get a Connection to the database
			con = DriverManager.getConnection(connectionURL, "root", "root");
			// Add the data into the database
			String sql = "SELECT distinct(name) FROM products  WHERE name LIKE '" + str + "%' and website_id=" + website_id + " LIMIT 10";
			Statement stm = con.createStatement();
			stm.executeQuery(sql);
			ResultSet rs = stm.getResultSet();
			List<String> items = new ArrayList<String>();

			while (rs.next()) {

				items.add(rs.getString("name"));
				 //System.out.println("<li onclick='fill(" + rs.getString("name") + ");'>" + rs.getString("name") + "</i>");
				
				// System.out.println(rs.getString("name"));
			}
			String name = new Gson().toJson(items);
			response.getWriter().write(name);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

}
