package com.myapp.pkg;

public class TrainScheduleObject {
	
	int originId;
	int destinationId;
	int trainId;
	String transitLine;
	String departureTime;
	String arrivalTime;
	double fare;
	
	public TrainScheduleObject(int o_id, int d_id, int t_id, String tl, String dt, String at, double f) {
		originId = o_id;
		destinationId = d_id;
		trainId = t_id;
		transitLine = tl;
		departureTime = dt;
		arrivalTime = at;
		fare = f;
	}
	
	public String getScheduleHtml() {
		String html = this.toString();
		// html = ...
		return html;
	}
	
	/**
	 * Print fields for display.
	 * @return
	 */
	public String toStringFormatted() {
		return transitLine;
	}
	
	/**
	 * Print all fields of object.
	 */
	public String toString() {
		return originId + "\n" + destinationId + "\n" + trainId + "\n" + transitLine + "\n" + departureTime + "\n" + arrivalTime + "\n" + fare;
	}
	
}
