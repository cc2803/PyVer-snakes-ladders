# 🎲 Snakes and Ladders (Python-Verilog FPGA Project)

This project is a digital recreation of the classic board game **Snakes and Ladders**, implemented using **Verilog (FSM)** for game logic and **Python (Pygame)** for a graphical interface. It showcases the integration of hardware design (HDL) with software visualization, ideal for understanding FPGA-based finite state machines in a fun, interactive way.

---


## 🎯 Objective

To simulate a single-player Snakes and Ladders game using:
- A **Finite State Machine (FSM)** written in **Verilog**
- A **graphical user interface** developed in **Python using Pygame**
- Real-time communication between Verilog output and Python interface via a text file

---

## ⚙️ Methodology

### FSM Design (Verilog)
- **States:**
  - `Idle` – Wait for dice roll
  - `Dice Roll` – Generate random number
  - `Player Move` – Move pawn
  - `Ladder Climb` – Move up ladder
  - `Snake Slide` – Slide down snake
  - `Win Condition` – Game end

- **Simulation Tools:** Vivado and icarus-verilog

### Python-Pygame Interface
- Reads state output from Verilog (via text file)
- Dynamically updates board and player position in real-time
- Ensures a smooth and interactive single-player experience

---

## 🖥️ Tools & Technologies

- **Languages:** Verilog HDL, Python 3.10+
- **IDE:** Visual Studio Code
- **Simulation:** Icarus Verilog (`iverilog`, `vvp`)
- **Graphics:** Pygame

---

## ✅ Key Features

- Real-time FSM-based state transitions
- Accurate dice roll and player movement logic
- Fully simulated Snakes and Ladders rules
- Pygame-powered graphical interface for board display
- Educational and demonstrative value in FPGA + Python integration

---

## 🔍 Future Possible Enhancements

- Add **multiplayer** support
- Improve **graphics** and add **sound effects**
- Deploy on a **physical FPGA board**
- Integrate an **AI opponent**

---

## 📜 License

This project is for academic use and demonstration purposes. Feel free to open a pull request or branch with any improvisations!

---

## 📂 How to Run

```bash
# Clone the repository
git clone https://github.com/cc2803/PyVer-snakes-ladders
cd PyVer-snakes-ladders

# Compile Verilog code
iverilog -o fsm_tb testbench.v fsm_org.v

# Run Verilog simulation
vvp fsm_tb

# (Optional) Run Python interface
python main.py
