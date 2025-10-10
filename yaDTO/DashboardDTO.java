package kr.or.human99.dto;

import java.util.List;
import java.util.Map;

public class DashboardDTO {
    private int todayProduction;
    private int todayDefect;
    private int totalInventory;
    private List<Map<String, Object>> defectStatus; // 불량별 현황 리스트 추가

    public int getTodayProduction() { return todayProduction; }
    public void setTodayProduction(int todayProduction) { this.todayProduction = todayProduction; }

    public int getTodayDefect() { return todayDefect; }
    public void setTodayDefect(int todayDefect) { this.todayDefect = todayDefect; }

    public int getTotalInventory() { return totalInventory; }
    public void setTotalInventory(int totalInventory) { this.totalInventory = totalInventory; }

    public List<Map<String, Object>> getDefectStatus() { return defectStatus; }
    public void setDefectStatus(List<Map<String, Object>> defectStatus) { this.defectStatus = defectStatus; }
}
