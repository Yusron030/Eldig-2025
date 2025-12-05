using System;
using System.Collections.Generic;

namespace SmartLibraryDQM
{
    public enum FireState { Safe, Warning, Fire }

    public enum SystemEventType
    {
        Info,
        Warning,
        Alert,
        Emergency
    }

    public class SystemEvent
    {
        public DateTime Time { get; set; } = DateTime.Now;
        public string Message { get; set; }
        public SystemEventType Type { get; set; }

        public override string ToString()
            => $"[{Time:HH:mm:ss}] [{Type}] {Message}";
    }


    // ====================================================================
    // DIGITAL QUANTUM MAPPING CONTROLLER (FULL VERSION)
    // ====================================================================
    public class SmartLibraryController
    {
        // FSM State
        public FireState FireState { get; private set; } = FireState.Safe;

        // Sensor Inputs
        public double Temperature { get; set; }
        public double TemperatureRate { get; set; }
        public double GasLevel { get; set; }
        public double DustPM25 { get; set; }
        public double NoiseDb { get; set; }

        // Binary Quantized Values
        public bool T_High   => Temperature >= 60;
        public bool R_Rise   => TemperatureRate >= 8;
        public bool S_Smoke  => GasLevel >= 0.85;
        public bool P_High   => DustPM25 >= 35;
        public bool G_High   => GasLevel >= 0.75;
        public bool N_Noise  => NoiseDb >= 85;

        // Actuators
        public bool Sprinkler  { get; private set; }
        public bool Alarm      { get; private set; }
        public bool FanFire    { get; private set; }
        public bool FanAir     { get; private set; }
        public bool Purifier   { get; private set; }
        public bool Buzzer     { get; private set; }

        // Event log
        public List<SystemEvent> Log { get; private set; } = new List<SystemEvent>();


        // ============================================================
        // UPDATE ENGINE
        // ============================================================
        public void Update(bool reset = false)
        {
            if (reset)
            {
                ResetSystem();
                AddEvent("System reset performed.", SystemEventType.Info);
                return;
            }

            bool fireAny = T_High || R_Rise || S_Smoke;
            bool fireInter = S_Smoke && (T_High || R_Rise);
            bool airDirty = P_High || G_High;

            // FSM TRANSITIONS
            switch (FireState)
            {
                case FireState.Safe:
                    if (fireInter)
                    {
                        FireState = FireState.Fire;
                        AddEvent("Critical fire detected.", SystemEventType.Emergency);
                    }
                    else if (fireAny)
                    {
                        FireState = FireState.Warning;
                        AddEvent("Fire warning detected.", SystemEventType.Warning);
                    }
                    break;

                case FireState.Warning:
                    if (fireInter)
                    {
                        FireState = FireState.Fire;
                        AddEvent("Fire escalation to EMERGENCY.", SystemEventType.Emergency);
                    }
                    else if (!fireAny)
                    {
                        FireState = FireState.Safe;
                        AddEvent("Fire warning cleared.", SystemEventType.Info);
                    }
                    break;

                case FireState.Fire:
                    // latch mode
                    break;
            }

            // OUTPUT LOGIC
            ClearOutputs();

            // Noise
            Buzzer = N_Noise;
            if (N_Noise)
                AddEvent("Noise threshold exceeded.", SystemEventType.Warning);

            switch (FireState)
            {
                case FireState.Warning:
                    Alarm = true;
                    FanFire = true;
                    break;

                case FireState.Fire:
                    Alarm = true;
                    FanFire = true;
                    Sprinkler = true;
                    break;
            }

            // Air Quality
            if (!Sprinkler && airDirty)
            {
                FanAir = true;
                Purifier = true;

                AddEvent("Air quality deteriorated.", SystemEventType.Warning);
            }
        }


        private void ResetSystem()
        {
            FireState = FireState.Safe;
            ClearOutputs();
        }

        private void ClearOutputs()
        {
            Sprinkler = false;
            Alarm = false;
            FanFire = false;
            FanAir = false;
            Purifier = false;
            Buzzer = false;
        }

        private void AddEvent(string msg, SystemEventType type)
        {
            Log.Add(new SystemEvent { Message = msg, Type = type });
        }

        public void PrintStatus()
        {
            Console.WriteLine("=== SMART LIBRARY STATUS ===");
            Console.WriteLine($"State: {FireState}");
            Console.WriteLine($"Temperature: {Temperature}°C (High? {T_High})");
            Console.WriteLine($"Gas: {GasLevel} (Smoke? {S_Smoke})");
            Console.WriteLine($"PM2.5: {DustPM25} (High? {P_High})");
            Console.WriteLine();
            Console.WriteLine($"Sprinkler: {Sprinkler}");
            Console.WriteLine($"Alarm: {Alarm}");
            Console.WriteLine($"FanFire: {FanFire}");
            Console.WriteLine($"FanAir: {FanAir}");
            Console.WriteLine($"Purifier: {Purifier}");
            Console.WriteLine($"Buzzer: {Buzzer}");
            Console.WriteLine("============================");
        }
    }
}
