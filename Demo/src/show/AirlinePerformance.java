package show;

public class AirlinePerformance {
	String year;
	String carrierCode;
	String carrierDescription;
	String delayAvg;
	public String getYear() {
		return year;
	}
	public void setYear(String year) {
		this.year = year;
	}
	public String getCarrierCode() {
		return carrierCode;
	}
	public void setCarrierCode(String carrierCode) {
		this.carrierCode = carrierCode;
	}
	public String getCarrierDescription() {
		return carrierDescription;
	}
	public void setCarrierDescription(String carrierDescription) {
		this.carrierDescription = carrierDescription;
	}
	public String getDelayAvg() {
		return delayAvg;
	}
	public void setDelayAvg(String delayAvg) {
		this.delayAvg = delayAvg;
	}
	@Override
	public String toString() {
		// TODO Auto-generated method stub
		return "Airline Performance:"+ year+":"+carrierCode+":"+delayAvg;
	}
}
