package commonDataAccess;

import java.util.List;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;

public class commonDAOImpl implements commonDAO {
	
	@Resource(name = "CommonDAO")
	protected SqlSessionTemplate templates;
	
	@Override
	public void setSqlSessionTemplate(SqlSessionTemplate template) {
		 this.templates = template;
	}

	@Override
	public int insert(String queryId, Object parameters) {
		return templates.insert(queryId, parameters);
	}

	@Override
	public int update(String queryId, Object parameters) {
		return templates.update(queryId, parameters);
	}

	@Override
	public int delete(String queryId, Object parameters) {
		return templates.delete(queryId, parameters);
	}

	@Override
	public List<? extends Object> selectList(String queryId, Object parameters) {
		return templates.selectList(queryId, parameters);
	}

	@Override
	public Object select(String queryId, Object parameters) {
		return templates.selectOne(queryId, parameters);
	}

}
