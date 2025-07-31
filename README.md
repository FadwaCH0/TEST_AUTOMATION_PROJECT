# 🚀 Test Automation Project - Todo Application


## 📋 Table of Contents

- [🎯 Project Objective](#-project-objective)
- [🛠️ Technologies Used](#️-technologies-used)
- [🏗️ Project Architecture](#️-project-architecture)
- [⚡ Installation and Setup](#-installation-and-setup)
- [🚀 Running the Project](#-running-the-project)
- [🧪 Automated Tests](#-automated-tests)
- [📊 Test Reports](#-test-reports)
- [📚 Documentation](#-documentation)

---

## 🎯 Project Objective

This project demonstrates a **comprehensive test automation strategy** for a modern web application. It showcases testing best practices through:

### 🎪 **Features Covered:**
- ✅ **REST API Testing** (Complete CRUD)
- ✅ **User Interface Testing** (E2E)
- ✅ **Authentication Testing** (Login/Logout)
- ✅ **Validation Testing** (Positive and Negative cases)
- ✅ **Detailed Reports** (HTML, XML, Coverage)

### 🏆 **Learning Objectives:**
- Demonstrate implementation of a complete **test pyramid**
- Illustrate integration between **API and UI tests**
- Present **best practices** for test automation
- Provide a **reusable template** for other projects

---

## 🛠️ Technologies Used

### 🎨 **Frontend**
- **React 18** - Modern JavaScript framework
- **React Router** - Client-side navigation
- **Axios** - HTTP client for API calls
- **CSS3** - Advanced styling with animations

### 🔧 **Backend**
- **Node.js** - JavaScript runtime
- **Express.js** - Minimal web framework
- **JWT** - Token-based authentication
- **bcryptjs** - Password hashing
- **express-validator** - Data validation

### 🤖 **Tests**
- **Robot Framework** - Test automation framework
- **SeleniumLibrary** - Browser interaction
- **RequestsLibrary** - API testing from Robot Framework
- **ChromeDriver** - Chrome browser driver


## 🏗️ Project Architecture

```
test-automation-project/
├── 📁 backend/                 # Node.js + Express API
│   ├── server.js              # Main server
│   ├── package.json           # Backend dependencies
│   
│
├── 📁 frontend/               # React application
│   ├── src/                   # React source code
│   │   ├── App.jsx           # Main component
│   │   ├── App.css           # Advanced styles
│   │   └── components/       # React components
│   │       ├── Login.jsx     # Login page
│   │       └── TodoList.jsx  # Todo management
│   └── package.json          # Frontend dependencies
│
├── 📁 tests/                  # Test automation
│   └── robot/                # Robot Framework tests
│       ├── resources/        # Keywords and variables
│       │   ├── keywords.robot
│       │   └── variables.robot
│       ├── ui/               # UI tests
│       │   ├── 01_login_tests.robot
│       │   ├── 02_todo_crud_tests.robot
│       │   └── 03_error_handling_tests.robot
│       ├── api/              # API tests
│       │   └── api_test.robot
│       └── results/          # Generated reports
│

│
├── setup.bat           # Initial setup

│── run_tests.bat        # Test execution
│  
│
└── 📄 README.md              # Main documentation
```

---

## ⚡ Installation and Setup

### 📋 **Prerequisites**

- **Node.js** (v16+) - [Download](https://nodejs.org/)
- **Python** (v3.8+) - [Download](https://python.org/)
- **Git** - [Download](https://git-scm.com/)
- **Chrome** - [Download](https://www.google.com/chrome/)

### 🔧 **Automated Installation**

```bash
# 1. Clone the repository
git clone 
cd test-automation-project

# 2. Run automated setup
## Windows
./setup.bat

## Linux/macOS
chmod +x ./setup.sh
./setup.sh
```

### 🔧 **Manual Installation**

<details>
<summary>Click to see manual installation</summary>

```bash
# 1. Backend Setup
cd backend
npm install

# 2. Frontend Setup  
cd ../frontend
npm install

# 3. Python Setup (Robot Framework)
python -m venv robot-env

# Windows
robot-env\activate
# Linux/macOS
source robot-env/bin/activate

# Install Robot Framework dependencies
pip install robotframework
pip install robotframework-seleniumlibrary
pip install robotframework-requests
pip install webdriver-manager
```

</details>

---

## 🚀 Running the Project

### 🎮 **Quick Start**

```bash
# Option 1: Automated script (Recommended)
./run_tests.bat

# Option 2: Manual server startup
# Terminal 1 - Backend
cd backend
npm start

# Terminal 2 - Frontend  
cd frontend
npm run dev

# Terminal 3 - Tests (after activating Python environment)
robot --outputdir tests/results tests/robot/
```

### 🌐 **Application Access**

| Service | URL | Description |
|---------|-----|-------------|
| **Frontend** | http://localhost:5173 | React user interface |
| **Backend API** | http://localhost:5000 | Node.js REST API |
| **Health Check** | http://localhost:5000/health | Server verification |

### 🔐 **Test Credentials**

```
Username: testuser
Password: password
```

---

## 🧪 Automated Tests

### 📊 **Testing Strategy**

```

### 🔬 **API Tests (Backend)**

**Framework:** robotframework  

#### **Tested Scenarios:**
- ✅ POST `/api/auth/login` - Authentication
- ✅ GET `/api/todos` - Retrieve todos
- ✅ POST `/api/todos` - Create todo
- ✅ PUT `/api/todos/:id` - Update todo  
- ✅ DELETE `/api/todos/:id` - Delete todo
- ✅ Input data validation
- ✅ HTTP error handling (400, 401, 404, 500)

```bash
# Run API tests
cd backend
npm test

# Tests with coverage
npm run test:coverage
```

### 🖥️ **UI Tests (Frontend)**

**Framework:** Robot Framework + SeleniumLibrary  
**Location:** `tests/robot/ui/`

#### **UI Test Coverage:**

| **Test Suite** | **File** | **Scenarios** |
|-------------------|-------------|---------------|
| **🔑 Authentication** | `01_login_tests.robot` | 6 tests |
| **📋 CRUD Todos** | `02_todo_crud_tests.robot` | 8 tests |
| **⚠️ Error Handling** | `03_error_handling_tests.robot` | 3 tests |

#### **E2E Scenarios Tested:**

**🔑 Authentication Tests:**
- ✅ Correct login page display
- ✅ Login with valid credentials
- ✅ Login failure with invalid credentials
- ✅ Empty field validation
- ✅ Functional logout
- ✅ Authenticated user redirection

**📋 CRUD Todo Tests:**
- ✅ Todo list display
- ✅ Add new todo
- ✅ Prevent empty todo addition
- ✅ Toggle completion status
- ✅ Edit todo title
- ✅ Cancel edit operation
- ✅ Delete todo
- ✅ Cancel delete operation

**⚠️ Navigation Tests:**
- ✅ Redirect unauthenticated users
- ✅ Page navigation
- ✅ Graceful API error handling

```bash
# Run UI tests
robot --outputdir tests/robot/results tests/robot/ui/

# Tests with specific tags
robot --include smoke tests/robot/
robot --include positive tests/robot/
```

```bash
# API tests with Robot Framework
robot --outputdir tests/robot/results tests/robot/api/

# Combined tests (API + UI)
robot --outputdir tests/robot/results tests/robot/
```

---

## 📊 Test Reports

### 📈 **Generated Report Types**

| **Type** | **Location** | **Description** |
|----------|------------------|-----------------|
| **🎯 HTML Report** | `tests/robot/results/report.html` | Test results overview |
| **📝 Detailed Log** | `tests/robot/results/log.html` | Step-by-step logs with screenshots |
| **📄 XML Data** | `tests/robot/results/output.xml` | Raw data for CI/CD |
| **📊 API Coverage** | `backend/coverage/` | Backend code coverage |

### 🎨 **Sample Metrics**

```
📊 Test Results (Last Execution)
════════════════════════════════════════════

✅ Backend API Tests    : 11/11 PASSED (100%)
✅ Frontend UI Tests    : 18/18 PASSED (100%) 

```

### 📱 **Report Visualization**

```bash
# Automatically open reports after tests
./scripts/run_tests.bat
# → Automatically opens report.html in browser

# Or manually
start tests/robot/results/report.html  # Windows
open tests/robot/results/report.html   # macOS
xdg-open tests/robot/results/report.html # Linux
```

---

#### **Tested Environments:**
- 🌐 **Browsers:** Chrome Headless
- 📦 **Node.js:** Version 18
- 🐍 **Python:** Version 3.11


### 🆘 **Troubleshooting**

<details>
<summary><strong>❓ UI tests fail with timeouts</strong></summary>

```bash
# 1. Verify servers are running
curl http://localhost:5000/health
curl http://localhost:5173

# 2. Update ChromeDriver
pip install webdriver-manager --upgrade

# 3. Increase timeouts in variables.robot
${MEDIUM_TIMEOUT}     20s
${LONG_TIMEOUT}       60s
```

</details>

<details>
<summary><strong>🔧 Dependency installation errors</strong></summary>

```bash
# 1. Clear caches
npm cache clean --force
pip cache purge

# 2. Remove and reinstall
rm -rf node_modules package-lock.json
npm install

# 3. Check versions
node --version  # v16+
python --version # v3.8+
```

</details>

<details>
<summary><strong>🌐 Ports already in use</strong></summary>

```bash
# Find processes using ports
netstat -ano | findstr :5000
netstat -ano | findstr :5173

# Kill processes
taskkill /PID <PID> /F

# Or change ports in configurations
```

</details>
