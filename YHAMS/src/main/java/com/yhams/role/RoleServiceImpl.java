package com.yhams.role;

import java.util.ArrayList;
import java.util.HashMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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

	@Override
	@Transactional
	public int updateRoleMenuMap(HashMap<String, Object> param) throws Exception {
		
		int result = 0;
		
		try {
			
			result = mapper.deleteRoleMenuMap(param);
					
			String ROLE_ID = param.get("ROLE_ID").toString();
			String[] menuIds = param.get("MENU_ID").toString().split(",");
			
			for(int i=0; i<menuIds.length; i++) {
				param.put("MENU_ID", menuIds[i]);
				result = mapper.insertRoleMenuMap(param);
			}
			
		}catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		
		return result;
		
	}

}
