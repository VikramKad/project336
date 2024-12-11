package com.myapp.pkg;

import java.util.Comparator;
import com.myapp.pkg.TrainScheduleObject;

public class TrainScheduleComparator implements Comparator<TrainScheduleObject>{

	@Override
	public int compare(TrainScheduleObject o1, TrainScheduleObject o2) {
		// TODO Auto-generated method stub
		return o1.compareTo(o2);
	}
	
}
