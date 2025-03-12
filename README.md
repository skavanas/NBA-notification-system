# NBA Game Notification System

This project is an **NBA Game Notification System** designed to send real-time notifications about NBA games using AWS services. The project integrates **AWS EventBridge**, **AWS Lambda**, and **Amazon SNS** to manage and send game notifications efficiently. It also leverages **AWS Systems Manager** to securely store and access environment variables, and **Terraform** to automate the infrastructure setup.

---

## 📖 **Project Overview**  

<p align="center">
  <img src="https://github.com/user-attachments/assets/de6a06a1-334c-4288-a1a3-073629ee0fb6" width="75%" alt="Image 1" style="float:left; margin-right: 10px;">
  <img src="https://github.com/user-attachments/assets/a755f8e4-9db2-4534-9cd2-bd2151988645" width="25%" alt="Image 2" style="float:left;">
</p>

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
```
2. **Configure AWS environment and Terraform**
   
-Set up AWS credentials.
-Add your environment variables (like API keys) to AWS Systems Manager.

4. **Deploy the infrastructure using Terraform**
```bash
terraform init  
terraform apply 
```
4. **Subscribe to Notifications**
   
-Subscribe to the SNS topic to start receiving NBA game notifications.

6. **Subscribe to Notifications**
   
-Trigger an event in EventBridge and confirm that you receive a notification.

## Contributing
**Feel free to contribute to this project by:**


-Opening issues

-Creating pull requests

-Providing feedback

   

