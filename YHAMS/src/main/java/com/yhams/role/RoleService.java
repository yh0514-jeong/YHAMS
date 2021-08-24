package com.yhams.role;

import java.util.ArrayList;
import java.util.HashMap;

public interface RoleService {

	long roleCount(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> roleList(HashMap<String, Object> param) throws Exception;

	HashMap<String, Object> selectRole(HashMap<String, Object> param) throws Exception;

	int insertRole(HashMap<String, Object> param) throws Exception;

	int updateRole(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getRoleList(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getRoleMenuMapList(HashMap<String, Object> param) throws Exception;

	int updateRoleMenuMap(HashMap<String, Object> param) throws Exception;

	ArrayList<HashMap<String, Object>> getRoleUserMapList(HashMap<String, Object> param) throws Exception;

}
