package com.yhams;

import java.util.Arrays;
import java.util.List;
import java.util.TreeMap;
import java.util.UUID;
import java.util.concurrent.atomic.AtomicInteger;

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
			log.info("tmap.ceilingKey(4) : {}", tmap.ceilingKey(4));
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
	
	
	
		@Test
		public void insert_tb_meta_user_def_icmexp_category() {
					
			List<List<String>> mainSubList = Arrays.asList (Arrays.asList("수입", "월급")
															,Arrays.asList("지출", "어머니 용돈")
															,Arrays.asList("지출", "통신비용")
															,Arrays.asList("지출", "보험료")
															,Arrays.asList("지출", "여자친구")
															,Arrays.asList("지출", "경기도장학관")
															,Arrays.asList("지출", "교통비")
															,Arrays.asList("지출", "카드"));
			
		  AtomicInteger idx = new AtomicInteger(1);
			
		   mainSubList.stream().forEach(list -> {
			  
			   StringBuffer buffer = new StringBuffer();
				buffer.append("INSERT INTO tb_meta_user_def_icmexp_category (USER_DEF_SEQ,USER_SEQ,MAIN_CTG,SUB_CTG,SUB_CTG_NM,CODE_ORDR,USE_YN,CREATE_ID,CREATE_DATE,UPDATE_ID,UPDATE_DATE) VALUES (\n"
						+ "");
				buffer.append("'" + UUID.randomUUID().toString() + "',");
				buffer.append("'USER_00001',");
				buffer.append("수입".equals(list.get(0)) ? "'DW_CAT1_01'," : "'DW_CAT1_02',");
				buffer.append("'" + UUID.randomUUID().toString() + "',");
				buffer.append("'" + list.get(1) + "',");
				buffer.append(idx + ",");
				buffer.append("'Y',");
				buffer.append("'USER_00001',");
				buffer.append("NOW(),");
				buffer.append("'USER_00001',");
				buffer.append("NOW());");
				System.out.println(buffer);
				idx.incrementAndGet();
		   });
		}


}
