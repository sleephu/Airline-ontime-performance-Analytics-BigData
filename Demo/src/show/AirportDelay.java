package show;

public class AirportDelay {
	String airportCode;
	String city;
	String delayAvg;
	String lat;
	String lon;
	public String getAirportCode() {
		return airportCode;
	}
	public void setAirportCode(String airportCode) {
		this.airportCode = airportCode;
	}
	public String getCity() {
		return city;
	}
	public void setCity(String city) {
		this.city = city;
	}
	public String getDelayAvg() {
		return delayAvg;
	}
	public void setDelayAvg(String delayAvg) {
		this.delayAvg = delayAvg;
	}
	public String getLat() {
		return lat;
	}
	public void setLat(String lat) {
		this.lat = lat;
	}
	public String getLon() {
		return lon;
	}
	public void setLon(String lon) {
		this.lon = lon;
	}
	@Override
	public String toString() {
		return "AirportDelay:"+ airportCode+ "city:"+ city + "lat:"+lat + "lon:"+lon;
	}
}
