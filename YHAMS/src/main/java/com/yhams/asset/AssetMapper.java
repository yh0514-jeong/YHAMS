package com.yhams.asset;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface AssetMapper {

	long accountCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> accountListUp(HashMap<String, Object> param) throws Exception;

}
