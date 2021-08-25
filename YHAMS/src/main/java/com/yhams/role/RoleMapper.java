package com.yhams.role;

import java.util.ArrayList;
import java.util.HashMap;

import org.apache.ibatis.annotations.Mapper;

@Mapper
public interface RoleMapper {

	long roleCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> roleList(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> selectRole(HashMap<String, Object> param) throws Exception;

	int insertRole(HashMap<String, Object> param) throws Exception;

	int updateRole(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getRoleList(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getRoleMenuMapList(HashMap<String, Object> param) throws Exception;

	int deleteRoleMenuMap(HashMap<String, Object> param) throws Exception;

	int insertRoleMenuMap(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getRoleUserMapList(HashMap<String, Object> param)  throws Exception;

	int deleteRoleUseruMap(HashMap<String, Object> param) throws Exception;

	int insertRoleUserMap(HashMap<String, Object> param) throws Exception;

}
