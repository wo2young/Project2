package kr.or.mes2.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ChatbotDAO {

	@Autowired
	private SqlSession sqlSession;

	private static final String NAMESPACE = "kr.or.mes2.mapper.DashboardMapper";

	public int getTodayProduction() {
		return sqlSession.selectOne(NAMESPACE + ".getTodayProduction");
	}

	public int getTodayDefect() {
		return sqlSession.selectOne(NAMESPACE + ".getTodayDefect");
	}

	public int getInventorySummary() {
		return sqlSession.selectOne(NAMESPACE + ".getInventorySummary");
	}

	public String getEquipmentStatus() {
		return sqlSession.selectOne(NAMESPACE + ".getEquipmentStatus");
	}
}
