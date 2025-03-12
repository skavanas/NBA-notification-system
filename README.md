# NBA Game Notification System

This project is an **NBA Game Notification System** designed to send real-time notifications about NBA games using AWS services. The project integrates **AWS EventBridge**, **AWS Lambda**, and **Amazon SNS** to manage and send game notifications efficiently. It also leverages **AWS Systems Manager** to securely store and access environment variables, and **Terraform** to automate the infrastructure setup.

---

## 📖 **Project Overview**  
![SAYHI BACKEND CONCEPTTION (1)](https://github.com/user-attachments/assets/de6a06a1-334c-4288-a1a3-073629ee0fb6)

 

---

## ✅ **Steps**  
1. **Event Triggering:**  
   - We configured **AWS EventBridge** to monitor NBA game events and trigger a Lambda function when a new event is detected.  

2. **Notification Handling:**  
   - The triggered **AWS Lambda** function processes the event and sends notifications using **Amazon SNS** to the subscribed users.  

3. **Environment Management:**  
   - We used **AWS Systems Manager Parameter Store** to securely store environment variables such as API keys and SNS topic ARNs.  

4. **Automation:**  
   - We used **Terraform** to automate the provisioning of AWS resources (EventBridge, Lambda, SNS, Systems Manager).  

---

## 🚀 **Technologies Used**  
- **AWS EventBridge** – For event-based triggering  
- **AWS Lambda** – For processing events and sending notifications  
- **Amazon SNS** – For sending notifications to subscribers  
- **AWS Systems Manager** – For secure storage and management of environment variables  
- **Terraform** – For automating infrastructure setup  

---

## 🎯 **Use Cases**  
- Receive real-time notifications about NBA games.  
- Centralized management of environment variables using AWS Systems Manager.  
- Automated infrastructure setup using Terraform.  
- Scalable and event-driven architecture using EventBridge and Lambda.  

---

## 🏁 **How to Get Started**  
1. **Clone the repository**  
```bash
git clone https://github.com/skavanas/nba-game-notification.git
