package com.service.ai.infrastructure;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ArrayNode;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.service.ai.agent.model.Message;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.net.URI;
import java.net.http.HttpClient;
import java.net.http.HttpRequest;
import java.net.http.HttpResponse;
import java.time.Duration;
import java.util.List;

/**
 * Client giao tiếp với Groq API (Sử dụng mã nguồn người dùng cung cấp)
 */
@Service
public class GroqClient {

    @Value("${groq.api.key}")
    private String apiKey;

    @Value("${groq.api.model}")
    private String model;

    @Value("${groq.api.url}")
    private String apiUrl;

    private final HttpClient client = HttpClient.newBuilder()
            .connectTimeout(Duration.ofSeconds(30))
            .build();

    private final ObjectMapper mapper = new ObjectMapper();

    public String generate(List<Message> messages) {
        try {
            ObjectNode body = mapper.createObjectNode();
            body.put("model", model);

            ArrayNode msgs = mapper.createArrayNode();
            for (Message m : messages) {
                if (m.getContent() == null || m.getContent().isBlank()) continue;
                ObjectNode msg = mapper.createObjectNode();
                msg.put("role", m.getRole().equalsIgnoreCase("assistant")
                    ? "assistant" : m.getRole().toLowerCase());
                msg.put("content", m.getContent());
                msgs.add(msg);
            }

            if (msgs.isEmpty()) {
                return "Không có nội dung để xử lý.";
            }

            body.set("messages", msgs);

            HttpRequest request = HttpRequest.newBuilder()
                    .uri(URI.create(apiUrl))
                    .header("Content-Type", "application/json")
                    .header("Authorization", "Bearer " + apiKey)
                    .timeout(Duration.ofSeconds(60))
                    .POST(HttpRequest.BodyPublishers.ofString(
                            mapper.writeValueAsString(body)
                    ))
                    .build();

            HttpResponse<String> response =
                    client.send(request, HttpResponse.BodyHandlers.ofString());

            JsonNode root = mapper.readTree(response.body());

            if (root.has("error")) {
                throw new RuntimeException("API error: "
                    + root.get("error").get("message").asText());
            }

            return root.get("choices").get(0)
                       .get("message")
                       .get("content").asText();

        } catch (RuntimeException e) {
            throw e;
        } catch (Exception e) {
            throw new RuntimeException("API call failed: " + e.getMessage(), e);
        }
    }

    public String generate(String prompt) {
        if (prompt == null || prompt.isBlank()) {
            return "Prompt không được để trống.";
        }
        return generate(List.of(new Message("user", prompt)));
    }
}
