# FiTrivia Frontend 🎉📱

🚀	[Overview](#🚀-overview)<br>
🤔	 [How It Works](#🤔-how-it-works)<br>
💻	[Technologies Used](#💻-technologies-used)<br>


## 🚀 Overview

Welcome to FiTrivia, a fun and engaging trivia app where players answer questions by doing exercises in front of the camera! 🏋️‍♀️📷

## 🤔 How It Works

When you start the app, you can create a new account or log in to an existing account. Once you're logged in, you can create a new trivia room or join an existing one.

In the trivia room, the host can start a new game and invite other players to join. Each game consists of a series of questions, and for each question, players must do a specific exercise in front of the camera to submit their answer. 🤸‍♂️

The app uses the device's camera to take pictures of the player several times every second and sends them to the backend server. The server uses a combination of [MediaPipe](https://mediapipe.dev/) and a [Keras CNN model](https://keras.io/) to analyze the sequence of images and determine which exercise the player is performing. If the exercise matches the correct answer to the question, the player earns points based on their speed and accuracy. ⏱️🎯

## 💻 Technologies Used

This app is built using [Flutter](https://flutter.dev/), a powerful cross platform SDK that allows you to create high-performance, visually attractive apps for both Android and iOS platforms.

The camera functionality is implemented using the [camera](https://pub.dev/packages/camera) package, which provides a simple interface to the device's camera.
