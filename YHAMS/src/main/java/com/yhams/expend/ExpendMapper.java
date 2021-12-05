package com.yhams.expend;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface ExpendMapper {

	ArrayList<HashMap<String, Object>> getAccountList(HashMap<String, Object> param) throws Exception;

}
