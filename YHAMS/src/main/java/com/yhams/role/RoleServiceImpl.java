package com.yhams.role;

import java.util.ArrayList;
import java.util.HashMap;

import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import ch.qos.logback.classic.Logger;

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
			if(!"".equals(param.get("MENU_ID").toString().trim()) && param.get("MENU_ID") != null) {
				String[] menuIds = param.get("MENU_ID").toString().split(",");
				System.out.println("updateRoleMenuMap menuIds==>" + menuIds.toString());
				for(int i=0; i<menuIds.length; i++) {
					param.put("MENU_ID", menuIds[i]);
					result = mapper.insertRoleMenuMap(param);
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		return result;
	}

	
	@Override
	public ArrayList<HashMap<String, Object>> getRoleUserMapList(HashMap<String, Object> param) throws Exception {
		return mapper.getRoleUserMapList(param);
	}

	
	@Override
	@Transactional
	public int updateRoleUserMap(HashMap<String, Object> param) throws Exception {
		int result = 0;
		try {
			result = mapper.deleteRoleUseruMap(param);
			if(!"".equals(param.get("USER_SEQ").toString().trim()) && param.get("USER_SEQ") != null) {
				String[] userSeqs = param.get("USER_SEQ").toString().split(",");
				System.out.println("updateRoleUserMap userSeqs==>" + userSeqs.toString());
				for(int i=0; i<userSeqs.length; i++) {
					param.put("USER_SEQ", userSeqs[i]);
					result = mapper.insertRoleUserMap(param);
				}
			}
		}catch (Exception e) {
			e.printStackTrace();
			return -1;
		}
		return result;
	}

}
