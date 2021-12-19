package com.yhams;

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
	
	TreeMap<Integer, String> tmap = new TreeMap<>();
	
	tmap.put(5, "test5");
	tmap.put(1, "test1");
	tmap.put(2, "test2");
	tmap.put(3, "test3");
	tmap.put(4, "test4");
	tmap.put(6, "test6");
	tmap.put(9, "test9");
	
	
	log.info("tmap.keySet() : {}, return Type : {}", tmap.keySet());
	log.info("tmap.﻿values() : {}", tmap.values());
	log.info("tmap.﻿lowerKey(4) : {}", tmap.lowerEntry(4));
	log.info("tmap.﻿﻿floorKey(4) : {}", tmap.floorKey(4));
	log.info("tmap.﻿﻿ceilingKey(4) : {}", tmap.ceilingKey(4));
	log.info("tmap.firstEntry() : {}", tmap.firstEntry());
	log.info("tmap.﻿lastEntry() : {}", tmap.lastEntry());
	log.info("tmap.firstKey() : {}", tmap.firstKey());
	log.info("tmap.﻿lastKey() : {}", tmap.lastKey());
	
	
}


}
