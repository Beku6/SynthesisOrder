import React from 'react';
import { motion } from 'motion/react';
import { Mail, Lock } from 'lucide-react';

export const SignIn: React.FC<{ onSignIn: () => void; onSignUp: () => void }> = ({ onSignIn, onSignUp }) => {
  return (
    <motion.div 
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20, transition: { duration: 0.3 } }}
      className="absolute inset-0 bg-[#050505] z-[90] flex flex-col px-6 py-12 overflow-hidden"
    >
      {/* Background gradients & grid */}
      <div className="absolute inset-0 bg-[url('https://grainy-gradients.vercel.app/noise.svg')] opacity-20 mix-blend-overlay pointer-events-none"></div>
      <div className="absolute inset-0 bg-[linear-gradient(to_right,#80808012_1px,transparent_1px),linear-gradient(to_bottom,#80808012_1px,transparent_1px)] bg-[size:24px_24px] pointer-events-none"></div>
      <div className="absolute top-0 left-0 w-full h-1/2 bg-gradient-to-b from-indigo-900/10 to-transparent pointer-events-none" />

      <div className="flex-1 flex flex-col justify-center max-w-md w-full mx-auto relative z-10">
        <div className="mb-12">
          <div className="w-12 h-12 rounded-xl bg-gradient-to-br from-indigo-500 to-violet-600 flex items-center justify-center mb-6 shadow-[0_0_20px_rgba(99,102,241,0.3)]">
            <span className="text-xl font-bold text-white tracking-tighter">S</span>
          </div>
          <h1 className="text-3xl font-bold text-white tracking-tight mb-2">Welcome back</h1>
          <p className="text-neutral-400">Sign in to access your schedule, study hub, and smart routine.</p>
        </div>

        <div className="flex flex-col gap-4 mb-8">
          <div className="relative group">
            <div className="absolute inset-y-0 left-4 flex items-center pointer-events-none">
              <Mail className="w-5 h-5 text-neutral-500 group-focus-within:text-indigo-400 transition-colors" />
            </div>
            <input 
              type="email" 
              placeholder="Student ID / Email" 
              className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all"
            />
          </div>
          <div className="relative group">
            <div className="absolute inset-y-0 left-4 flex items-center pointer-events-none">
              <Lock className="w-5 h-5 text-neutral-500 group-focus-within:text-indigo-400 transition-colors" />
            </div>
            <input 
              type="password" 
              placeholder="Password" 
              className="w-full bg-white/5 border border-white/10 rounded-2xl py-4 pl-12 pr-4 text-white placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 focus:bg-white/10 transition-all"
            />
          </div>
          <div className="flex justify-end">
            <button className="text-sm text-indigo-400 hover:text-indigo-300 transition-colors">
              Forgot password?
            </button>
          </div>
        </div>

        <button 
          onClick={onSignIn}
          className="w-full py-4 rounded-2xl bg-gradient-to-r from-indigo-600 to-violet-600 text-white font-semibold text-lg flex items-center justify-center gap-2 shadow-[0_0_20px_rgba(79,70,229,0.3)] hover:shadow-[0_0_30px_rgba(79,70,229,0.5)] transition-all active:scale-[0.98] mb-6"
        >
          Sign In
        </button>

        <div className="relative flex items-center py-4 mb-6">
          <div className="flex-grow border-t border-white/10"></div>
          <span className="flex-shrink-0 mx-4 text-neutral-500 text-sm">or</span>
          <div className="flex-grow border-t border-white/10"></div>
        </div>

        <button className="w-full py-4 rounded-2xl bg-white/5 border border-white/10 text-white font-medium flex items-center justify-center gap-3 hover:bg-white/10 transition-colors active:scale-[0.98]">
          <svg className="w-5 h-5" viewBox="0 0 24 24">
            <path fill="currentColor" d="M22.56 12.25c0-.78-.07-1.53-.2-2.25H12v4.26h5.92c-.26 1.37-1.04 2.53-2.21 3.31v2.77h3.57c2.08-1.92 3.28-4.74 3.28-8.09z" />
            <path fill="#34A853" d="M12 23c2.97 0 5.46-.98 7.28-2.66l-3.57-2.77c-.98.66-2.23 1.06-3.71 1.06-2.86 0-5.29-1.93-6.16-4.53H2.18v2.84C3.99 20.53 7.7 23 12 23z" />
            <path fill="#FBBC05" d="M5.84 14.09c-.22-.66-.35-1.36-.35-2.09s.13-1.43.35-2.09V7.07H2.18C1.43 8.55 1 10.22 1 12s.43 3.45 1.18 4.93l2.85-2.22.81-.62z" />
            <path fill="#EA4335" d="M12 5.38c1.62 0 3.06.56 4.21 1.64l3.15-3.15C17.45 2.09 14.97 1 12 1 7.7 1 3.99 3.47 2.18 7.07l3.66 2.84c.87-2.6 3.3-4.53 6.16-4.53z" />
          </svg>
          Continue with Google
        </button>
      </div>

      <div className="text-center mt-auto relative z-10">
        <p className="text-neutral-400">
          New here?{' '}
          <button onClick={onSignUp} className="text-indigo-400 hover:text-indigo-300 font-medium transition-colors">
            Create account
          </button>
        </p>
      </div>
    </motion.div>
  );
};
