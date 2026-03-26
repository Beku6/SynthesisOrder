import React from 'react';
import { motion } from 'motion/react';

interface AnimatedClockProps {
  className?: string;
  isActive?: boolean;
}

export const AnimatedClock: React.FC<AnimatedClockProps> = ({ 
  className = '', 
  isActive = false 
}) => {
  return (
    <motion.svg
      xmlns="http://www.w3.org/2000/svg"
      viewBox="0 0 24 24"
      fill="none"
      stroke="currentColor"
      strokeWidth="2"
      strokeLinecap="round"
      strokeLinejoin="round"
      className={className}
      animate={isActive ? { opacity: [0.92, 1, 0.92] } : { opacity: 1 }}
      transition={{ duration: 2.4, repeat: Infinity, ease: "easeInOut" }}
    >
      <circle cx="12" cy="12" r="10" />
      <motion.polyline
        points="12 6 12 12 16 14"
        animate={isActive ? { rotate: [0, 5, 0] } : { rotate: 0 }}
        transition={{ duration: 2.4, repeat: Infinity, ease: "easeInOut" }}
        style={{ originX: "12px", originY: "12px" }}
      />
    </motion.svg>
  );
};
