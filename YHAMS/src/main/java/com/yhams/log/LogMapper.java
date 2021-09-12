package com.yhams.log;

import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface LogMapper {

	void insertUserActLog(HashMap<String, Object> param) throws Exception;

}
