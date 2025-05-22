/* ========== Stimulus Initialization ========== */
window.StimulusApp = Stimulus.Application.start();
console.log("🎛️  StimulusApp initialized:", window.StimulusApp);

/* ========== Controller Registration ========== */
const registerController = (name, ControllerClass) => {
  console.log(`🎯 Registering ${name} controller`);
  try {
    StimulusApp.register(name, ControllerClass);
  } catch (error) {
    console.error(`💥 ${name} registration failed:`, error);
  }
};
/* ========== Application Boot ========== */
console.log("🌱 Application.js loaded");
console.assert(window.StimulusApp, "StimulusApp not initialized!");
