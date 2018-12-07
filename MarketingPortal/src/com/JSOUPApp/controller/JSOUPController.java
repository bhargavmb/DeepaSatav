package com.JSOUPApp.controller;

import java.io.IOException;



import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import com.JSOUPApp.model.CustomerReview;



public class JSOUPController extends HttpServlet {
	
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;
	
	@Override
	protected void doGet(HttpServletRequest req,HttpServletResponse res) {
		//doPost(req,res);
		System.out.println("Test");
	}

	@Override
	protected void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		
		String pid=req.getParameter("pid");
		String pname=req.getParameter("pname");
		System.out.println("Product ID= "+pid);
		System.out.println("Product Name= "+pname);
		System.out.println("Test in dopost");
		//String siteName = "https://www.amazon.in/Sony-Xperia-XA1-Dual-Black/product-reviews/B06Y3VRP78/ref=cm_cr_dp_d_show_all_top?ie=UTF8&reviewerType=all_reviews";
//		String siteName="http://www.amazon.in/"+pname+"/product-reviews/B01BDM2QAA/ref=cm_cr_arp_d_viewpnt_lft?showViewpoints=1&filterByStar=positive&pageNumber=1";
		String siteName="http://www.amazon.in/"+pname+"/product-reviews/B004G6002M/ref=cm_cr_dp_d_cmps_btm?ie=UTF8&reviewerType=all_reviews";

		
		System.out.println("Site Link= "+siteName);
		Document doc=Jsoup.connect(siteName).get();
		
		System.out.println("Site Data:"+doc.title());
					
		Elements names=doc.select("a.a-size-base.a-link-normal.author");
		
		List<String> name = new ArrayList<String>();
				
		for(Element element:names){
			//System.out.println("Name:"+element.text());
			name.add(element.text());
		}
		
		
		Elements ratings=doc.getElementsByAttribute("title").addClass("a.a-link-normal");
		List<String> rates=new ArrayList<String>();
		
		for(Element element:ratings){
			System.out.println("Ratings:"+element.text());
			rates.add(element.text());
		}
		

		
		Elements comments=doc.select("span.a-size-base.review-text");
		List<String> comment=new ArrayList<String>();
		
		for(Element element:comments){
			//System.out.println("Comment:"+element.text());
			comment.add(element.text());
		}
		
		
		Elements dates=doc.select("span.a-size-base.a-color-secondary.review-date");
		List<String> date=new ArrayList<String>();
		
		for(Element element:dates){
			//System.out.println("Date:"+element.text());
			date.add(element.text());
		}
		
		//remove wrong ratings from arraylist
		rates.remove(0);rates.remove(0);rates.remove(0);rates.remove(0);rates.remove(0);rates.remove(0);
		
		//remove wrong review dates
		date.remove(0);date.remove(0);
		
		//final customer review details
		
		List<CustomerReview> finalList=new ArrayList<CustomerReview>();
						
		System.out.println("name size:"+name.size());
		System.out.println("Rates size:"+rates.size());
		System.out.println("comment size:"+comment.size());
		System.out.println("date size:"+date.size());
		System.out.println("Product ID: "+pid);
		
//		if(name.size()==rates.size() && rates.size()== comment.size() && rates.size()==date.size()
//				&& name.size()== comment.size() && comment.size()==date.size() && name.size()==date.size()){
			
			for(int i=0;i<name.size();i++){
				CustomerReview cr=new CustomerReview();
				cr.setCustomerName(name.get(i));
				cr.setCustomerComment(comment.get(i));
				cr.setCustomerRate(rates.get(i));
				cr.setCustomerCommentDate(date.get(i));
				cr.setPid(pid);
				finalList.add(cr);
				
			}
		//}
	/*	req.setAttribute("pid", pid);*/
		req.setAttribute("result", finalList);
		
		
		RequestDispatcher dispatcher= req.getRequestDispatcher("/data_view.jsp");
		dispatcher.forward(req, res);
		
				
	}

}
