---
title: "Execution Algorithms: A Real-Time ML Approach"
date: 2025-04-19 10:00:00 +0800
author: EllianaLi
categories: [Trading]
pin: false
tags: [ML, Trading]
---

This blog is for testing.

---
> A milestone write-up on real-time execution modeling using limit order book features and dynamic thresholding.  
> 🧠 Written by Binxi Li, Sirui Zhang, and Sheng Zhang @ Cornell Financial Engineering (Spring 2025)

---
📄 [Execution Algorithms: A Real-Time ML Approach](https://ellianali.github.io/assets/pdf/Milestone2.pdf)

## 📘 Project Overview

In this project, we built a **real-time execution algorithm** to decide when to buy (or sell) one share per minute using limit order book (LOB) and message flow data.

We combined **market microstructure intuition** with **machine learning classifiers**, and designed fallback mechanisms to **guarantee exactly one trade per minute**. Our primary goal: achieve better prices than a TWAP benchmark by exploiting order-level features.

---

## 🧮 Features from LOB

We engineered several per-tick features to drive our model decisions:

- **Spread**: ask − bid (proxy for transaction cost)
- **Order Imbalance**: `(bid_volume - ask_volume)/(bid_volume + ask_volume)`
- **Momentum**: 5-tick change in mid-price
- **VWAP**: Size-weighted average trade price (last 10 orders)
- **Execution Intensity**: Rolling count of recent execution messages
- **Order Direction Mean**: Smoothed sentiment signal from buyer/seller tags
- **Time Pressure**: Scaled seconds-in-minute (0 at start, 1 at 59s)

These features help capture microstructural patterns like urgency, trend, and liquidity.

---

## 🧠 Model Logic

We used both a **Multilayer Perceptron (MLP)** and a **Decision Tree Classifier** to predict whether the current tick lies in the **lowest 3% ask price** of that minute.

To avoid missing trades, we implement a **time-adaptive confidence threshold**:

- `0–15s: p > 0.95`
- `15–30s: p > 0.90`
- `30–45s: p > 0.85`
- `45–60s: p > 0.80`

If no signal is triggered by second 60, a **fallback trade** is placed at current ask.

---

## 📊 Backtesting Results (AAPL)

- **Average Algo Price**: $584.0644  
- **TWAP Price**: $584.0826  
- **Improvement**: –$0.0182 per share  
- **Hit Rate (lowest price in minute)**: 63.2% (vs. 55.4% baseline)  
- **Precision/Recall**: Tree = 0.24 / 0.63, MLP = 0.13 / 0.66  

Most executions happened in the **first 15–30 seconds**, validating the effectiveness of our dynamic thresholds.

---

## 🔍 Key Takeaways

- Feature engineering using LOB is powerful even without deep learning
- Time-dependent thresholds help balance price quality vs. execution certainty
- Real-time decision-making can beat simple baselines with careful design
- Our framework is extendable to **sell-side, multi-asset, or cost-sensitive settings**

---
