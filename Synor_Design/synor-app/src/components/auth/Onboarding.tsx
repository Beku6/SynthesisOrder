import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { Calendar, CheckCircle, Bell, ArrowRight } from 'lucide-react';

const slides = [
  {
    headline: "Your academic life, finally organized.",
    subtext: "Synor keeps your schedule, tasks, reminders, and study flow in one place.",
    icon: <Calendar className="w-8 h-8 text-indigo-400" />
  },
  {
    headline: "Schedule, study, and routine — in one flow.",
    subtext: "Everything you need to succeed, seamlessly integrated.",
    icon: <CheckCircle className="w-8 h-8 text-violet-400" />
  },
  {
    headline: "Less chaos. More control.",
    subtext: "Focus on what matters. We'll handle the rest.",
    icon: <Bell className="w-8 h-8 text-blue-400" />
  }
];

export const Onboarding: React.FC<{ onComplete: () => void }> = ({ onComplete }) => {
  const [step, setStep] = useState(0);

  const nextStep = () => {
    if (step < slides.length - 1) {
      setStep(step + 1);
    } else {
      onComplete();
    }
  };

  return (
    <motion.div 
      initial={{ opacity: 0, y: 20 }}
      animate={{ opacity: 1, y: 0 }}
      exit={{ opacity: 0, y: -20, transition: { duration: 0.5 } }}
      className="absolute inset-0 bg-[#050505] z-[90] flex flex-col overflow-hidden"
    >
      {/* Background gradients & grid */}
      <div className="absolute inset-0 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] opacity-20 mix-blend-overlay pointer-events-none"></div>
      <div className="absolute inset-0 bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px] pointer-events-none"></div>
      <div className="absolute top-0 left-0 w-full h-1/2 bg-gradient-to-b from-indigo-900/20 to-transparent pointer-events-none" />
      <div className="absolute bottom-0 right-0 w-full h-1/2 bg-gradient-to-t from-violet-900/20 to-transparent pointer-events-none" />

      {/* Header with Skip */}
      <div className="flex justify-end p-6 relative z-20">
        <button 
          onClick={onComplete}
          className="text-sm font-medium text-neutral-400 hover:text-white transition-colors"
        >
          Skip
        </button>
      </div>

      <div className="flex-1 relative flex items-center justify-center">
        {/* Floating UI elements (abstract representation) */}
        <motion.div 
          animate={{ 
            y: [0, -10, 0], 
            rotate: [0, 2, 0],
            opacity: step === 0 ? 1 : 0.5,
            scale: step === 0 ? 1 : 0.9
          }} 
          transition={{ duration: 4, repeat: Infinity, ease: "easeInOut" }}
          className="absolute top-[15%] left-4 w-32 h-24 rounded-3xl bg-white/5 border border-white/10 backdrop-blur-xl shadow-[0_8px_32px_rgba(0,0,0,0.3)] flex items-center justify-center"
        >
          <div className="w-16 h-2 rounded-full bg-white/10" />
        </motion.div>
        <motion.div 
          animate={{ 
            y: [0, 15, 0], 
            rotate: [0, -3, 0],
            opacity: step === 1 ? 1 : 0.5,
            scale: step === 1 ? 1 : 0.9
          }} 
          transition={{ duration: 5, repeat: Infinity, ease: "easeInOut", delay: 1 }}
          className="absolute bottom-[20%] right-4 w-40 h-28 rounded-3xl bg-white/5 border border-white/10 backdrop-blur-xl shadow-[0_8px_32px_rgba(0,0,0,0.3)] flex flex-col gap-3 p-4 justify-center"
        >
          <div className="w-full h-2 rounded-full bg-white/10" />
          <div className="w-2/3 h-2 rounded-full bg-white/10" />
        </motion.div>
        
        <AnimatePresence mode="wait">
          <motion.div
            key={step}
            initial={{ opacity: 0, scale: 0.95 }}
            animate={{ opacity: 1, scale: 1 }}
            exit={{ opacity: 0, scale: 1.05 }}
            transition={{ duration: 0.4 }}
            className="relative z-10 flex flex-col items-center text-center px-8"
          >
            <div className="w-20 h-20 rounded-3xl bg-white/5 border border-white/10 flex items-center justify-center mb-8 shadow-[0_0_30px_rgba(255,255,255,0.05)]">
              {slides[step].icon}
            </div>
            <h2 className="text-3xl font-bold text-white tracking-tight mb-4 leading-tight">
              {slides[step].headline}
            </h2>
            <p className="text-lg text-neutral-400 max-w-xs">
              {slides[step].subtext}
            </p>
          </motion.div>
        </AnimatePresence>
      </div>

      <div className="p-8 pb-12 flex flex-col gap-6 relative z-10">
        <div className="flex justify-center gap-2 mb-4">
          {slides.map((_, i) => (
            <div 
              key={i} 
              className={`h-1.5 rounded-full transition-all duration-300 ${i === step ? 'w-8 bg-indigo-500' : 'w-2 bg-white/20'}`}
            />
          ))}
        </div>
        <button 
          onClick={nextStep}
          className="w-full py-4 rounded-2xl bg-gradient-to-r from-indigo-600 to-violet-600 text-white font-semibold text-lg flex items-center justify-center gap-2 shadow-[0_0_20px_rgba(79,70,229,0.3)] hover:shadow-[0_0_30px_rgba(79,70,229,0.5)] transition-all active:scale-[0.98]"
        >
          {step === slides.length - 1 ? 'Get Started' : 'Continue'}
          <ArrowRight className="w-5 h-5" />
        </button>
      </div>
    </motion.div>
  );
};
