package show;

public class Performance {

	String flightDate;
	String delay;
	String distance;
	String origin;
	String destination;
	public String getFlightDate() {
		return flightDate;
	}
	public void setFlightDate(String flightDate) {
		this.flightDate = flightDate;
	}
	public String getDelay() {
		return delay;
	}
	public void setDelay(String delay) {
		this.delay = delay;
	}
	public String getDistance() {
		return distance;
	}
	public void setDistance(String distance) {
		this.distance = distance;
	}
	public String getOrigin() {
		return origin;
	}
	public void setOrigin(String origin) {
		this.origin = origin;
	}
	public String getDestination() {
		return destination;
	}
	public void setDestination(String destination) {
		this.destination = destination;
	}
	@Override
	public String toString() {
		
		return "Performance Info:/n"+ flightDate+": Delay(min):"+delay + ",Distance:"+ distance + ",Ori:"+origin+",Des:"+destination;
	}
	
}
