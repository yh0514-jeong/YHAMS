package com.yhams.asset;

import java.util.ArrayList;
import java.util.HashMap;

import javax.swing.text.html.HTMLDocument.HTMLReader.ParagraphAction;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class AssetServiceImpl implements AssetService {
	
	@Autowired
	AssetMapper mapper;

	@Override
	public long accountCount(HashMap<String, Object> param) throws Exception {
		return mapper.accountCount(param);
	}

	@Override
	public ArrayList<HashMap<String, Object>> accountListUp(HashMap<String, Object> param) throws Exception {
		return mapper.accountListUp(param);
	}

}
