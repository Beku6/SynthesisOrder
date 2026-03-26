import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { ArrowRight, ArrowLeft, User, Mail, Lock, Building2, GraduationCap, Bell, CalendarSync, MapPin } from 'lucide-react';

export const SignUp: React.FC<{ onComplete: () => void; onBack: () => void }> = ({ onComplete, onBack }) => {
  const [step, setStep] = useState(1);

  const nextStep = () => {
    if (step < 4) setStep(step + 1);
    else onComplete();
  };

  const prevStep = () => {
    if (step > 1) setStep(step - 1);
    else onBack();
  };

  return (
    <motion.div 
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20, transition: { duration: 0.3 } }}
      className="absolute inset-0 bg-[#050505] z-[90] flex flex-col px-6 py-8 overflow-hidden"
    >
      {/* Background gradients & grid */}
      <div className="absolute inset-0 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] opacity-20 mix-blend-overlay pointer-events-none"></div>
      <div className="absolute inset-0 bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px] pointer-events-none"></div>
      <div className="absolute top-0 left-0 w-full h-1/2 bg-gradient-to-b from-indigo-900/10 to-transparent pointer-events-none" />

      <div className="flex items-center mb-8 relative z-10">
        <button onClick={prevStep} className="p-2 -ml-2 rounded-full hover:bg-white/10 text-white transition-colors">
          <ArrowLeft className="w-6 h-6" />
        </button>
        <div className="flex-1 flex justify-center gap-2 pr-6">
          {[1, 2, 3, 4].map(i => (
            <div key={i} className={`h-1.5 rounded-full transition-all duration-300 ${i <= step ? 'w-8 bg-indigo-500' : 'w-4 bg-white/20'}`} />
          ))}
        </div>
      </div>

      <div className="flex-1 flex flex-col max-w-md w-full mx-auto relative z-10">
        <AnimatePresence mode="wait">
          {step === 1 && (
            <motion.div key="step1" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }} className="flex flex-col h-full">
              <div className="mb-8">
                <h1 className="text-3xl font-bold text-white tracking-tight mb-2">Create your account</h1>
                <p className="text-neutral-400">Let's start with your basic identity.</p>
              </div>
              <div className="flex flex-col gap-4">
                <div className="relative group">
                  <div className="absolute inset-y-0 left-4 flex items-center pointer-events-none">
                    <User className="w-5 h-5 text-neutral-500 group-focus-within:text-indigo-400 transition-colors" />
                  </div>
                  <input type="text" placeholder="Full Name" className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all" />
                </div>
                <div className="relative group">
                  <div className="absolute inset-y-0 left-4 flex items-center pointer-events-none">
                    <Mail className="w-5 h-5 text-neutral-500 group-focus-within:text-indigo-400 transition-colors" />
                  </div>
                  <input type="email" placeholder="Email Address" className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all" />
                </div>
                <div className="relative group">
                  <div className="absolute inset-y-0 left-4 flex items-center pointer-events-none">
                    <Lock className="w-5 h-5 text-neutral-500 group-focus-within:text-indigo-400 transition-colors" />
                  </div>
                  <input type="password" placeholder="Create Password" className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all" />
                </div>
              </div>
            </motion.div>
          )}

          {step === 2 && (
            <motion.div key="step2" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }} className="flex flex-col h-full">
              <div className="mb-8">
                <h1 className="text-3xl font-bold text-white tracking-tight mb-2">Academic setup</h1>
                <p className="text-neutral-400">Tell us where and what you study.</p>
              </div>
              <div className="flex flex-col gap-4">
                <div className="relative group">
                  <div className="absolute inset-y-0 left-4 flex items-center pointer-events-none">
                    <Building2 className="w-5 h-5 text-neutral-500 group-focus-within:text-indigo-400 transition-colors" />
                  </div>
                  <input type="text" placeholder="University" defaultValue="Abai University" className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all" />
                </div>
                <div className="relative group">
                  <div className="absolute inset-y-0 left-4 flex items-center pointer-events-none">
                    <GraduationCap className="w-5 h-5 text-neutral-500 group-focus-within:text-indigo-400 transition-colors" />
                  </div>
                  <input type="text" placeholder="Faculty / Department" className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all" />
                </div>
                <div className="flex gap-4">
                  <input type="text" placeholder="Course Year" className="w-1/2 bg-white/5 border border-white/10 rounded-2xl py-4 px-4 text-white placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all" />
                  <input type="text" placeholder="Group" className="w-1/2 bg-white/5 border border-white/10 rounded-2xl py-4 px-4 text-white placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all" />
                </div>
              </div>
            </motion.div>
          )}

          {step === 3 && (
            <motion.div key="step3" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }} className="flex flex-col h-full">
              <div className="mb-8">
                <h1 className="text-3xl font-bold text-white tracking-tight mb-2">Personalize your flow</h1>
                <p className="text-neutral-400">This helps Synor personalize your schedule, reminders, and study experience.</p>
              </div>
              <div className="flex flex-col gap-4">
                <div className="p-4 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-between">
                  <div>
                    <h3 className="text-white font-medium">Campus Preferences</h3>
                    <p className="text-sm text-neutral-400">Main Building</p>
                  </div>
                  <MapPin className="w-5 h-5 text-indigo-400" />
                </div>
                <div className="p-4 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-between">
                  <div>
                    <h3 className="text-white font-medium">Study Mode</h3>
                    <p className="text-sm text-neutral-400">Deep Focus</p>
                  </div>
                  <div className="w-10 h-6 rounded-full bg-indigo-500 relative">
                    <div className="absolute right-1 top-1 w-4 h-4 rounded-full bg-white" />
                  </div>
                </div>
              </div>
            </motion.div>
          )}

          {step === 4 && (
            <motion.div key="step4" initial={{ opacity: 0, x: 20 }} animate={{ opacity: 1, x: 0 }} exit={{ opacity: 0, x: -20 }} className="flex flex-col h-full">
              <div className="mb-8">
                <h1 className="text-3xl font-bold text-white tracking-tight mb-2">Turn on smart features</h1>
                <p className="text-neutral-400">Enable these to get the full Synor experience.</p>
              </div>
              <div className="flex flex-col gap-4">
                <div className="p-4 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-xl bg-indigo-500/20 flex items-center justify-center">
                      <Bell className="w-5 h-5 text-indigo-400" />
                    </div>
                    <div>
                      <h3 className="text-white font-medium">Smart Notifications</h3>
                      <p className="text-sm text-neutral-400">Get alerts for classes & tasks</p>
                    </div>
                  </div>
                  <div className="w-10 h-6 rounded-full bg-indigo-500 relative">
                    <div className="absolute right-1 top-1 w-4 h-4 rounded-full bg-white" />
                  </div>
                </div>
                <div className="p-4 rounded-2xl bg-white/5 border border-white/10 flex items-center justify-between">
                  <div className="flex items-center gap-3">
                    <div className="w-10 h-10 rounded-xl bg-violet-500/20 flex items-center justify-center">
                      <CalendarSync className="w-5 h-5 text-violet-400" />
                    </div>
                    <div>
                      <h3 className="text-white font-medium">Calendar Sync</h3>
                      <p className="text-sm text-neutral-400">Connect your personal calendar</p>
                    </div>
                  </div>
                  <div className="w-10 h-6 rounded-full bg-indigo-500 relative">
                    <div className="absolute right-1 top-1 w-4 h-4 rounded-full bg-white" />
                  </div>
                </div>
              </div>
            </motion.div>
          )}
        </AnimatePresence>

        <div className="mt-auto pt-8">
          <button 
            onClick={nextStep}
            className="w-full py-4 rounded-2xl bg-gradient-to-r from-indigo-600 to-violet-600 text-white font-semibold text-lg flex items-center justify-center gap-2 shadow-[0_0_20px_rgba(79,70,229,0.3)] hover:shadow-[0_0_30px_rgba(79,70,229,0.5)] transition-all active:scale-[0.98]"
          >
            {step === 4 ? 'Complete Setup' : 'Continue'}
            <ArrowRight className="w-5 h-5" />
          </button>
        </div>
      </div>
    </motion.div>
  );
};
