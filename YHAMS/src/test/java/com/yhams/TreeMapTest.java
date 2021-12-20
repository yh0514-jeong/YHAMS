package com.yhams;

import java.util.Comparator;
import java.util.TreeMap;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.TestInstance.Lifecycle;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@TestInstance(Lifecycle.PER_METHOD)
class TreeMapTest {
	
private static final Logger log = LoggerFactory.getLogger(TreeMapTest.class);

	
@Test
public void treeMapIsSortableTest() {
	
	Comparator<Integer> comp = new Comparator<Integer>() {
		@Override
		public int compare(Integer o1, Integer o2) {
			return o2-o1;
		}
	};
	
	
	TreeMap<Integer, String> tmap = new TreeMap<>();
	
	tmap.put(5, "test5");
	tmap.put(1, "test1");
	tmap.put(2, "test2");
	tmap.put(3, "test3");
	tmap.put(4, "test4");
	tmap.put(6, "test6");
	tmap.put(9, "test9");
	

	log.info("tmap : {}", tmap);
	log.info("tmap.keySet() : {}", tmap.keySet());
	log.info("tmap.﻿values() : {}", tmap.values());
	log.info("====================================================");
	log.info("tmap.lowerEntry(4) : {}", tmap.lowerEntry(4));
	log.info("tmap.lowerKey(4) : {}", tmap.lowerKey(4));
	log.info("====================================================");
	log.info("tmap.floorEntry(4) : {}", tmap.floorEntry(4));
	log.info("tmap.floorKey(4) : {}", tmap.floorKey(4));
	log.info("====================================================");
	log.info("tmap.ceilingEntry(4) : {}", tmap.ceilingEntry(4));
	log.info("tmap.ceilingEntry(4) : {}", tmap.ceilingKey(4));
	log.info("====================================================");
	log.info("tmap.firstEntry() : {}", tmap.firstEntry());
	log.info("tmap.firstKey() : {}", tmap.firstKey());
	log.info("====================================================");
	log.info("tmap.﻿lastEntry() : {}", tmap.lastEntry());
	log.info("tmap.﻿lastKey() : {}", tmap.lastKey());
	log.info("====================================================");
	log.info("tmap.descendingMap() : {}", tmap.descendingMap());
	log.info("tmap.descendingKeySet() : {}", tmap.descendingKeySet());
	
	
}


}
