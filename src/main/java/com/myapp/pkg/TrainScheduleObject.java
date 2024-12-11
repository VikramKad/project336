package com.myapp.pkg;

import java.util.ArrayList;

public class TrainScheduleObject implements Comparable<TrainScheduleObject>{
	
	String origin;
	String destination;
	String transitLine;
	String departureTime;
	String arrivalTime;
	String date;
	String fare;
	ArrayList<String> stops;
	
	public TrainScheduleObject() {
		
	}
	
	public TrainScheduleObject(String origin, String dest, String line, String dt, String at, String date, String fare, ArrayList<String> stops) {
		this.origin = origin;
		destination = dest;
		transitLine = line;
		departureTime = dt;
		arrivalTime = at;
		this.date = date;
		this.fare = fare;
		this.stops = stops;
	}
	
	public ArrayList<String> getStops() {
		return stops;
	}
	
    // Convert fare from String to double removing the dollar sign
    public double getFareAsDouble() {
        return Double.parseDouble(fare.replace("$", ""));
    }
	
	public String getOrigin() {
		return origin;
	}

	public String getDestination() {
		return destination;
	}

	public String getDeparture() {
		return departureTime;
	}

	public String getArrival() {
		return arrivalTime;
	}

	public String getDate() {
		return date;
	}

	public String getFare() {
		return fare;
	}

	public String getTransitLine() {
		return transitLine;
	}
	
	/**
	 * Print fields for display.
	 * @return
	 */
	public String toStringFormatted() {
		return "TrainScheduleObject.toStringFormatted()";
	}
	
	/**
	 * Print all fields of object.
	 */
	public String toString() {
		return origin + "\n" + destination + "\n" + transitLine + "\n" + departureTime + "\n" + arrivalTime + "\n" + date + "\n" + fare;
	}

	@Override
	public int compareTo(TrainScheduleObject o) {
		return Double.compare(this.getFareAsDouble(), o.getFareAsDouble());
	}
	
}
