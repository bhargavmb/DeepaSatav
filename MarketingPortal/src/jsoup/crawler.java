package jsoup;

import java.io.BufferedWriter;
import java.io.FileWriter;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

import au.com.bytecode.opencsv.CSVWriter;

public class crawler {

	public static void main(String[] args) throws IOException, InterruptedException
	{
		// TODO Auto-generated method stub
		Document doc = null;
		BufferedWriter bw = null;
		// Tab delimited file will be written to data with the name tab-file.csv
		String csv = "C:\\akash\\ak2.csv";
		CSVWriter writer = new CSVWriter(new FileWriter(csv));
	    //Iterate over all the review pages
		for(int i=1;i<=10;i++)
		{
			if(i%5==0)
			{
				Thread.sleep(20000);
			}
			System.out.println("Start Again");
			try {
				
				doc =  Jsoup.connect("https://www.flipkart.com/nike-revolution-3-running-shoes/p/itmes6a8uz4vsyjy?pid=SHOES6A8FZWXM67V&srno=b_1_4&otracker=hp_omu_Big%20Brands%20at%20Best%20Prices_3_Up%20to%2050%25%20Off_1366522d-9dc5-4276-b137-8d0b80a39b22_DesktopSite&lid=LSTSHOES6A8FZWXM67V3SSEF8").timeout(30000).userAgent(" Chrome/15.0.874.120 ").get();
						
			} catch (IOException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
				Thread.currentThread().sleep(20000);
			}
			//Save the review in the review_title element 
	//		Elements review_title = doc.select("span[class$=review-title]");
		
			//Save the review author name in review_author element
			Elements authors= doc.select("p[class$=_3LYOAd]");
			//Save the review date in review_date element
			//Elements review_date = doc.select("span[class$=review-date]");
			//Elements review_rating = doc.select("div[class$=review-info-star-rating]"); 
			Elements review_text = doc.select("div[class$=qwjRop]");
			//Save the helpfulness in review_helpfulness 
		//	Elements review_helpfulness = doc.select("span[class$=a-size-small a-color-secondary review-votes]");
			//Save the ratings in the review_rating
			
			
		//	List title = new ArrayList();
			
			
			List author = new ArrayList();List date= new ArrayList();List rating = new ArrayList();List text= new ArrayList();
			//List helpful = new ArrayList();
			/*for (Element element : review_title) 
			{
				title.add(element.text());
			}*/
			
			for (Element element :authors) 
			{
				author.add(element.text());
			}
			/*for (Element element : review_date) 
			{
				date.add(element.text());
			}*/
			for (Element element : review_text) 
			{
				text.add(element.text());
			}
			/*for (Element element : review_helpfulness) 
			{
				helpful.add(element.text());
			}*/
			/*for(Element element : review_rating)
			{
				rating.add(element.text());
			}*/
			//1 2 3 14 15 16 These indices contain the unnecessary ratings
			System.out.println(rating.size());
			
			rating.remove(0);rating.remove(0);rating.remove(0);
			rating.remove(10);rating.remove(10);rating.remove(10);
			date.remove(0);date.remove(0);
			System.out.println(date);
			System.out.println(rating.size());
			//System.exit(1);
			for(int index=0;index<10;index++)
			{
				//System.out.println(title.get(index));
				//System.out.println(text.get(index));
				//System.out.println(rating.get(index));
				try {
					List<String[]> data = new ArrayList<String[]>();
					/*try{System.out.println((String) title.get(index));}
					catch (Exception e){title.add(index, "NA");}*/
					
					
					try{System.out.println((String) author.get(index));}
					catch (Exception e){author.add(index, "NA");}
					try{System.out.println((String) date.get(index));}
					catch (Exception e){date.add(index, "NA");}
					try{System.out.println((String) rating.get(index));}
					catch (Exception e){rating.add(index, "NA");}
					try{System.out.println((String) text.get(index));}
					catch (Exception e){text.add(index, "NA");}
					/*try{System.out.println((String) helpful.get(index));}
					catch (Exception e){helpful.add(index, "NA");}*/
					data.add(new String[] {(String) author.get(index),(String) date.get(index),(String) rating.get(index),(String) text.get(index)});
					writer.writeAll(data);
				} catch (Exception e) {
					// TODO Auto-generated catch block
					e.printStackTrace();
				}				
			}
		}
		writer.close();
	}

}