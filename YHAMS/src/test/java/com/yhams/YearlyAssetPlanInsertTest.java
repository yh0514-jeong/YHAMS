package com.yhams;

import java.util.Arrays;
import java.util.List;
import java.util.UUID;

import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.TestInstance;
import org.junit.jupiter.api.TestInstance.Lifecycle;
import org.springframework.boot.test.context.SpringBootTest;

@SpringBootTest
@TestInstance(Lifecycle.PER_CLASS)
public class YearlyAssetPlanInsertTest {

	
	@Test
	public void yearly_asset_plan_metadata_insert() {
		
	     String USER_SEQ = "'USER_00001',";
	     String query    = "	INSERT INTO tb_tran_yearly_asset_plan(asset_plan_seq, user_seq, std_year, std_month, main_ctg, sub_ctg, amount, descript, create_id, create_date, update_id, update_date) VALUES (";
		 List<Integer> yearList = Arrays.asList(2019, 2020, 2021, 2022);
	     List<Integer> monthList = Arrays.asList(1,2,3,4,5,6,7,8,9,10,11,12);
	     
	     List<List<String>> cateMapList = Arrays.asList(
	    		 Arrays.asList("'DW_CAT1_02',", "'3853e274-6b59-4051-bef4-62dead950c50',"),
	    		 Arrays.asList("'DW_CAT1_02',", "'46a763ee-54b9-4e09-8014-59bc8a1529d1',"),
	    		 Arrays.asList("'DW_CAT1_01',", "'68b67e24-8fbf-4ff9-b16b-f318140cdec5',"),
	    		 Arrays.asList("'DW_CAT1_02',", "'903510c5-3d66-4f3e-bc64-9806fa85a3dd',"),
	    		 Arrays.asList("'DW_CAT1_02',", "'94206448-8aa9-42fb-b838-fea8e3e1bbea',"),
	    		 Arrays.asList("'DW_CAT1_02',", "'a3fe750c-fa63-4061-b03c-d94f16d79e6f',"),
	    		 Arrays.asList("'DW_CAT1_02',", "'c47d6461-0073-45e3-98ea-49cfa13e2edf',"),
	    		 Arrays.asList("'DW_CAT1_02',", "'d64e0872-0fa6-40c9-a622-20536075dfe5',")
	    		 );
	     
	     
	     for(int i=0; i<yearList.size(); i++) {
	    	 for(int j=0; j<monthList.size(); j++) {
	    		 for(int k=0; k<cateMapList.size(); k++) {
	    			 StringBuffer buffer = new StringBuffer();
	    			 buffer.append(query);
	    			 buffer.append("'" + UUID.randomUUID().toString() + "',");
	    			 buffer.append(USER_SEQ);
	    			 buffer.append(yearList.get(i)+ ",");
	    			 buffer.append(monthList.get(j)+ ",");
	    			 buffer.append(cateMapList.get(k).get(0));
	    			 buffer.append(cateMapList.get(k).get(1));
	    			 buffer.append((int)(Math.random() * 10000) + ",");
	    			 buffer.append("'테스트',");
	    			 buffer.append(USER_SEQ);
	    			 buffer.append("NOW(),");
	    			 buffer.append(USER_SEQ);
	    			 buffer.append("NOW());");
	    			 System.out.println(buffer);
	    		 }
	    	 }
	     }
	}
}
