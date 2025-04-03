/**
 * @description       : 
 * @author            : salesforce
 * @group             : gaurp
 * @last modified on  : 04-02-2025
 * @last modified by  : salesforce
**/
public class ReverseGeocodingWrapper{
	public results[] results;
	public class results {
		public components components;
		public Integer confidence;	//10
		public String formatted;	//Office Club, Pappelallee 78/79, 10437 Berlin, Germany
		public geometry geometry;
	}
	public class components {
		public String city;	//Berlin
		public String city_district;	//Pankow
		public String continent;	//Europe
		public String country;	//Germany
		public String country_code;	//de
		public String house_number;	//78/79
		public String neighbourhood;	//Bremer Höhe
		public String office;	//Office Club
		public String political_union;	//European Union
		public String postcode;	//10437
		public String road;	//Pappelallee
		public String state;	//Berlin
		public String state_code;	//BE
		public String suburb;	//Prenzlauer Berg
	}
	class geometry {
		public Double lat;	//52.5432379
		public Double lng;	//13.4142133
	}
	/*public static ReverseGeocodingWrapper parse(String json){
		return (ReverseGeocodingWrapper) System.JSON.deserialize(json, ReverseGeocodingWrapper.class);
	}*/
}