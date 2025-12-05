# 📚 Smart Library – Digital Quantum Mapping (DQM)
### Intelligent Environmental Protection System for Modern Libraries  
**Author:** Muhammad Yusron Maskur  
**Institution:** Institut Teknologi Sepuluh Nopember (ITS)  
**Course:** Elektronika Digital (ELDIG)  
**Year:** 2025  

---

## 📌 Overview
Smart Library – Digital Quantum Mapping (DQM) adalah sistem otomasi berbasis multi-sensor yang dirancang untuk melindungi lingkungan perpustakaan dari ancaman seperti suhu ekstrem, asap/gas berbahaya, kebakaran, kualitas udara buruk, dan kebisingan.

DQM menggunakan pendekatan bertahap mulai dari **Quantization**, **Boolean Logic**, **Truth Table**, **FSM**, **Gate Mapping**, hingga **implementasi HDL (VHDL/SV)** dan **C# Software Model** sebagai reference engine.

---

# 🧠 Project Roadmap (DQM Workflow)

## **Step 1 — Sensor Quantization & Mapping**
Menentukan sinyal digital hasil pemetaan sensor:
- `T_high`, `R_rise`, `S_smoke`
- `P_high` (PM2.5), `G_high` (Gas VOC)
- `N_noise` (Noise threshold)

Termasuk:
- Thresholding  
- Hysteresis  
- Confirmation windows  
- Safety interlocks

---

## **Step 2 — Truth Tables & Boolean Logic**
- Truth table untuk Fire, Air Quality, dan Noise subsystem  
- Penyederhanaan Boolean  
- Arbitration logic  
- Interlock rules

---

## **Step 3 — Finite State Machine (FSM)**
State utama:
- `S_NORMAL`
- `S_WARNING`
- `S_ALERT`
- `S_EMERGENCY` (latched)

Dengan event:
`e_temp`, `e_smoke`, `e_pm`, `e_clear`, `e_reset`

---

## **Step 4 — System Architecture**
- Block diagram  
- Sensor synchronisers  
- Driver actuator (relay/solenoid)  
- Power domain separation  
- Fail-safe design  

---

## **Step 5 — Flip-Flop Usage**
- FF untuk FSM register  
- D-FF untuk synchronizer  
- T-FF/counter untuk PWM fan & buzzer  
- Timing constraints  

---

## **Step 6 — Gate-Level Mapping**
Implementasi menggunakan universal gates:
- NAND-only realization  
- NOR-only realization  
- Combinational gate mapping dari Boolean Step 2  
- State transition logic  

---

## **Step 7 — Logic Block Diagram**
Meliputi:
- Fire logic network  
- Air quality logic network  
- Arbitration block  
- Sprinkler interlock  

`assets/logic_block_diagram.png`

---

## **Step 8 — Implementation Layer (HDL + C#)**

### 🔶 HDL Implementation
File HDL:
- `design.sv`
- `testbench.sv`
- `design.vhd`
- `testbench.vhd`

Dapat diuji pada:
- EDA Playground  
- ModelSim  
- Riviera-PRO  
- GHDL  

### 🔷 C# Reference Implementation
Engine software untuk:
- Firmware IoT  
- PC simulator  
- Supervisory console  

File:
- `SmartLibraryController.cs`  
- `Program.cs`  

Termasuk:
- Event logging system  
- FSM behaviour  
- Actuator output simulator  

---

# 🚀 Features
- 🔥 Fire detection multi-sensor  
- 🌫️ Air quality monitoring (PM2.5, VOC)  
- 🔊 Noise threshold detection  
- 🤖 Digital quantization engine  
- 🔄 Deterministic FSM transitions  
- 🧱 Universal gate mapping (NAND/NOR)  
- 🧪 HDL simulation-ready  
- 💻 C# model for algorithm verification  

---

# 🧪 HDL Simulation Guide
Gunakan EDA Playground → SystemVerilog/VHDL:

### SystemVerilog
