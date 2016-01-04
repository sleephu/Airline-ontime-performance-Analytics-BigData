package show;

public class ReasonAnalysis {
String type;
String percentage;
public String getType() {
	return type;
}
public void setType(String type) {
	this.type = type;
}
public String getPercentage() {
	return percentage;
}
public void setPercentage(String percentage) {
	this.percentage = percentage;
}
@Override
	public String toString() {
		// TODO Auto-generated method stub
		return "Type:["+type+",Percentage:"+percentage+"]";
	}
}
