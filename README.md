# 📚 Smart Library – Digital Quantum Mapping (DQM)
### Intelligent Environmental Protection System for Modern Libraries  
**Author:** Muhammad Yusron Maskur  
**Institution:** Institut Teknologi Sepuluh Nopember (ITS)  
**Course:** Elektronika Digital (ELDIG)  
**Year:** 2025  

---

## 📌 Overview
Smart Library – Digital Quantum Mapping (DQM) adalah sistem otomasi lingkungan berbasis sensor yang dirancang untuk melindungi koleksi perpustakaan dari ancaman seperti:

- Kebakaran (fire propagation)
- Kenaikan suhu ekstrem
- Gas berbahaya / asap (smoke)
- Kualitas udara buruk (PM2.5, VOC)
- Polusi suara
- Ketidaknyamanan ruang

Proyek ini mencakup desain *multi-sensor embedded system*, **quantization pipeline**, **Boolean logic**, **truth table**, **Finite State Machine (FSM)**, **gate-level mapping**, hingga **implementasi HDL (VHDL/SystemVerilog)** dan **C# software model**.

Proyek ini disusun sebagai bagian dari *Step-by-Step Engineering Workflow* Digital Quantum Mapping.

---

# 🧠 Project Roadmap (DQM Workflow)

## **Step 1 — Sensor Quantization & Digital Mapping**
- Mendefinisikan pemetaan sensor → sinyal digital:  
  `T_high`, `R_rise`, `S_smoke`, `P_high`, `G_high`, `N_noise`
- Thresholding, hysteresis, confirmation windows
- Safety interlocks
- Representasi aktuator (Sprinkler, Fan, Purifier, Alarm, Buzzer)
- Output dari Step 1 → *Digital Signal Dictionary*

📄 **File terkait:**  
`docs/step1_quantization.pdf` (opsional)  
`src/quantizer.cs`

---

## **Step 2 — Truth Tables & Boolean Equation**
- Penyederhanaan logika menggunakan AND/OR/NOT  
- Konstruksi tabel keputusan untuk:
  - Fire subsystem
  - Air quality subsystem
  - Noise subsystem
- Boolean minimization (K-map optional)
- Priority arbitration rules  

📄 **File terkait:**  
`docs/step2_truth_table.pdf`

---

## **Step 3 — Finite State Machine (FSM) Design**
FSM utama memiliki state:
- `S_NORMAL`
- `S_WARNING`
- `S_ALERT`
- `S_EMERGENCY` (latched)

Mendukung event:
`e_pm`, `e_smoke`, `e_temp`, `e_clear`, `e_reset`

Dilengkapi:
- Output per-state  
- Interlock rules  
- Transition diagram  

📄 **File terkait:**  
`src/fsm.vhd`  
`src/fsm.sv`  
`src/fsm_diagram.png`

---

## **Step 4 — System Architecture & Electronics**
- Block diagram  
- Power domain separation  
- Sensor synchronizers  
- MCU/FPGA interface  
- Actuator driver stages (relay, MOSFET, solenoid)  
- Safety & fail-safe design  

📄 **File terkait:**  
`docs/step4_architecture.pdf`

---

## **Step 5 — Flip-Flop Usage & Clocking Strategy**
Menjelaskan:
- FF untuk FSM state register  
- Synchronizer flip-flops untuk I2S/UART/ADC signals  
- T-FF & counters untuk PWM / buzzer tone  
- Timing constraints  

📄 **File terkait:**  
`docs/step5_flipflops.pdf`

---

## **Step 6 — Gate-Level Mapping**
- Implementasi dengan universal gates (NAND/NOR only)  
- Safety-critical logic mapping  
- Mapping FSM equations ke jaringan gerbang  

📄 **File terkait:**  
`src/gate_level_nand.sv`  
`src/gate_level_nor.sv`

---

## **Step 7 — Logic Block Diagram**
Diagram blok logika lengkap berdasarkan Boolean mapping + FSM transitions.  
Termasuk:
- Fire protection logic block  
- Air quality logic block  
- Arbitration logic  
- Sprinkler interlock network  

📷 **File terkait:**  
`assets/logic_block_diagram.png`  
`src/step7_diagram.tex` (LaTeX)

---

## **Step 8 — Implementation Layer (HDL & C#)**

### 🖥️ **HDL Implementation (VHDL/SystemVerilog)**
Terdiri atas:
- `SmartLibraryCore.vhd`
- `SmartLibraryCore.sv`
- Testbench untuk EDA Playground:
  - `design.sv`
  - `testbench.sv`

### 💻 **C# Software Model**
Software reference model mencerminkan seluruh logika DQM:
- Quantization  
- FSM transitions  
- Safety rules  
- Actuator outputs  
- Event logging system  

📄 **File terkait:**  
`src/SmartLibraryController.cs`  
`src/Program.cs`

---

# 🚀 Features
- 🔥 Deteksi kebakaran multi-sensor (temp, smoke, rate-of-rise)
- 🌫️ Air quality monitoring (PM2.5, VOC)
- 🔊 Noise event alert
- 🔍 Real-time quantization pipeline
- 🧮 Deterministic logic (Boolean)
- 🔄 State machine with latching safety mode
- 🧱 NAND/NOR universal-gate realisation
- 💾 Log system & event tracking
- 🧪 Testbench HDL ready for simulation in EDA Playground
- 💻 C# engine ready for PC/IoT deployment

---

# 🧪 Simulation
## ▶ HDL Simulation  
Gunakan EDA Playground:

- **SystemVerilog version**  
  - `design.sv`  
  - `testbench.sv`  
  - Top entity: `tb`  

- **VHDL version**  
  - `design.vhd`  
  - `testbench.vhd`  
  - Top entity: `tb_SmartLibraryCore`  

## ▶ C# Simulation (Console)
Jalankan:

