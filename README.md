# vyapar_new
What Smart Vyapar Does
Smart Vyapar is a hands-free AI operating system for Kirana shopkeepers and traders, powered by voice in Hindi/Hinglish.

Voice-Controlled Ledger: Say "Ramesh ke naam pe 500 rupay likh do" to instantly update Udhaari (credit) records in the database.

AI-Powered OCR Bill Scanning: Voice command "Bill scan karo" triggers camera, reads invoice, and auto-updates inventory.

B2B Networking: Matches new traders with shopkeepers for better rates, breaking "who knows whom" barriers.

Logistics Tracking: GPS verifies shop location on voice trigger for deliveries.

Context-Aware Memory: Remembers recent actions (e.g., "Iska total kya hai?" refers to the last scanned bill).

Always-On Overlay: Floating widget accessible even on locked screen.

How We Built It
Built with Flutter for seamless Android/iOS experience, deeply integrated with Google Generative AI.

Core AI: Gemini 3.0 Flash for low-latency voice processing and multimodal inputs.

Function Calling: Custom Dart tools like startOCRScan() and updateShopkeeperLocation() executed by Gemini's intent detection.

State Injection: AppStateManager feeds real-time context (inventory, user) into every AI prompt for memory.

Overlay System: Android SYSTEM_ALERT_WINDOW permission for persistent voice UI.

Overcame Challenges: Fixed google_generative_ai v0.4.7+ schema issues, background lifecycle crashes, and context loss via feedback loops
