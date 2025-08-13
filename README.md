# AWS Polly Text Narrator Application
A Node.js-based serverless application that uses **Amazon Polly** to convert text into high-quality speech and store the generated audio in **Amazon S3**. This project demonstrates text-to-speech (TTS) capabilities using AWS services, Infrastructure as Code with **AWS CloudFormation**, **AWS SAM**, and **Terraform**, as well as secure serverless deployment with **AWS IAM**. Users provide text input to a Lambda function, which synthesizes the audio via Polly and stores the `.mp3` file in S3 for download or playback.

## Architecture Overview
![Architecture Diagram](assets/architecture-diagram.png)  
*Figure 1: Architecture diagram of the AWS Polly Text Narrator Application.*

**Core Components**  
- **AWS Lambda** – Serverless function that processes text and calls Amazon Polly.  
- **Amazon Polly** – Text-to-Speech service that generates high-quality speech.  
- **Amazon S3** – Storage for generated `.mp3` files.  
- **IAM** – Manages permissions for Lambda to access Polly and S3.  
- **Node.js AWS SDK v3** – Used within Lambda for Polly and S3 interactions.

## Skills Applied
- Developing Lambda functions with AWS SDK v3 for Node.js.  
- Integrating Amazon Polly for TTS functionality.  
- Managing permissions via IAM roles and managed policies.  
- Provisioning AWS resources using CloudFormation, SAM, and Terraform.  
- Implementing serverless architecture patterns.

## Features
- Converts user-provided text into MP3 audio files.  
- Supports selection of Polly’s voice models.
- Stores audio files securely in Amazon S3.  
- Serverless deployment for cost-efficiency and scalability.  
- Infrastructure defined with both **CloudFormation/SAM** and **Terraform**.

## Tech Stack
- **Languages:** Node.js (JavaScript)  
- **AWS Services:** Lambda, Polly, S3, IAM  
- **IaC Tools:** CloudFormation, AWS SAM, Terraform  
- **Other Tools:** AWS CLI

## Deployment Instructions
> **Note:** All command-line examples use `bash` syntax highlighting to maximize compatibility and readability.  
> If you are using PowerShell or Command Prompt on Windows, the commands remain the same but prompt styles may differ.

To provision the required AWS infrastructure, deploy using **CloudFormation/SAM** or **Terraform** templates as included in this repository.

### **CloudFormation/SAM**
1. Install Lambda dependencies (only needed the first time or when dependencies change):
   ```bash
   cd ../src
   npm install
   ```
   
2. Navigate to the `cloudformation` folder:
   ```bash
   cd cloudformation
   ```
   
3. Build and deploy the SAM application:
   ```bash
   sam build
   sam deploy --guided --capabilities CAPABILITY_NAMED_IAM
   ```

4. Provide parameters when prompted (Stack Name, AWS Region, etc.).

### **Terraform**
1. Edit variables in `terraform.tfvars` and `variables.tf` to customize the deployment.

2. Install Lambda dependencies (only needed the first time or when dependencies change):
   ```bash
   cd ../src
   npm install
   ```
   
3. Navigate to the `terraform` folder and deploy:
   ```bash
   cd terraform
   terraform init
   terraform plan # Optional, but recommended.
   terraform apply
   ```

**Note:** Node.js 22.x or later with npm is required to deploy via CloudFormation/SAM. Ensure the AWS CLI is configured (`aws configure`) with credentials that have sufficient permissions to create **S3 buckets**, **deploy Lambda functions**, interact with **Amazon Polly**, and manage **IAM roles**.

## Project Structure
```plaintext
aws-polly-text-narrator/
├── assets/                      # Images, diagrams, screenshots
│   ├── architecture-diagram.png      # Project architecture
│   └── sample-terminalresults.png    # Sample Lambda output
├── cloudformation/              # AWS CloudFormation/SAM templates
│   └── template.yaml                 # Main SAM template
├── terraform/                   # Terraform templates
│   ├── main.tf                       # Main Terraform config
│   ├── outputs.tf					  # Outputs definitions
│   ├── variables.tf                  # Variables definitions
│   └── terraform.tfvars              # Sample variable values
├── src/                         # Lambda source code & dependencies
│   ├── index.js                      # Lambda handler
│   ├── package.json                  # Dependencies manifest
│   └── package-lock.json             # Dependency lock file
├── LICENSE                      # MIT License
├── README.md                    # Project documentation
└── .gitignore                   # Git ignored files
```

## Screenshot
![Labeled Output](assets/sample-terminalresults.png)

*Figure 2: Example Lambda invocation output showing generated audio file key.*

## How to Use

1. **Deploy the infrastructure** using CloudFormation/SAM or Terraform.

2. **Retrieve deployed resource names:**
   - For **CloudFormation/SAM**, run:
     ```bash
     aws cloudformation describe-stacks --stack-name <STACK_NAME> --query "Stacks[0].Outputs"
     ```
   - For **Terraform**, check the output variables you defined or run:
     ```bash
     terraform output
     ```

3. **Create a payload file** `payload.json` with the following JSON format:
   ```json
   {
     "text": "The text to be converted to Audio"
   }
   ```

4. **Invoke the Lambda function**  

   **4a. Use the AWS CLI**, replacing `<YOUR_LAMBDA_FUNCTION_NAME>` with the actual function name:  

     ```bash
     aws cloudformation create-stack \
     --stack-name rekognition-stack \
     --template-body file://template.yaml \
     --parameters file://params.json \
     --capabilities CAPABILITY_NAMED_IAM
     ```

   **4b. Use the AWS Management Console:**
   - Navigate to **Lambda** and select the function.  
   - Click **Test** at the top right.  
   - Configure a new Test event with the payload JSON file.  
   - Run the test and check the execution results.  

5. **Check the S3 bucket** for the generated `.mp3` audio file. Download or play the file as needed.

## Future Enhancements
- **API Gateway Integration** – Provide a REST endpoint for text submissions.
- **Presigned S3 URLs** – Enable secure, time-limited audio downloads.
- **Multi-Language Support** – Integrate **Amazon Translate** to automatically translate text into multiple languages before speech synthesis.
- **Event-Driven Automation** – Use S3 or API Gateway triggers for real-time processing.

## License
This project is licensed under the [MIT License](LICENSE).

---

### Author
**Patrick Heese**  
Cloud Administrator | Aspiring Cloud Engineer/Architect  
[LinkedIn Profile](https://www.linkedin.com/in/patrick-heese/) | [GitHub Profile](https://github.com/patrick-heese)
