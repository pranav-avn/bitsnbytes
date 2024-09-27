import { GoogleGenerativeAI } from "@google/generative-ai";
const genAI = new GoogleGenerativeAI("AIzaSyBdM-zkMxxQhCkvept_nv0BIXtUTEwTOZ8");
import { createRequire } from "module";
const require = createRequire(import.meta.url);
const http = require("node:http");
const express = require("express");
const app = express();
const port = 3000;
const { Server } = require("ws");
app.use(express.json());
const cors = require('cors');
app.use(cors());

var gemini_reply = "Loading";
let model;
async function initializeModel() {
  const generation_config = {
    temperature: 1,
    top_p: 0.95,
    top_k: 16,
    max_output_tokens: 200,
    response_mime_type: "application/json",
  };
  model = await genAI.getGenerativeModel({
    model: "gemini-1.5-flash",  // Assuming this is the correct model name
    generation_config,
  });
}
const generation_config = {
  temperature: 1,
  top_p: 0.95,
  top_k: 16,
  max_output_tokens: 200,
  response_mime_type: "application/json",
};
async function GeminiAi(params) {
  const generation_config = {
    temperature: 1,
    top_p: 0.95,
    top_k: 16,
    max_output_tokens: 200,
    response_mime_type: "application/json",
  };

  const model = genAI.getGenerativeModel({
    model: "gemini-1.5-flash",
    generation_config,
  });

  const prompt = params;

  if (!model) {
    await initializeModel();
  }

  const result = await model.generateContent(prompt);
  const response = await result.response;
  gemini_reply = response.text();
  console.log(response.text());
}



// const result = await model.generateContent([prompt, image]);
// console.log(result.response.text());

app.post("/api/data", async (req, res) => {
  console.log("Request from app : ", req.body);

  const user_prompt = req.body.prompt;
  await GeminiAi(user_prompt);

  res.status(200).json({
    success: true,
    status_code: 200,
    message: gemini_reply,
    user_prompt: req.body,
  });
});

// app.listen(port, () => {
//   console.log("sever is running on http://100.127.34.180:%d/api/data", port);
// });
// https://05b3-106-221-23-107.ngrok-free.app
app.listen(port, () => {
  console.log("sever is running on https://f088-49-37-136-46.ngrok-free.app/api/data", port);
});

// https://f088-49-37-136-46.ngrok-free.app

app.get("/api/data", (req, res) => {
  res.status(200).send("Hey, You are in my backend!!!");
});

// const server = express()
//   .use((req, res) => res.send("Hello World"))
//   .listen(port, () => console.log(`Listening on ${port}`));
