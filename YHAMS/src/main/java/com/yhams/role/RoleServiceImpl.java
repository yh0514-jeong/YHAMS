package com.yhams.role;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class RoleServiceImpl implements RoleService {
	
	@Autowired
	RoleMapper mapper;

	@Override
	public long roleCount(HashMap<String, Object> param) throws Exception {
		return mapper.roleCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> roleList(HashMap<String, Object> param) throws Exception {
		return mapper.roleList(param);
	}

	@Override
	public HashMap<String, Object> selectRole(HashMap<String, Object> param) throws Exception {
		return mapper.selectRole(param);
	}

	@Override
	public int insertRole(HashMap<String, Object> param) throws Exception {
		return mapper.insertRole(param);
	}

	@Override
	public int updateRole(HashMap<String, Object> param) throws Exception {
		return mapper.updateRole(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getRoleList(HashMap<String, Object> param) throws Exception {
		return mapper.getRoleList(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> getRoleMenuMapList(HashMap<String, Object> param) throws Exception {
		return mapper.getRoleMenuMapList(param);
	}

}
