package com.service.ai.agent.model;

import java.util.ArrayList;
import java.util.List;

/**
 * DTO chứa kết quả tư duy theo mô hình GAME
 */
public class GameReasoning {
    private String goal;
    private List<String> analysis = new ArrayList<>();
    private List<String> execution = new ArrayList<>();
    private String finalResponse;

    public void addThought(String thought) {
        this.analysis.add(thought);
    }

    public void addExecution(String observation) {
        this.execution.add(observation);
    }

    // Getters and Setters
    public String getGoal() { return goal; }
    public void setGoal(String goal) { this.goal = goal; }
    public List<String> getAnalysis() { return analysis; }
    public void setAnalysis(List<String> analysis) { this.analysis = analysis; }
    public List<String> getExecution() { return execution; }
    public void setExecution(List<String> execution) { this.execution = execution; }
    public String getFinalResponse() { return finalResponse; }
    public void setFinalResponse(String finalResponse) { this.finalResponse = finalResponse; }
}
