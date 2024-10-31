# AI Compute and Proxy Router Node Build on Cloud: Specifications, Requirements, and Guidance

    Requirements and Specifications for build and setup of Compute adn Proxy Router nodes on Cloud Platforms

## Table of Contents

- [Compute Node Build](#compute-node-build)
  - [Prerequisites & Requirements](#prerequisites--requirements)
  - [Network Configuration](#network-configuration)
  - [Compute Node Configuration](#compute-node-configuration)
    - [Install LLM and Model](#install-llm-and-model)
    - [Download Model](#download-model)
    - [Host Model](#host-model)
    - [Validate Model Running](#validate-model-running)
- [Proxy Router Build](#proxy-router-build)
  - [Prerequisites & Requirements](#prerequisites--requirements-1)
  - [Installation](#installation)
    - [A. Proxy Router](#a-proxy-router)
    - [B. UI Desktop](#b-ui-desktop)
    - [D. CLI](#d-cli)
  - [Configuration Considerations](#configuration-considerations)
- [References](#references)

---

## Compute Node Build

### Prerequisites & Requirements

- **Cloud Account with GPU Allocation Access**
- **Kubernetes Two-Node Cluster**
  - Compute node can scale to 3
  - Proxy server can scale to 3
- **Compute Node Specifications:**
  - GPU
  - 100 GB storage
  - Ubuntu OS
  - NVIDIA plugin
- **Installed Applications:**
  - Git
  - Docker

### Network Configuration

#### Compute Node

- **Expose External IP**
- **Ports:**
  - `8080`

#### Proxy Server Node

- **Expose External IP**
- **Ports:**
  - `8080`, `8082`, `3333`

### Compute Node Configuration

#### Install LLM and Model

```bash
git clone https://github.com/ggerganov/llama.cpp.git
cd llama.cpp
make -j 8 LLAMA_CUDA=1
```

#### Download Model

Set model-specific variables by choosing one of the following models from [TheBloke on Hugging Face](https://huggingface.co/TheBloke):

1. **Llama-2-7B-Chat-GGUF / llama-2-7b-chat.Q5_K_M.gguf (7.28GB RAM required)**
   ```bash
   model_url="https://huggingface.co/TheBloke"
   model_collection="Llama-2-7B-Chat-GGUF"
   model_file_name="llama-2-7b-chat.Q5_K_M.gguf"
   ```
2. **TinyLlama-1.1B-Chat-v1.0-GGUF / tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf**
   ```bash
   model_url="https://huggingface.co/TheBloke"
   model_collection="TinyLlama-1.1B-Chat-v1.0-GGUF"
   model_file_name="tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf"
   ```
3. **CollectiveCognition-v1.1-Mistral-7B-GGUF / collectivecognition-v1.1-mistral-7b.Q5_K_M.gguf**
   ```bash
   model_url="https://huggingface.co/TheBloke"
   model_collection="CollectiveCognition-v1.1-Mistral-7B-GGUF"
   model_file_name="collectivecognition-v1.1-mistral-7b.Q5_K_M.gguf"
   ```
4. **CapybaraHermes-2.5-Mistral-7B-GGUF / capybarahermes-2.5-mistral-7b.Q5_K_M.gguf**
   ```bash
   model_url="https://huggingface.co/TheBloke"
   model_collection="CapybaraHermes-2.5-Mistral-7B-GGUF"
   model_file_name="capybarahermes-2.5-mistral-7b.Q5_K_M.gguf"
   ```

#### Host Model

Set the following environment variables prior to runtime using one of the models. Suggested models are **Llama-2-7B-Chat-GGUF** or **TinyLlama-1.1B-Chat-v1.0-GGUF**.

```bash
model_port=[PORT]
model_url=[MODEL_URL]
model_collection=[MODEL_COLLECTION]
model_file_name=[MODEL_FILE_NAME]
```

##### Single GPU

```bash
./llama-server -m models/${model_file_name} --host ${model_host} --port ${model_port} --n-gpu-layers 99 --ctx-size 8192 --threads 8
```

##### Dual GPU

```bash
./llama-server -m models/${model_file_name} --host ${model_host} --port ${model_port} --n-gpu-layers 99 --ctx-size 98304 --threads 8 --parallel 16
```

From the command prompt of the cloned `llama.cpp` directory, run the following:

- **Single GPU Example:**

  ```bash
  ./llama-server -m models/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf --host 127.0.0.1 --port 8080 --n-gpu-layers 99 --ctx-size 8192 --threads 8 & tail -f nohup.out
  ```

- **Dual GPU Example:**

  ```bash
  ./llama-server -m models/tinyllama-1.1b-chat-v1.0.Q4_K_M.gguf --host 127.0.0.1 --port 8080 --n-gpu-layers 99 --ctx-size 98304 --threads 8 --parallel 16 --flash-attn & tail -f nohup.out
  ```

#### Validate Model Running

Navigate to `http://127.0.0.1:8080` in a browser to see the model interface and test inference. You should also see interactions in the terminal window.

**Note:** This should also work with the external IP configured during setup, e.g., `http://[COMPUTE_NODE_EXTERNAL_IP]:8080`.

---

## Proxy Router Build

**IMPORTANT:** These items need to be encapsulated into a Docker image and corresponding configuration steps or similar. The following is a list of instruction sets by component.

### Prerequisites & Requirements

- **Existing Funded Wallet with saMOR and saETH**
  - You must have the private key for the wallet (needed for the `.env` file configuration).
- **An Alchemy or Infura Free Account**
  - Private API key for the Arbitrum Sepolia testnet (`wss://arb-sepolia.g.alchemy.com/v2/<your_private_alchemy_api_key>`).
- **Proxy Router Environment Variables (`.env.example` file):**

  Key values in the `.env` file:

  ```ini
  WALLET_PRIVATE_KEY=
  ETH_NODE_ADDRESS=wss://arb-sepolia.g.alchemy.com/v2/<your_private_alchemy_api_key>
  DIAMOND_CONTRACT_ADDRESS=0x208eaeD75A12C35625708140c99A614FC45bf780
  MOR_TOKEN_ADDRESS=0x34a285a1b1c166420df5b6630132542923b5b27e
  WEB_ADDRESS=0.0.0.0:8082
  WEB_PUBLIC_URL=localhost:8082
  OPENAI_BASE_URL=http://localhost:8080/v1
  PROXY_STORAGE_PATH=./data/
  MODELS_CONFIG_PATH=
  PROXY_ADDRESS=0.0.0.0:3333
  ```

- **External Provider or Pass-through (OPTIONAL):**
  - Dependencies:
    - `model-config.json` file in the proxy-router directory.
    - Update `MODELS_CONFIG_PATH` in `.env` file.

### Installation

#### A. Proxy Router

1. **Clone Repository:**

   ```bash
   git clone https://github.com/Lumerin-protocol/Morpheus-Lumerin-Node.git
   cd Morpheus-Lumerin-Node/proxy-router
   ```

2. **Update Environment Configuration File:**

   ```bash
   cp .env.example .env
   vi .env
   ```

3. **Build and Run the Proxy Router:**

   ```bash
   ./build.sh
   make run
   ```

4. **Validate that the Proxy Router is Running:**

   Terminal output should display:

   ```plaintext
   2024-08-07T11:35:49.116184    INFO    proxy state: running
   2024-08-07T11:35:49.116534    INFO    Wallet address: <your wallet address 0x.....>
   2024-08-07T11:35:49.116652    INFO    started watching events, address 0x10777866547c53cbd69b02c5c76369d7e24e7b10
   2024-08-07T11:35:49.116924    INFO    HTTP    http server is listening: 0.0.0.0:8082
   2024-08-07T11:35:49.116962    INFO    TCP     tcp server is listening: 0.0.0.0:3333
   ```

   Navigate to `http://localhost:8082/swagger/index.html` in a browser to see the proxy-router interface and test the Swagger API.

#### B. UI Desktop

**Note:** TCP port that your proxy-router API interface is listening on (`8082` in this example).

1. **Navigate to `ui-desktop` Directory:**

   ```bash
   cd Morpheus-Lumerin-Node/ui-desktop
   ```

2. **Check Environment Variables:**

   ```bash
   cp .env.example .env
   vi .env
   ```

   Ensure `PROXY_WEB_URL` is set to `8082`.

3. **Install Dependencies, Compile, and Run the UI Desktop:**

   ```bash
   yarn install
   yarn dev
   ```

4. **Validate that the UI Desktop is Running:**

   - The Electron app should start and run through onboarding.
   - Verify your ERC20 Wallet Address.
   - Check saMOR and saETH balances on the Wallet tab.
   - On the Chat tab, interact with the model to test functionality.

#### D. CLI

**Note:** TCP port that your proxy-router API interface is listening on (`8082` in this example).

1. **Navigate to CLI Directory:**

   ```bash
   cd Morpheus-Lumerin-Node/cli
   ```

2. **Verify Environment Variables:**

   ```bash
   cp .env.example .env
   vi .env
   ```

   Ensure `API_HOST` is set to `http://localhost:8082`.

3. **Build CLI:**

   ```bash
   make build
   ```

4. **Validate that the CLI is Working:**

   ```bash
   ./mor-cli -h
   ```

5. **Validate Connection to Proxy Router:**

   ```bash
   ./mor-cli healthcheck
   ```

   Expected output:

   ```json
   {"Status":"healthy","Uptime":"18s","Version":"TO BE SET AT BUILD TIME"}
   ```

---

## Configuration Considerations

Running LLMs (e.g., Llama.cpp, GPT, Flan, BERT) efficiently on cloud platforms necessitates appropriate GPU resources and disk storage configurations.

Below are GPU specifications and recommended disk storage types and sizes for Google Cloud Platform (GCP), Microsoft Azure, and Amazon Web Services (AWS).

### **1. Google Cloud Platform (GCP)**

#### **Minimum GPU Requirements**

- **GPU Type:** NVIDIA T4 GPU
- **GPU Memory (VRAM):** 16 GB
- **System Memory (RAM):** At least 16 GB
- **Instance Type Example:** `n1-standard-4` with 1 NVIDIA T4 GPU

#### **Recommended Disk Storage**

- **Disk Type:** Persistent SSD (`pd-ssd`)
- **Disk Size:**
  - **Minimum:** **50 GB**
  - **Recommended:** **100 GB** or more

### **2. Microsoft Azure**

#### **Minimum GPU Requirements**

- **GPU Type:** NVIDIA T4 Tensor Core GPU
- **GPU Memory (VRAM):** 16 GB
- **System Memory (RAM):** At least 16 GB
- **Instance Type Example:** `Standard_NC4as_T4_v3`

#### **Recommended Disk Storage**

- **Disk Type:** Premium SSD Managed Disk
- **Disk Size:**
  - **Minimum:** **50 GB**
  - **Recommended:** **100 GB** or more

### **3. Amazon Web Services (AWS)**

#### **Minimum GPU Requirements**

- **GPU Type:** NVIDIA T4 GPU
- **GPU Memory (VRAM):** 16 GB
- **System Memory (RAM):** At least 16 GB
- **Instance Type Example:** `g4dn.xlarge`

#### **Recommended Disk Storage**

- **Disk Type:** Amazon EBS General Purpose SSD (`gp3`)
- **Disk Size:**
  - **Minimum:** **50 GB**
  - **Recommended:** **100 GB** or more

### **Additional Considerations Across All Platforms**

- **Model Size and Quantization:**
  - **Unquantized Models:** Require significant VRAM and system memory.
  - **Quantized Models:** Reduce memory and storage requirements.
- **System Memory (RAM):** At least 16 GB.
- **Performance Optimization:**
  - **Higher-Performance GPUs:** NVIDIA V100 or A100 for larger models.
  - **Faster Storage:** NVMe SSDs improve data access speeds.
- **Data Persistence and Backup:**
  - Use persistent storage options.
  - Regular backups.
- **Kubernetes Deployments:**
  - Use Persistent Volumes with appropriate Storage Classes.

**Summary**

For running `llama.cpp` on **GCP**, **Azure**, and **AWS**, the **minimum GPU requirement** is an **NVIDIA T4 GPU** with **16 GB VRAM**, paired with at least **16 GB of system RAM**. The **recommended disk storage** is an **SSD-based disk** with a **minimum size of 50 GB**, though **100 GB or more** is advisable.

---

## References

- [Sample Basic Compute Provider Build](https://github.com/MorpheusAIs/Docs/blob/main/!KEYDOCS%20README%20FIRST!/Compute%20Providers/Sample%20Basic%20Compute%20Provider%20Build.md)
- [Mac Boot Strap Guide](https://github.com/Lumerin-protocol/Morpheus-Lumerin-Node/blob/dev/docs/mac-boot-strap.md)
- [Provider Setup Documentation](https://github.com/Lumerin-protocol/Morpheus-Lumerin-Node/blob/dev/docs/02-provider-setup.md)

---

**Note:** For cleaning and troubleshooting, refer to the [Mac Boot Strap Guide](https://github.com/Lumerin-protocol/Morpheus-Lumerin-Node/blob/dev/docs/mac-boot-strap.md).
