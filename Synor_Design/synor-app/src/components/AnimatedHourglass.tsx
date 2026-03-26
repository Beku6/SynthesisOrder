import React, { useId } from 'react';
import { motion } from 'motion/react';

export const AnimatedHourglass: React.FC<{ timeLeft: string; className?: string }> = ({ timeLeft, className }) => {
  const id = useId();
  const topClipId = `top-sand-clip-${id.replace(/:/g, '')}`;
  const bottomClipId = `bottom-sand-clip-${id.replace(/:/g, '')}`;

  const parts = timeLeft.split(':').map(Number);
  const totalMinutes = parts.length === 3 ? parts[0] * 60 + parts[1] : parts[0];

  let duration = 2.5;
  let streamSpeed = 1.5;
  let pulseOpacity = [0.8, 1, 0.8];
  let isWarning = false;

  if (totalMinutes <= 5) {
    duration = 1.2;
    streamSpeed = 0.8;
    pulseOpacity = [0.6, 1, 0.6];
    isWarning = true;
  } else if (totalMinutes <= 15) {
    duration = 1.8;
    streamSpeed = 1.2;
    pulseOpacity = [0.7, 1, 0.7];
  }

  return (
    <motion.div 
      className={`relative flex items-center justify-center ${className} ${isWarning ? 'text-amber-500 dark:text-amber-400' : ''}`}
      animate={{ opacity: pulseOpacity }}
      transition={{ duration: duration * 2, repeat: Infinity, ease: "easeInOut" }}
    >
      <svg xmlns="http://www.w3.org/2000/svg" width="100%" height="100%" viewBox="0 0 24 24" fill="none" stroke="currentColor" strokeWidth="2" strokeLinecap="round" strokeLinejoin="round">
        <defs>
          <clipPath id={topClipId}>
            <motion.rect 
              x="0" width="24" height="12"
              animate={{ y: [4, 6, 4] }}
              transition={{ duration, repeat: Infinity, ease: "easeInOut" }}
            />
          </clipPath>
          <clipPath id={bottomClipId}>
            <motion.rect 
              x="0" width="24" height="12"
              animate={{ y: [18, 16, 18] }}
              transition={{ duration, repeat: Infinity, ease: "easeInOut" }}
            />
          </clipPath>
        </defs>

        {/* Outline */}
        <path d="M5 22h14"/>
        <path d="M5 2h14"/>
        <path d="M17 22v-4.172a2 2 0 0 0-.586-1.414L12 12l-4.414 4.414A2 2 0 0 0 7 17.828V22"/>
        <path d="M7 2v4.172a2 2 0 0 0 .586 1.414L12 12l4.414-4.414A2 2 0 0 0 17 6.172V2"/>
        
        {/* Top Sand */}
        <path 
          d="M8 4h8v2.172a1 1 0 0 1-.293.707L12 10.586l-3.707-3.707A1 1 0 0 1 8 6.172V4z"
          fill="currentColor"
          stroke="none"
          clipPath={`url(#${topClipId})`}
          opacity="0.4"
        />

        {/* Bottom Sand */}
        <path 
          d="M8 20h8v-2.172a1 1 0 0 0-.293-.707L12 13.414l-3.707 3.707A1 1 0 0 0 8 17.828V20z"
          fill="currentColor"
          stroke="none"
          clipPath={`url(#${bottomClipId})`}
          opacity="0.4"
        />

        {/* Falling Sand Stream */}
        <motion.line 
          x1="12" x2="12"
          stroke="currentColor"
          strokeWidth="1.5"
          strokeLinecap="round"
          animate={{
            y1: [10, 10, 16],
            y2: [10, 16, 16],
            opacity: [0, 0.5, 0]
          }}
          transition={{ duration: streamSpeed, repeat: Infinity, ease: "easeInOut" }}
        />
      </svg>
    </motion.div>
  );
};
