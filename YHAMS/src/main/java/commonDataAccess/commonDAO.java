package commonDataAccess;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;

public interface commonDAO {
	
	public void setSqlSessionTemplate(SqlSessionTemplate template);
	
	public int insert(String queryId, Object parameters);
	public int update(String queryId, Object parameters);
	public int delete(String queryId, Object parameters);
	
	public List<? extends Object> selectList(String queryId, Object parameters);
	public Object select(String queryId, Object parameters);

}
