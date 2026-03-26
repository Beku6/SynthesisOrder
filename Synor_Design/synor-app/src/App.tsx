import React, { useState, useEffect } from 'react';
import { motion, AnimatePresence, PanInfo } from 'motion/react';
import { AnimatedHourglass } from './components/AnimatedHourglass';
import { AnimatedClock } from './components/AnimatedClock';
import { Splash } from './components/auth/Splash';
import { Onboarding } from './components/auth/Onboarding';
import { SignIn } from './components/auth/SignIn';
import { SignUp } from './components/auth/SignUp';
import { ServicesScreen } from './components/services/ServicesScreen';
import {
  Moon,
  Sun,
  Search,
  Bell,
  MessageSquare,
  Plus,
  Clock,
  MapPin,
  User,
  Hourglass,
  Trash2,
  Home,
  Calendar,
  BookOpen,
  AlarmClock,
  Compass,
  ArrowLeft,
  FileText,
  Brain,
  Sparkles,
  ChevronRight,
  PlayCircle,
  CheckCircle2,
  AlertCircle,
  Settings,
  Shield,
  CreditCard,
  HelpCircle,
  FileBadge,
  Building,
  GraduationCap,
  LogOut,
  Globe,
  Volume2,
  Vibrate,
  Link2,
  Zap,
  UserPlus,
  Share,
  MoreHorizontal,
  Image as ImageIcon,
  Users,
  Lock,
  Eye,
  ThumbsUp,
  Heart,
  Bookmark,
  Award,
  UserCheck,
  Smile,
  Frown,
  Coffee,
  QrCode,
  Edit2,
  Camera,
  Upload,
  X,
  ChevronUp,
  ChevronDown
} from 'lucide-react';

interface Lesson {
  id: number;
  title: string;
  time: string;
  location: string;
  teacher: string;
  countdown: string;
  color: 'rose' | 'emerald' | 'indigo';
  alert: string | null;
}

const LessonCard: React.FC<{ 
  lesson: Lesson; 
  onAlertClick: (id: number) => void; 
  onRemoveAlert: (id: number) => void; 
}> = ({ 
  lesson, 
  onAlertClick, 
  onRemoveAlert 
}) => {
  const [isSwiped, setIsSwiped] = useState(false);
  
  const colors = {
    rose: {
      border: 'border-rose-200 dark:border-rose-500/20',
      hoverBorder: 'hover:border-rose-300 dark:hover:border-rose-500/40',
      dot: 'bg-rose-500 shadow-[0_0_8px_rgba(244,63,94,0.5)] dark:shadow-[0_0_12px_rgba(244,63,94,0.8)]',
      text: 'text-rose-600 dark:text-rose-100',
      bg: 'bg-rose-50 dark:bg-rose-500/10',
      icon: 'text-rose-500 dark:text-rose-400',
      borderInner: 'border-rose-100 dark:border-rose-500/20'
    },
    emerald: {
      border: 'border-emerald-200 dark:border-emerald-500/20',
      hoverBorder: 'hover:border-emerald-300 dark:hover:border-emerald-500/40',
      dot: 'bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.5)] dark:shadow-[0_0_12px_rgba(16,185,129,0.8)]',
      text: 'text-emerald-600 dark:text-emerald-100',
      bg: 'bg-emerald-50 dark:bg-emerald-500/10',
      icon: 'text-emerald-500 dark:text-emerald-400',
      borderInner: 'border-emerald-100 dark:border-emerald-500/20'
    },
    indigo: {
      border: 'border-indigo-200 dark:border-indigo-500/20',
      hoverBorder: 'hover:border-indigo-300 dark:hover:border-indigo-500/40',
      dot: 'bg-indigo-500 shadow-[0_0_8px_rgba(99,102,241,0.5)] dark:shadow-[0_0_12px_rgba(99,102,241,0.8)]',
      text: 'text-indigo-600 dark:text-indigo-100',
      bg: 'bg-indigo-50 dark:bg-indigo-500/10',
      icon: 'text-indigo-500 dark:text-indigo-400',
      borderInner: 'border-indigo-100 dark:border-indigo-500/20'
    }
  };

  const c = colors[lesson.color];
  const isStarted = lesson.countdown === '00:00:00' || lesson.countdown.startsWith('-');
  const isNear = !isStarted && (lesson.countdown.startsWith('00:') || lesson.countdown.startsWith('01:'));
  const isActive = isStarted || isNear;

  return (
    <div className="relative overflow-hidden rounded-[28px]">
      {/* Quick Actions Panel (Background) */}
      <div className="absolute inset-y-0 right-0 w-[240px] bg-slate-100 dark:bg-[#1a1a1a] flex items-center justify-end pr-4 gap-2 rounded-[28px]">
        <button 
          onClick={() => { setIsSwiped(false); onAlertClick(lesson.id); }}
          className="flex flex-col items-center justify-center gap-1 w-[60px] h-[60px] rounded-2xl bg-indigo-100 dark:bg-indigo-500/20 text-indigo-600 dark:text-indigo-400 hover:bg-indigo-200 dark:hover:bg-indigo-500/30 transition-colors"
        >
          <Bell className="w-5 h-5" />
          <span className="text-[9px] font-semibold uppercase tracking-wider">Alert</span>
        </button>
        <button className="flex flex-col items-center justify-center gap-1 w-[60px] h-[60px] rounded-2xl bg-white dark:bg-white/5 text-slate-600 dark:text-neutral-400 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors">
          <FileText className="w-5 h-5" />
          <span className="text-[9px] font-semibold uppercase tracking-wider">Notes</span>
        </button>
        <button className="flex flex-col items-center justify-center gap-1 w-[60px] h-[60px] rounded-2xl bg-white dark:bg-white/5 text-slate-600 dark:text-neutral-400 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors">
          <MoreHorizontal className="w-5 h-5" />
          <span className="text-[9px] font-semibold uppercase tracking-wider">More</span>
        </button>
      </div>

      {/* Foreground Card */}
      <motion.div 
        drag="x"
        dragDirectionLock
        dragConstraints={{ left: -220, right: 0 }}
        dragElastic={0.1}
        onDragEnd={(e, info: PanInfo) => {
          if (info.offset.x < -100) {
            setIsSwiped(true);
          } else {
            setIsSwiped(false);
          }
        }}
        animate={{ x: isSwiped ? -220 : 0 }}
        transition={{ type: "spring", stiffness: 300, damping: 30 }}
        className={`relative p-5 rounded-[28px] bg-white dark:bg-[#0a0a0a] dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border ${c.border} backdrop-blur-md group ${c.hoverBorder} transition-colors shadow-sm hover:shadow-md dark:shadow-lg w-full z-10`}
      >
        {/* Status Dot */}
        <div className={`absolute top-6 right-6 w-2.5 h-2.5 rounded-full ${c.dot}`} />
        
        <h3 className="text-base font-semibold text-slate-900 dark:text-white mb-5 pr-8 tracking-tight transition-colors duration-500">{lesson.title}</h3>
        
        <div className="flex justify-between items-start">
          <div className="space-y-3.5">
            <div className="flex items-center gap-3 text-sm text-slate-600 dark:text-neutral-300 transition-colors duration-500">
              <AnimatedClock isActive={isActive} className="w-4.5 h-4.5 text-slate-400 dark:text-neutral-500" />
              <span className="font-medium">{lesson.time}</span>
            </div>
            <div className="flex items-center gap-3 text-sm text-slate-600 dark:text-neutral-300 transition-colors duration-500">
              <MapPin className="w-4.5 h-4.5 text-slate-400 dark:text-neutral-500" />
              <span>{lesson.location}</span>
            </div>
            <div className="flex items-center gap-3 text-sm text-slate-600 dark:text-neutral-300 transition-colors duration-500">
              <User className="w-4.5 h-4.5 text-slate-400 dark:text-neutral-500" />
              <span>{lesson.teacher}</span>
            </div>
          </div>
          
          <div className="flex flex-col items-end justify-between h-[104px]">
            {isStarted ? (
              <div className={`flex items-center gap-2 text-sm font-semibold text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-500/10 px-3 py-1.5 rounded-xl border border-emerald-100 dark:border-emerald-500/20 transition-colors duration-500`}>
                <div className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse shadow-[0_0_8px_rgba(16,185,129,0.5)]" />
                <span>In progress</span>
              </div>
            ) : (
              <div className={`flex items-center gap-2 text-sm font-semibold ${c.text} ${c.bg} px-3 py-1.5 rounded-xl border ${c.borderInner} transition-colors duration-500`}>
                <AnimatedHourglass timeLeft={lesson.countdown} className={`w-4 h-4 ${c.icon}`} />
                <span>{lesson.countdown}</span>
              </div>
            )}
            
            {lesson.alert ? (
              <div 
                onClick={() => onAlertClick(lesson.id)}
                className="flex items-center gap-1.5 px-2.5 py-1.5 rounded-xl bg-indigo-50 dark:bg-indigo-500/10 text-indigo-600 dark:text-indigo-400 border border-indigo-100 dark:border-indigo-500/20 text-xs font-semibold cursor-pointer hover:bg-indigo-100 dark:hover:bg-indigo-500/20 transition-colors"
                title="Click to edit alert"
              >
                <Bell className="w-3.5 h-3.5" />
                <span>{lesson.alert}</span>
              </div>
            ) : (
              <div className="w-8 h-8" /> // Spacer
            )}
          </div>
        </div>
      </motion.div>
    </div>
  );
};

const ScheduleLessonCard: React.FC<{
  lesson: Lesson;
  onAlertClick: (id: number) => void;
}> = ({ lesson, onAlertClick }) => {
  const [isSwiped, setIsSwiped] = useState(false);
  
  const colors = {
    rose: {
      dot: 'bg-rose-500 shadow-[0_0_8px_rgba(244,63,94,0.5)] dark:shadow-[0_0_12px_rgba(244,63,94,0.8)]',
      border: 'border-rose-200 dark:border-rose-500/20',
    },
    emerald: {
      dot: 'bg-emerald-500 shadow-[0_0_8px_rgba(16,185,129,0.5)] dark:shadow-[0_0_12px_rgba(16,185,129,0.8)]',
      border: 'border-emerald-200 dark:border-emerald-500/20',
    },
    indigo: {
      dot: 'bg-indigo-500 shadow-[0_0_8px_rgba(99,102,241,0.5)] dark:shadow-[0_0_12px_rgba(99,102,241,0.8)]',
      border: 'border-indigo-200 dark:border-indigo-500/20',
    }
  };

  const c = colors[lesson.color];
  const isStarted = lesson.countdown === '00:00:00' || lesson.countdown.startsWith('-');
  const isNear = !isStarted && (lesson.countdown.startsWith('00:') || lesson.countdown.startsWith('01:'));
  const isActive = isStarted || isNear;

  return (
    <div className="relative pl-12">
      <div className={`absolute left-[15px] top-6 w-2.5 h-2.5 rounded-full ring-4 ring-slate-50 dark:ring-[#050505] ${c.dot}`} />
      
      <div className="relative overflow-hidden rounded-[28px]">
        {/* Quick Actions Panel (Background) */}
        <div className="absolute inset-y-0 right-0 w-[240px] bg-slate-100 dark:bg-[#1a1a1a] flex items-center justify-end pr-4 gap-2 rounded-[28px]">
          <button 
            onClick={() => { setIsSwiped(false); onAlertClick(lesson.id); }}
            className="flex flex-col items-center justify-center gap-1 w-[60px] h-[60px] rounded-2xl bg-indigo-100 dark:bg-indigo-500/20 text-indigo-600 dark:text-indigo-400 hover:bg-indigo-200 dark:hover:bg-indigo-500/30 transition-colors"
          >
            <Bell className="w-5 h-5" />
            <span className="text-[9px] font-semibold uppercase tracking-wider">Alert</span>
          </button>
          <button className="flex flex-col items-center justify-center gap-1 w-[60px] h-[60px] rounded-2xl bg-white dark:bg-white/5 text-slate-600 dark:text-neutral-400 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors">
            <FileText className="w-5 h-5" />
            <span className="text-[9px] font-semibold uppercase tracking-wider">Notes</span>
          </button>
          <button className="flex flex-col items-center justify-center gap-1 w-[60px] h-[60px] rounded-2xl bg-white dark:bg-white/5 text-slate-600 dark:text-neutral-400 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors">
            <MoreHorizontal className="w-5 h-5" />
            <span className="text-[9px] font-semibold uppercase tracking-wider">More</span>
          </button>
        </div>

        {/* Foreground Card */}
        <motion.div 
          drag="x"
          dragDirectionLock
          dragConstraints={{ left: -220, right: 0 }}
          dragElastic={0.1}
          onDragEnd={(e, info: PanInfo) => {
            if (info.offset.x < -100) {
              setIsSwiped(true);
            } else {
              setIsSwiped(false);
            }
          }}
          animate={{ x: isSwiped ? -220 : 0 }}
          transition={{ type: "spring", stiffness: 300, damping: 30 }}
          className={`relative p-5 rounded-[28px] bg-white dark:bg-[#0a0a0a] dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border ${c.border} backdrop-blur-md shadow-sm hover:shadow-md transition-shadow w-full z-10`}
        >
          <div className="flex justify-between items-start mb-4">
            <h3 className="text-base font-semibold text-slate-900 dark:text-white tracking-tight pr-2">{lesson.title}</h3>
            <div className="flex flex-col items-end gap-2">
              {isStarted ? (
                <div className={`flex items-center gap-1.5 px-2 py-1 rounded-lg text-[10px] font-semibold text-emerald-600 dark:text-emerald-400 bg-emerald-50 dark:bg-emerald-500/10 border border-emerald-100 dark:border-emerald-500/20 transition-colors duration-500`}>
                  <div className="w-1.5 h-1.5 rounded-full bg-emerald-500 animate-pulse shadow-[0_0_8px_rgba(16,185,129,0.5)]" />
                  <span>In progress</span>
                </div>
              ) : (
                <div className={`flex items-center gap-1.5 px-2 py-1 rounded-lg text-[10px] font-semibold text-slate-600 dark:text-neutral-300 bg-slate-50 dark:bg-white/5 border border-slate-200 dark:border-white/10 transition-colors duration-500`}>
                  <AnimatedHourglass timeLeft={lesson.countdown} className="w-3 h-3 text-slate-400 dark:text-neutral-500" />
                  <span>{lesson.countdown}</span>
                </div>
              )}
              {lesson.alert && (
                <div 
                  onClick={() => onAlertClick(lesson.id)}
                  className="flex-shrink-0 flex items-center gap-1.5 px-2 py-1 rounded-lg bg-indigo-50 dark:bg-indigo-500/10 text-indigo-600 dark:text-indigo-400 border border-indigo-100 dark:border-indigo-500/20 text-[10px] font-semibold cursor-pointer hover:bg-indigo-100 dark:hover:bg-indigo-500/20 transition-colors"
                  title="Click to edit alert"
                >
                  <Bell className="w-3 h-3" />
                  <span>{lesson.alert}</span>
                </div>
              )}
            </div>
          </div>
          <div className="space-y-3">
            <div className="flex items-center gap-3 text-sm text-slate-600 dark:text-neutral-300">
              <AnimatedClock isActive={isActive} className="w-4.5 h-4.5 text-slate-400 dark:text-neutral-500" />
              <span className="font-medium">{lesson.time}</span>
            </div>
            <div className="flex items-center gap-3 text-sm text-slate-600 dark:text-neutral-300">
              <MapPin className="w-4.5 h-4.5 text-slate-400 dark:text-neutral-500" />
              <span>{lesson.location}</span>
            </div>
            <div className="flex items-center gap-3 text-sm text-slate-600 dark:text-neutral-300">
              <User className="w-4.5 h-4.5 text-slate-400 dark:text-neutral-500" />
              <span>{lesson.teacher}</span>
            </div>
          </div>
        </motion.div>
      </div>
    </div>
  );
};

export default function App() {
  // Состояние для переключения темы (по умолчанию темная)
  const [isDarkMode, setIsDarkMode] = useState(true);
  const [appState, setAppState] = useState<'splash' | 'onboarding' | 'signin' | 'signup' | 'main'>('splash');
  const [isVibrationEnabled, setIsVibrationEnabled] = useState(true);
  const [isAutoAdjustEnabled, setIsAutoAdjustEnabled] = useState(true);
  const [isSettingsOpen, setIsSettingsOpen] = useState(false);
  const [isCoverModalOpen, setIsCoverModalOpen] = useState(false);
  const [isAlertSheetOpen, setIsAlertSheetOpen] = useState(false);
  const [alertTargetId, setAlertTargetId] = useState<number | null>(null);
  const [coverImage, setCoverImage] = useState('https://images.unsplash.com/photo-1541339907198-e08756dedf3f?q=80&w=1000&auto=format&fit=crop');
  
  const [lessons, setLessons] = useState<Lesson[]>([
    { id: 4, title: 'Physics Lab', time: '13:00-14:50', location: 'Main Building, Room 201', teacher: 'Prof. Ivanov', countdown: '00:00:00', color: 'indigo', alert: null },
    { id: 1, title: 'Web Programming and Python', time: '15:00-15:50', location: 'Tole bi №86', teacher: 'Urazimbetov M.', countdown: '00:04:12', color: 'rose', alert: null },
    { id: 2, title: 'Algoritm and Matemathics', time: '17:00-19:50', location: 'Tole bi №86', teacher: 'Alexandr S.', countdown: '26:15:12', color: 'emerald', alert: null },
    { id: 3, title: 'Database Management Systems', time: '10:00-11:50', location: 'Kazybek bi №30', teacher: 'Nurlan K.', countdown: '12:45:00', color: 'indigo', alert: null }
  ]);
  
  const handleImageUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const file = event.target.files?.[0];
    if (file) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setCoverImage(reader.result as string);
        setIsCoverModalOpen(false);
      };
      reader.readAsDataURL(file);
    }
  };

  const handleAlertClick = (id: number) => {
    setAlertTargetId(id);
    setIsAlertSheetOpen(true);
  };

  const handleRemoveAlert = (id: number) => {
    setLessons(prev => prev.map(l => l.id === id ? { ...l, alert: null } : l));
  };

  const coverTemplates = [
    'https://images.unsplash.com/photo-1541339907198-e08756dedf3f?q=80&w=1000&auto=format&fit=crop', // Campus
    'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4?q=80&w=1000&auto=format&fit=crop', // Library
    'https://images.unsplash.com/photo-1523050854058-8df90110c9f1?q=80&w=1000&auto=format&fit=crop', // Graduation
    'https://images.unsplash.com/photo-1498243691581-b145c3f54a5a?q=80&w=1000&auto=format&fit=crop', // Architecture
    'https://images.unsplash.com/photo-1555448248-2571daf6344b?q=80&w=1000&auto=format&fit=crop', // Abstract tech
    'https://images.unsplash.com/photo-1507413245164-6160d8298b31?q=80&w=1000&auto=format&fit=crop', // Science
  ];
  
  // Состояние для переключения экранов
  const [activeScreen, setActiveScreen] = useState<'home' | 'messages' | 'schedule' | 'studies' | 'services' | 'profile' | 'alarm'>('home');
  const [studyMode, setStudyMode] = useState<'Subjects' | 'Assignments' | 'Grades'>('Subjects');
  const [scheduleMode, setScheduleMode] = useState<'Day' | 'Week' | 'Exams'>('Day');
  const [alertMode, setAlertMode] = useState<'Personal' | 'Academic'>('Personal');
  const [academicType, setAcademicType] = useState('Wake up');
  const [alarmTime, setAlarmTime] = useState({ hours: 7, minutes: 30 });

  const handleTimeChange = (type: 'hours' | 'minutes', amount: number) => {
    setAlarmTime(prev => {
      let newHours = prev.hours;
      let newMinutes = prev.minutes;

      if (type === 'hours') {
        newHours = (newHours + amount + 24) % 24;
      } else {
        newMinutes = (newMinutes + amount + 60) % 60;
      }

      return { hours: newHours, minutes: newMinutes };
    });
  };

  // Функция переключения с легкой вибрацией (как в Telegram)
  const toggleTheme = () => {
    setIsDarkMode(!isDarkMode);
    if (typeof window !== 'undefined' && window.navigator && window.navigator.vibrate) {
      window.navigator.vibrate(40); // Легкий тактильный отклик на мобильных
    }
  };

  return (
    <div className={`${isDarkMode ? 'dark' : ''} transition-colors duration-500`}>
      <div className="relative min-h-screen flex justify-center bg-slate-50 dark:bg-[#050505] overflow-hidden font-sans transition-colors duration-500">
        {/* Ambient Background Glows */}
        <div className="absolute top-[-10%] left-[-10%] w-[50vw] h-[50vw] rounded-full bg-indigo-900/10 dark:bg-purple-900/20 blur-[120px] pointer-events-none transition-colors duration-500" />
        <div className="absolute bottom-[-10%] right-[-10%] w-[50vw] h-[50vw] rounded-full bg-blue-900/10 dark:bg-blue-900/20 blur-[120px] pointer-events-none transition-colors duration-500" />

        {/* Mobile Container */}
        <div className="relative w-full max-w-[430px] h-[100dvh] bg-white/60 dark:bg-black/40 backdrop-blur-3xl border-x border-slate-200 dark:border-white/5 shadow-2xl flex flex-col overflow-hidden transition-colors duration-500">
          
          <AnimatePresence mode="wait">
            {appState === 'splash' && <Splash key="splash" onComplete={() => setAppState('onboarding')} />}
            {appState === 'onboarding' && <Onboarding key="onboarding" onComplete={() => setAppState('signin')} />}
            {appState === 'signin' && <SignIn key="signin" onSignIn={() => setAppState('main')} onSignUp={() => setAppState('signup')} />}
            {appState === 'signup' && <SignUp key="signup" onComplete={() => setAppState('main')} onBack={() => setAppState('signin')} />}
          </AnimatePresence>

          {appState === 'main' && (
            <motion.div
              key="main-app"
              initial={{ opacity: 0 }}
              animate={{ opacity: 1 }}
              exit={{ opacity: 0 }}
              transition={{ duration: 0.5 }}
              className="absolute inset-0 flex flex-col"
            >
              <AnimatePresence mode="wait">
                {activeScreen === 'home' && (
              <motion.div 
                key="home"
                initial={{ opacity: 0, x: -20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: -20 }}
                transition={{ duration: 0.3, ease: "easeInOut" }}
                className="absolute inset-0 flex flex-col"
              >
                {/* Scrollable Content Area */}
                <div className="flex-1 overflow-y-auto hide-scrollbar pb-32 pt-12 px-6 space-y-8">
            
            {/* Header */}
            <header className="flex items-center justify-between">
              <div className="flex items-center gap-3">
                {/* Logo Icon */}
                <div className="w-9 h-9 rounded-xl border border-slate-200 dark:border-white/10 shadow-lg overflow-hidden shrink-0 transition-colors duration-500">
                  <img src="/logo.jpg" alt="S Logo" className="w-full h-full object-cover" />
                </div>
                <h1 className="text-xl tracking-widest text-slate-900 dark:text-white transition-colors duration-500" style={{ fontFamily: '"Holtwood One SC", serif' }}>SYNOR</h1>
              </div>
              
              {/* Theme Toggle Button - Telegram Style Animation */}
              <button 
                onClick={toggleTheme}
                className="relative p-2.5 rounded-full bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 hover:bg-slate-100 dark:hover:bg-white/10 transition-colors shadow-sm overflow-hidden group"
                aria-label="Toggle theme"
              >
                <div className="relative w-5 h-5">
                  <Sun 
                    className={`absolute inset-0 w-5 h-5 text-amber-500 transition-all duration-500 transform ${isDarkMode ? 'rotate-90 opacity-0 scale-50' : 'rotate-0 opacity-100 scale-100'}`} 
                  />
                  <Moon 
                    className={`absolute inset-0 w-5 h-5 text-indigo-500 dark:text-indigo-400 transition-all duration-500 transform ${isDarkMode ? 'rotate-0 opacity-100 scale-100' : '-rotate-90 opacity-0 scale-50'}`} 
                  />
                </div>
              </button>
            </header>

            {/* Search & Actions */}
            <div className="flex items-center gap-3">
              <div className="flex-1 relative group">
                <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-4.5 h-4.5 text-slate-400 dark:text-neutral-500 group-focus-within:text-indigo-500 dark:group-focus-within:text-neutral-300 transition-colors" />
                <input
                  type="text"
                  placeholder="Search..."
                  className="w-full bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-2xl py-3.5 pl-12 pr-4 text-sm text-slate-900 dark:text-white placeholder:text-slate-400 dark:placeholder:text-neutral-500 focus:outline-none focus:border-indigo-500/50 dark:focus:border-white/20 focus:bg-slate-50 dark:focus:bg-white/10 transition-all shadow-sm dark:shadow-inner"
                />
              </div>
              <button 
                onClick={() => setActiveScreen('alarm')}
                className="p-3.5 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors shadow-sm"
              >
                <AlarmClock className="w-5 h-5 text-slate-600 dark:text-neutral-300" />
              </button>
              <button 
                onClick={() => setActiveScreen('messages')}
                className="p-3.5 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors shadow-sm"
              >
                <MessageSquare className="w-5 h-5 text-slate-600 dark:text-neutral-300" />
              </button>
            </div>

            {/* Stories */}
            <div className="flex gap-4 overflow-x-auto hide-scrollbar pb-2 -mx-6 px-6">
              {/* You Story */}
              <div className="relative w-[105px] h-[105px] shrink-0 rounded-[24px] bg-white dark:bg-white/15 border-[3px] border-slate-100 dark:border-white/20 p-3 flex flex-col justify-between shadow-md dark:shadow-lg backdrop-blur-md transition-colors duration-500">
                <div className="relative w-10 h-10 rounded-full bg-slate-100 dark:bg-white flex items-center justify-center shadow-sm">
                  <User className="w-6 h-6 text-blue-600 fill-blue-600" />
                  <div className="absolute -bottom-1 -right-1 w-4.5 h-4.5 rounded-full bg-white dark:bg-neutral-800 border-[1.5px] border-slate-200 dark:border-neutral-400 flex items-center justify-center">
                    <Plus className="w-3 h-3 text-slate-800 dark:text-white" strokeWidth={3} />
                  </div>
                </div>
                <span className="text-[13px] font-bold text-slate-800 dark:text-white leading-tight tracking-wide transition-colors duration-500">You Stories</span>
              </div>

              {/* Story 1 */}
              <div className="relative w-[105px] h-[105px] shrink-0 rounded-[24px] bg-white dark:bg-white/15 border-[3px] border-purple-500 dark:border-purple-600 p-3 flex flex-col justify-between shadow-[0_4px_15px_rgba(147,51,234,0.15)] dark:shadow-[0_0_15px_rgba(147,51,234,0.3)] backdrop-blur-md transition-colors duration-500">
                <div className="w-10 h-10 rounded-full overflow-hidden shadow-sm border border-slate-200 dark:border-white/10">
                  <img src="https://picsum.photos/seed/nurali/100/100" alt="Nurali" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                </div>
                <span className="text-[13px] font-bold text-slate-800 dark:text-white leading-tight tracking-wide transition-colors duration-500">Nurali Askar</span>
              </div>

              {/* Story 2 */}
              <div className="relative w-[105px] h-[105px] shrink-0 rounded-[24px] bg-white dark:bg-white/15 border-[3px] border-yellow-400 dark:border-yellow-500 p-3 flex flex-col justify-between shadow-[0_4px_15px_rgba(234,179,8,0.15)] dark:shadow-[0_0_15px_rgba(234,179,8,0.3)] backdrop-blur-md transition-colors duration-500">
                <div className="w-10 h-10 rounded-full bg-slate-100 dark:bg-white flex items-center justify-center shadow-sm">
                  <User className="w-6 h-6 text-slate-800 dark:text-black fill-slate-800 dark:fill-black" />
                </div>
                <span className="text-[13px] font-bold text-slate-800 dark:text-white leading-tight tracking-wide transition-colors duration-500">Moer</span>
              </div>

              {/* Story 3 */}
              <div className="relative w-[105px] h-[105px] shrink-0 rounded-[24px] bg-white dark:bg-white/15 border-[3px] border-rose-500 dark:border-rose-600 p-3 flex flex-col justify-between shadow-[0_4px_15px_rgba(244,63,94,0.15)] dark:shadow-[0_0_15px_rgba(244,63,94,0.3)] backdrop-blur-md transition-colors duration-500">
                <div className="w-10 h-10 rounded-full overflow-hidden shadow-sm border border-slate-200 dark:border-white/10">
                  <img src="https://picsum.photos/seed/aruzhan/100/100" alt="Aruzhan" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                </div>
                <span className="text-[13px] font-bold text-slate-800 dark:text-white leading-tight tracking-wide transition-colors duration-500">Aruzhan</span>
              </div>

              {/* Story 4 */}
              <div className="relative w-[105px] h-[105px] shrink-0 rounded-[24px] bg-white dark:bg-white/15 border-[3px] border-emerald-500 dark:border-emerald-600 p-3 flex flex-col justify-between shadow-[0_4px_15px_rgba(16,185,129,0.15)] dark:shadow-[0_0_15px_rgba(16,185,129,0.3)] backdrop-blur-md transition-colors duration-500">
                <div className="w-10 h-10 rounded-full overflow-hidden shadow-sm border border-slate-200 dark:border-white/10">
                  <img src="https://picsum.photos/seed/dias/100/100" alt="Dias" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                </div>
                <span className="text-[13px] font-bold text-slate-800 dark:text-white leading-tight tracking-wide transition-colors duration-500">Dias</span>
              </div>

              {/* Story 5 */}
              <div className="relative w-[105px] h-[105px] shrink-0 rounded-[24px] bg-white dark:bg-white/15 border-[3px] border-cyan-500 dark:border-cyan-600 p-3 flex flex-col justify-between shadow-[0_4px_15px_rgba(6,182,212,0.15)] dark:shadow-[0_0_15px_rgba(6,182,212,0.3)] backdrop-blur-md transition-colors duration-500">
                <div className="w-10 h-10 rounded-full overflow-hidden shadow-sm border border-slate-200 dark:border-white/10">
                  <img src="https://picsum.photos/seed/madina/100/100" alt="Madina" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                </div>
                <span className="text-[13px] font-bold text-slate-800 dark:text-white leading-tight tracking-wide transition-colors duration-500">Madina</span>
              </div>
            </div>

            {/* Filters */}
            <div className="flex gap-2.5 overflow-x-auto hide-scrollbar -mx-6 px-6">
              {['lessons', 'all', 'missed', 'tomorrow'].map((filter, i) => (
                <button
                  key={filter}
                  className={`px-5 py-2.5 rounded-full text-sm font-medium whitespace-nowrap transition-all duration-300 ${
                    i === 0
                      ? 'bg-gradient-to-br from-slate-800 via-[#0a0a0a] to-indigo-950 dark:from-white/20 dark:via-white/15 dark:to-white/10 border border-slate-700/50 dark:border-white/20 text-white shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_4px_15px_rgba(0,0,0,0.25)] dark:shadow-[0_0_15px_rgba(255,255,255,0.1)]'
                      : 'bg-white dark:bg-white/5 border border-slate-200 dark:border-white/5 text-slate-600 dark:text-neutral-400 hover:bg-slate-50 dark:hover:bg-white/10 hover:text-slate-900 dark:hover:text-neutral-200 shadow-sm dark:shadow-none'
                  }`}
                >
                  {filter}
                </button>
              ))}
            </div>

            {/* Lesson Cards */}
            <div className="space-y-4">
              {lessons.map(lesson => (
                <LessonCard 
                  key={lesson.id} 
                  lesson={lesson} 
                  onAlertClick={handleAlertClick} 
                  onRemoveAlert={handleRemoveAlert} 
                />
              ))}
            </div>
            </div>
              </motion.div>
            )}

            {activeScreen === 'schedule' && (
              <motion.div 
                key="schedule"
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: 20 }}
                transition={{ duration: 0.3, ease: "easeInOut" }}
                className="absolute inset-0 flex flex-col"
              >
                <div className="flex-1 overflow-y-auto hide-scrollbar pb-32 pt-12 px-6 space-y-8">
                  {/* Schedule Header */}
                  <header className="flex items-center justify-between">
                    <h1 className="text-2xl font-bold text-slate-900 dark:text-white tracking-tight">Schedule</h1>
                    <button className="p-2.5 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors shadow-sm">
                      <Search className="w-5 h-5 text-slate-600 dark:text-neutral-300" />
                    </button>
                  </header>

                  {/* View Filters */}
                  <div className="flex gap-2.5 bg-white dark:bg-white/5 p-1.5 rounded-2xl border border-slate-200 dark:border-white/10 shadow-sm">
                    {(['Day', 'Week', 'Month'] as const).map((view) => (
                      <button
                        key={view}
                        onClick={() => setScheduleMode(view)}
                        className={`flex-1 py-2 rounded-xl text-sm font-medium transition-all duration-300 ${
                          scheduleMode === view
                            ? 'bg-gradient-to-br from-slate-800 via-[#0a0a0a] to-indigo-950 dark:from-white/20 dark:via-white/15 dark:to-white/10 text-white shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_4px_15px_rgba(0,0,0,0.25)] dark:shadow-[0_0_15px_rgba(255,255,255,0.1)]'
                            : 'text-slate-600 dark:text-neutral-400 hover:text-slate-900 dark:hover:text-neutral-200'
                        }`}
                      >
                        {view}
                      </button>
                    ))}
                  </div>

                  <AnimatePresence mode="wait">
                    {scheduleMode === 'Day' && (
                      <motion.div
                        key="day"
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        transition={{ duration: 0.2 }}
                        className="space-y-8"
                      >
                        {/* Date Selector */}
                        <div className="flex gap-3 overflow-x-auto hide-scrollbar -mx-6 px-6 pb-2">
                          {[
                            { day: 'Mon', date: '12' },
                            { day: 'Tue', date: '13', active: true },
                            { day: 'Wed', date: '14' },
                            { day: 'Thu', date: '15' },
                            { day: 'Fri', date: '16' },
                            { day: 'Sat', date: '17' },
                          ].map((d, i) => (
                            <button
                              key={i}
                              className={`flex flex-col items-center min-w-[64px] py-3 rounded-2xl border transition-all duration-300 ${
                                d.active
                                  ? 'bg-gradient-to-br from-slate-800 via-[#0a0a0a] to-indigo-950 dark:from-white/20 dark:via-white/15 dark:to-white/10 border-slate-700/50 dark:border-white/20 shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_4px_15px_rgba(0,0,0,0.25)] dark:shadow-[0_0_15px_rgba(255,255,255,0.1)]'
                                  : 'bg-white dark:bg-white/5 border-slate-200 dark:border-white/10 hover:bg-slate-50 dark:hover:bg-white/10'
                              }`}
                            >
                              <span className={`text-xs font-medium mb-1 ${d.active ? 'text-indigo-100 dark:text-indigo-300' : 'text-slate-500 dark:text-neutral-400'}`}>{d.day}</span>
                              <span className={`text-lg font-bold ${d.active ? 'text-white' : 'text-slate-900 dark:text-white'}`}>{d.date}</span>
                            </button>
                          ))}
                        </div>

                        {/* Timeline / Cards */}
                        <div className="space-y-4 relative before:absolute before:inset-y-0 before:left-[19px] before:w-px before:bg-slate-200 dark:before:bg-white/10">
                          {lessons.map(lesson => (
                            <ScheduleLessonCard 
                              key={lesson.id} 
                              lesson={lesson} 
                              onAlertClick={handleAlertClick} 
                            />
                          ))}
                        </div>
                      </motion.div>
                    )}

                    {scheduleMode === 'Week' && (
                      <motion.div
                        key="week"
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        transition={{ duration: 0.2 }}
                        className="space-y-6"
                      >
                        {/* Week Overview */}
                        <div className="p-5 rounded-[28px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm">
                          <h3 className="text-lg font-semibold text-slate-900 dark:text-white mb-4">This Week</h3>
                          <div className="space-y-4">
                            {/* Mon */}
                            <div className="flex items-start gap-4">
                              <div className="w-12 text-center">
                                <div className="text-xs text-slate-500 dark:text-neutral-400">Mon</div>
                                <div className="text-lg font-bold text-slate-900 dark:text-white">12</div>
                              </div>
                              <div className="flex-1 space-y-2">
                                <div className="p-3 rounded-xl bg-indigo-50 dark:bg-indigo-500/10 border border-indigo-100 dark:border-indigo-500/20">
                                  <div className="text-sm font-semibold text-indigo-900 dark:text-indigo-100">Advanced Mathematics</div>
                                  <div className="text-xs text-indigo-600 dark:text-indigo-300 mt-1">09:00 - 10:20</div>
                                </div>
                                <div className="p-3 rounded-xl bg-emerald-50 dark:bg-emerald-500/10 border border-emerald-100 dark:border-emerald-500/20">
                                  <div className="text-sm font-semibold text-emerald-900 dark:text-emerald-100">Physics Lab</div>
                                  <div className="text-xs text-emerald-600 dark:text-emerald-300 mt-1">11:00 - 12:50</div>
                                </div>
                              </div>
                            </div>
                            {/* Tue */}
                            <div className="flex items-start gap-4">
                              <div className="w-12 text-center">
                                <div className="text-xs text-slate-500 dark:text-neutral-400">Tue</div>
                                <div className="text-lg font-bold text-indigo-600 dark:text-indigo-400">13</div>
                              </div>
                              <div className="flex-1 space-y-2">
                                <div className="p-3 rounded-xl bg-rose-50 dark:bg-rose-500/10 border border-rose-100 dark:border-rose-500/20">
                                  <div className="text-sm font-semibold text-rose-900 dark:text-rose-100">Web Programming</div>
                                  <div className="text-xs text-rose-600 dark:text-rose-300 mt-1">15:00 - 15:50</div>
                                </div>
                              </div>
                            </div>
                            {/* Wed */}
                            <div className="flex items-start gap-4">
                              <div className="w-12 text-center">
                                <div className="text-xs text-slate-500 dark:text-neutral-400">Wed</div>
                                <div className="text-lg font-bold text-slate-900 dark:text-white">14</div>
                              </div>
                              <div className="flex-1 space-y-2">
                                <div className="p-3 rounded-xl bg-slate-50 dark:bg-white/5 border border-slate-200 dark:border-white/10 flex items-center justify-center h-[68px]">
                                  <span className="text-sm text-slate-500 dark:text-neutral-400">No classes</span>
                                </div>
                              </div>
                            </div>
                          </div>
                        </div>
                      </motion.div>
                    )}

                    {scheduleMode === 'Month' && (
                      <motion.div
                        key="month"
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        transition={{ duration: 0.2 }}
                        className="space-y-6"
                      >
                        {/* Month Calendar Placeholder */}
                        <div className="p-5 rounded-[28px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm">
                          <div className="flex items-center justify-between mb-6">
                            <h3 className="text-lg font-semibold text-slate-900 dark:text-white">October 2026</h3>
                            <div className="flex gap-2">
                              <button className="p-1.5 rounded-lg hover:bg-slate-100 dark:hover:bg-white/10 transition-colors">
                                <ChevronRight className="w-5 h-5 rotate-180 text-slate-600 dark:text-neutral-400" />
                              </button>
                              <button className="p-1.5 rounded-lg hover:bg-slate-100 dark:hover:bg-white/10 transition-colors">
                                <ChevronRight className="w-5 h-5 text-slate-600 dark:text-neutral-400" />
                              </button>
                            </div>
                          </div>
                          
                          <div className="grid grid-cols-7 gap-y-4 gap-x-2 text-center">
                            {['Mo', 'Tu', 'We', 'Th', 'Fr', 'Sa', 'Su'].map(day => (
                              <div key={day} className="text-xs font-medium text-slate-500 dark:text-neutral-400">{day}</div>
                            ))}
                            
                            {/* Empty days */}
                            <div className="aspect-square"></div>
                            <div className="aspect-square"></div>
                            <div className="aspect-square"></div>
                            
                            {/* Days */}
                            {Array.from({ length: 31 }).map((_, i) => {
                              const day = i + 1;
                              const hasEvent = [2, 5, 12, 13, 18, 24, 28].includes(day);
                              const isToday = day === 13;
                              
                              return (
                                <div key={day} className="aspect-square flex flex-col items-center justify-center relative">
                                  <div className={`w-8 h-8 flex items-center justify-center rounded-full text-sm ${
                                    isToday 
                                      ? 'bg-indigo-500 text-white font-bold shadow-md shadow-indigo-500/30' 
                                      : 'text-slate-700 dark:text-neutral-300 hover:bg-slate-100 dark:hover:bg-white/10 cursor-pointer'
                                  }`}>
                                    {day}
                                  </div>
                                  {hasEvent && !isToday && (
                                    <div className="absolute bottom-0 w-1 h-1 rounded-full bg-rose-500"></div>
                                  )}
                                </div>
                              );
                            })}
                          </div>
                        </div>
                        
                        {/* Upcoming Events */}
                        <div className="space-y-4">
                          <h4 className="text-sm font-semibold text-slate-900 dark:text-white px-2">Upcoming this month</h4>
                          <div className="p-4 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 flex items-center gap-4">
                            <div className="w-12 h-12 rounded-xl bg-rose-50 dark:bg-rose-500/10 flex flex-col items-center justify-center text-rose-600 dark:text-rose-400">
                              <span className="text-xs font-medium">Oct</span>
                              <span className="text-lg font-bold leading-none">18</span>
                            </div>
                            <div>
                              <div className="font-semibold text-slate-900 dark:text-white">Midterm Exam</div>
                              <div className="text-sm text-slate-500 dark:text-neutral-400">Advanced Mathematics</div>
                            </div>
                          </div>
                          <div className="p-4 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 flex items-center gap-4">
                            <div className="w-12 h-12 rounded-xl bg-indigo-50 dark:bg-indigo-500/10 flex flex-col items-center justify-center text-indigo-600 dark:text-indigo-400">
                              <span className="text-xs font-medium">Oct</span>
                              <span className="text-lg font-bold leading-none">24</span>
                            </div>
                            <div>
                              <div className="font-semibold text-slate-900 dark:text-white">Project Deadline</div>
                              <div className="text-sm text-slate-500 dark:text-neutral-400">Web Programming</div>
                            </div>
                          </div>
                        </div>
                      </motion.div>
                    )}
                  </AnimatePresence>
                </div>
              </motion.div>
            )}

            {activeScreen === 'studies' && (
              <motion.div 
                key="studies"
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: 20 }}
                transition={{ duration: 0.3, ease: "easeInOut" }}
                className="absolute inset-0 flex flex-col"
              >
                <div className="flex-1 overflow-y-auto hide-scrollbar pb-32 pt-12 px-6 space-y-8">
                  {/* Study Hub Header */}
                  <header className="flex flex-col gap-2">
                    <div className="flex items-center justify-between">
                      <h1 className="text-2xl font-bold text-slate-900 dark:text-white tracking-tight">Study Hub</h1>
                      <button className="p-2.5 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors shadow-sm">
                        <Search className="w-5 h-5 text-slate-600 dark:text-neutral-300" />
                      </button>
                    </div>
                    <p className="text-sm text-slate-500 dark:text-neutral-400">
                      3 assignments this week • 2 unread materials
                    </p>
                  </header>

                  {/* Mode Toggle */}
                  <div className="flex gap-2.5 bg-white dark:bg-white/5 p-1.5 rounded-2xl border border-slate-200 dark:border-white/10 shadow-sm">
                    {(['Today', 'Study', 'Exams'] as const).map((mode) => (
                      <button
                        key={mode}
                        onClick={() => setStudyMode(mode)}
                        className={`flex-1 py-2 rounded-xl text-sm font-medium transition-all duration-300 ${
                          studyMode === mode
                            ? 'bg-gradient-to-br from-slate-800 via-[#0a0a0a] to-indigo-950 dark:from-white/20 dark:via-white/15 dark:to-white/10 text-white shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_4px_15px_rgba(0,0,0,0.25)] dark:shadow-[0_0_15px_rgba(255,255,255,0.1)]'
                            : 'text-slate-600 dark:text-neutral-400 hover:text-slate-900 dark:hover:text-neutral-200'
                        }`}
                      >
                        {mode}
                      </button>
                    ))}
                  </div>

                  <AnimatePresence mode="wait">
                    {studyMode === 'Study' && (
                      <motion.div
                        key="study-content"
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        transition={{ duration: 0.2 }}
                        className="space-y-8"
                      >
                        {/* Continue Studying */}
                        <section className="space-y-4">
                          <h2 className="text-lg font-semibold text-slate-900 dark:text-white">Continue studying</h2>
                          <div className="flex gap-4 overflow-x-auto hide-scrollbar -mx-6 px-6 pb-4">
                            {/* Card 1 */}
                            <div className="min-w-[200px] p-4 rounded-[24px] bg-white dark:bg-transparent dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border border-slate-200 dark:border-white/10 backdrop-blur-md shadow-sm hover:shadow-md transition-shadow">
                              <div className="w-10 h-10 rounded-full bg-indigo-50 dark:bg-indigo-500/10 flex items-center justify-center mb-3">
                                <BookOpen className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
                              </div>
                              <h3 className="font-semibold text-slate-900 dark:text-white mb-1">Advanced Math</h3>
                              <p className="text-xs text-slate-500 dark:text-neutral-400">2 new notes • Review needed</p>
                            </div>
                            {/* Card 2 */}
                            <div className="min-w-[200px] p-4 rounded-[24px] bg-white dark:bg-transparent dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border border-slate-200 dark:border-white/10 backdrop-blur-md shadow-sm hover:shadow-md transition-shadow">
                              <div className="w-10 h-10 rounded-full bg-rose-50 dark:bg-rose-500/10 flex items-center justify-center mb-3">
                                <FileText className="w-5 h-5 text-rose-600 dark:text-rose-400" />
                              </div>
                              <h3 className="font-semibold text-slate-900 dark:text-white mb-1">Physics</h3>
                              <p className="text-xs text-slate-500 dark:text-neutral-400">1 new file • Chapter 4</p>
                            </div>
                            {/* Card 3 */}
                            <div className="min-w-[200px] p-4 rounded-[24px] bg-white dark:bg-transparent dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border border-slate-200 dark:border-white/10 backdrop-blur-md shadow-sm hover:shadow-md transition-shadow">
                              <div className="w-10 h-10 rounded-full bg-emerald-50 dark:bg-emerald-500/10 flex items-center justify-center mb-3">
                                <PlayCircle className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
                              </div>
                              <h3 className="font-semibold text-slate-900 dark:text-white mb-1">Programming</h3>
                              <p className="text-xs text-slate-500 dark:text-neutral-400">Lecture recording</p>
                            </div>
                          </div>
                        </section>

                        {/* Assignments */}
                        <section className="space-y-4">
                          <div className="flex items-center justify-between">
                            <h2 className="text-lg font-semibold text-slate-900 dark:text-white">Assignments</h2>
                            <button className="text-sm font-medium text-indigo-600 dark:text-indigo-400 hover:text-indigo-700 dark:hover:text-indigo-300 transition-colors">See all</button>
                          </div>
                          <div className="space-y-3">
                            {/* Assignment 1 */}
                            <div className="p-4 rounded-[24px] bg-white dark:bg-transparent dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border border-slate-200 dark:border-white/10 backdrop-blur-md shadow-sm flex items-center justify-between gap-4 hover:shadow-md transition-shadow">
                              <div>
                                <div className="flex items-center gap-2 mb-2">
                                  <span className="inline-block px-2.5 py-1 rounded-lg bg-rose-50 dark:bg-rose-500/10 text-rose-600 dark:text-rose-400 text-[10px] font-bold uppercase tracking-wider border border-rose-100 dark:border-rose-500/20">Overdue</span>
                                  <span className="flex items-center gap-1 text-xs text-rose-600 dark:text-rose-400 font-medium">
                                    <AlertCircle className="w-3.5 h-3.5" /> Yesterday
                                  </span>
                                </div>
                                <h3 className="font-semibold text-slate-900 dark:text-white text-sm mb-1">Calculus Assignment 3</h3>
                                <p className="text-xs text-slate-500 dark:text-neutral-400">Advanced Mathematics</p>
                              </div>
                              <button className="p-2.5 rounded-xl bg-slate-50 dark:bg-white/5 text-slate-600 dark:text-neutral-300 hover:bg-slate-100 dark:hover:bg-white/10 transition-colors border border-slate-200 dark:border-white/5">
                                <ChevronRight className="w-5 h-5" />
                              </button>
                            </div>
                            {/* Assignment 2 */}
                            <div className="p-4 rounded-[24px] bg-white dark:bg-transparent dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border border-slate-200 dark:border-white/10 backdrop-blur-md shadow-sm flex items-center justify-between gap-4 hover:shadow-md transition-shadow">
                              <div>
                                <div className="flex items-center gap-2 mb-2">
                                  <span className="inline-block px-2.5 py-1 rounded-lg bg-indigo-50 dark:bg-indigo-500/10 text-indigo-600 dark:text-indigo-400 text-[10px] font-bold uppercase tracking-wider border border-indigo-100 dark:border-indigo-500/20">In Progress</span>
                                  <span className="text-xs text-slate-500 dark:text-neutral-400 font-medium">Due in 2 days</span>
                                </div>
                                <h3 className="font-semibold text-slate-900 dark:text-white text-sm mb-1">Python Project</h3>
                                <p className="text-xs text-slate-500 dark:text-neutral-400">Web Programming</p>
                              </div>
                              <button className="p-2.5 rounded-xl bg-slate-50 dark:bg-white/5 text-slate-600 dark:text-neutral-300 hover:bg-slate-100 dark:hover:bg-white/10 transition-colors border border-slate-200 dark:border-white/5">
                                <ChevronRight className="w-5 h-5" />
                              </button>
                            </div>
                          </div>
                        </section>

                        {/* Subjects */}
                        <section className="space-y-4">
                          <h2 className="text-lg font-semibold text-slate-900 dark:text-white">Subjects</h2>
                          <div className="space-y-3">
                            {/* Subject 1 */}
                            <div className="p-5 rounded-[28px] bg-white dark:bg-transparent dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border border-slate-200 dark:border-white/10 backdrop-blur-md shadow-sm hover:shadow-md transition-shadow cursor-pointer group">
                              <div className="flex items-start justify-between mb-4">
                                <div>
                                  <h3 className="font-semibold text-slate-900 dark:text-white mb-1 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">Programming Fundamentals</h3>
                                  <p className="text-sm text-slate-500 dark:text-neutral-400">Prof. Urazimbetov M.</p>
                                </div>
                                <div className="w-10 h-10 rounded-full bg-indigo-50 dark:bg-indigo-500/10 flex items-center justify-center border border-indigo-100 dark:border-indigo-500/20">
                                  <span className="text-indigo-600 dark:text-indigo-400 font-bold text-sm">A</span>
                                </div>
                              </div>
                              <div className="flex items-center gap-4 text-xs text-slate-600 dark:text-neutral-300 mb-4">
                                <div className="flex items-center gap-1.5">
                                  <FileText className="w-4 h-4 text-slate-400" />
                                  <span>5 materials</span>
                                </div>
                                <div className="flex items-center gap-1.5">
                                  <CheckCircle2 className="w-4 h-4 text-slate-400" />
                                  <span>2 assignments</span>
                                </div>
                              </div>
                              <div className="flex items-center justify-between pt-4 border-t border-slate-100 dark:border-white/5">
                                <div className="flex items-center gap-2 text-xs font-medium text-emerald-600 dark:text-emerald-400">
                                  <Sparkles className="w-4 h-4" />
                                  <span>AI summary available</span>
                                </div>
                                <span className="text-xs text-slate-500 dark:text-neutral-400">Next: Tomorrow 09:00</span>
                              </div>
                            </div>
                            
                            {/* Subject 2 */}
                            <div className="p-5 rounded-[28px] bg-white dark:bg-transparent dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border border-slate-200 dark:border-white/10 backdrop-blur-md shadow-sm hover:shadow-md transition-shadow cursor-pointer group">
                              <div className="flex items-start justify-between mb-4">
                                <div>
                                  <h3 className="font-semibold text-slate-900 dark:text-white mb-1 group-hover:text-indigo-600 dark:group-hover:text-indigo-400 transition-colors">Database Management</h3>
                                  <p className="text-sm text-slate-500 dark:text-neutral-400">Nurlan K.</p>
                                </div>
                                <div className="w-10 h-10 rounded-full bg-emerald-50 dark:bg-emerald-500/10 flex items-center justify-center border border-emerald-100 dark:border-emerald-500/20">
                                  <span className="text-emerald-600 dark:text-emerald-400 font-bold text-sm">A-</span>
                                </div>
                              </div>
                              <div className="flex items-center gap-4 text-xs text-slate-600 dark:text-neutral-300 mb-4">
                                <div className="flex items-center gap-1.5">
                                  <FileText className="w-4 h-4 text-slate-400" />
                                  <span>3 materials</span>
                                </div>
                                <div className="flex items-center gap-1.5">
                                  <CheckCircle2 className="w-4 h-4 text-slate-400" />
                                  <span>1 assignment</span>
                                </div>
                              </div>
                              <div className="flex items-center justify-between pt-4 border-t border-slate-100 dark:border-white/5">
                                <div className="flex items-center gap-2 text-xs font-medium text-slate-500 dark:text-neutral-400">
                                  <Brain className="w-4 h-4" />
                                  <span>2 weak topics to review</span>
                                </div>
                                <span className="text-xs text-slate-500 dark:text-neutral-400">Next: Today 10:00</span>
                              </div>
                            </div>
                          </div>
                        </section>
                      </motion.div>
                    )}

                    {studyMode === 'Today' && (
                      <motion.div
                        key="today-content"
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        transition={{ duration: 0.2 }}
                        className="space-y-8"
                      >
                        <section className="space-y-4">
                          <h2 className="text-lg font-semibold text-slate-900 dark:text-white">Priority for Today</h2>
                          <div className="p-5 rounded-[24px] bg-indigo-50 dark:bg-indigo-500/10 border border-indigo-100 dark:border-indigo-500/20 shadow-sm">
                            <div className="flex items-center gap-3 mb-3">
                              <AlertCircle className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
                              <h3 className="font-semibold text-indigo-900 dark:text-indigo-100">Calculus Assignment 3</h3>
                            </div>
                            <p className="text-sm text-indigo-700 dark:text-indigo-300 mb-4">Due tonight at 23:59. You have completed 60% of the tasks.</p>
                            <button className="w-full py-3 rounded-xl bg-indigo-600 hover:bg-indigo-700 text-white text-sm font-medium transition-colors shadow-sm">
                              Continue Working
                            </button>
                          </div>
                        </section>

                        <section className="space-y-4">
                          <h2 className="text-lg font-semibold text-slate-900 dark:text-white">Today's Classes</h2>
                          <div className="space-y-3">
                            <div className="p-4 rounded-[20px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 flex items-center gap-4 shadow-sm">
                              <div className="w-12 h-12 rounded-full bg-rose-50 dark:bg-rose-500/10 flex items-center justify-center text-rose-600 dark:text-rose-400 font-bold border border-rose-100 dark:border-rose-500/20">15:00</div>
                              <div>
                                <h4 className="font-semibold text-slate-900 dark:text-white text-sm">Web Programming</h4>
                                <p className="text-xs text-slate-500 dark:text-neutral-400 mt-0.5">Tole bi №86 • Urazimbetov M.</p>
                              </div>
                            </div>
                            <div className="p-4 rounded-[20px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 flex items-center gap-4 shadow-sm">
                              <div className="w-12 h-12 rounded-full bg-emerald-50 dark:bg-emerald-500/10 flex items-center justify-center text-emerald-600 dark:text-emerald-400 font-bold border border-emerald-100 dark:border-emerald-500/20">17:00</div>
                              <div>
                                <h4 className="font-semibold text-slate-900 dark:text-white text-sm">Database Management</h4>
                                <p className="text-xs text-slate-500 dark:text-neutral-400 mt-0.5">Online • Nurlan K.</p>
                              </div>
                            </div>
                          </div>
                        </section>
                      </motion.div>
                    )}

                    {studyMode === 'Exams' && (
                      <motion.div
                        key="exams-content"
                        initial={{ opacity: 0, y: 10 }}
                        animate={{ opacity: 1, y: 0 }}
                        exit={{ opacity: 0, y: -10 }}
                        transition={{ duration: 0.2 }}
                        className="space-y-8"
                      >
                        <section className="space-y-4">
                          <h2 className="text-lg font-semibold text-slate-900 dark:text-white">Upcoming Exams</h2>
                          <div className="space-y-3">
                            <div className="p-5 rounded-[24px] bg-white dark:bg-transparent dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border border-rose-200 dark:border-rose-500/30 shadow-sm relative overflow-hidden">
                              <div className="absolute top-0 right-0 w-24 h-24 bg-rose-500/10 rounded-bl-full -mr-4 -mt-4" />
                              <div className="flex items-center gap-2 mb-3">
                                <span className="px-2.5 py-1 rounded-lg bg-rose-100 dark:bg-rose-500/20 text-rose-700 dark:text-rose-300 text-[10px] font-bold uppercase tracking-wider">Midterm</span>
                                <span className="text-xs font-medium text-slate-500 dark:text-neutral-400">In 3 days</span>
                              </div>
                              <h3 className="font-semibold text-slate-900 dark:text-white mb-1">Advanced Mathematics</h3>
                              <p className="text-sm text-slate-600 dark:text-neutral-300 mb-4">Covers Chapters 1-4. Bring calculator.</p>
                              <div className="flex items-center gap-3">
                                <div className="flex-1 h-2 bg-slate-100 dark:bg-white/10 rounded-full overflow-hidden">
                                  <div className="h-full bg-rose-500 rounded-full" style={{ width: '40%' }} />
                                </div>
                                <span className="text-xs font-medium text-slate-500 dark:text-neutral-400">40% ready</span>
                              </div>
                            </div>
                          </div>
                        </section>

                        <section className="space-y-4">
                          <h2 className="text-lg font-semibold text-slate-900 dark:text-white">AI Weak Topics Review</h2>
                          <div className="grid grid-cols-2 gap-3">
                            <div className="p-4 rounded-[20px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm">
                              <Brain className="w-6 h-6 text-indigo-500 mb-3" />
                              <h4 className="font-semibold text-slate-900 dark:text-white text-sm mb-1">Integrals</h4>
                              <p className="text-xs text-slate-500 dark:text-neutral-400">Math • 3 mistakes</p>
                            </div>
                            <div className="p-4 rounded-[20px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm">
                              <Brain className="w-6 h-6 text-emerald-500 mb-3" />
                              <h4 className="font-semibold text-slate-900 dark:text-white text-sm mb-1">SQL Joins</h4>
                              <p className="text-xs text-slate-500 dark:text-neutral-400">Databases • 2 mistakes</p>
                            </div>
                          </div>
                        </section>
                      </motion.div>
                    )}
                  </AnimatePresence>
                </div>
              </motion.div>
            )}

            {activeScreen === 'services' && (
              <ServicesScreen key="services" />
            )}

            {activeScreen === 'alarm' && (
              <motion.div 
                key="alarm"
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: 20 }}
                transition={{ duration: 0.3, ease: "easeInOut" }}
                className="absolute inset-0 flex flex-col bg-slate-50 dark:bg-[#050505] z-30"
              >
                <div className="flex-1 overflow-y-auto hide-scrollbar pb-32 pt-12 px-6 space-y-8">
                  <header className="flex items-center gap-4 mb-6">
                    <button 
                      onClick={() => setActiveScreen('home')}
                      className="p-2.5 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors shadow-sm"
                    >
                      <ArrowLeft className="w-5 h-5 text-slate-600 dark:text-neutral-300" />
                    </button>
                    <div>
                      <h1 className="text-2xl font-bold text-slate-900 dark:text-white tracking-tight">Smart Alarm</h1>
                      <p className="text-sm text-slate-500 dark:text-neutral-400">
                        Never miss a class or deadline
                      </p>
                    </div>
                  </header>

                  {/* Mode Toggle */}
                  <div className="flex p-1.5 bg-slate-200/50 dark:bg-white/5 rounded-2xl">
                    {['Personal', 'Academic'].map((mode) => (
                      <button
                        key={mode}
                        onClick={() => setAlertMode(mode as 'Personal' | 'Academic')}
                        className={`flex-1 py-2.5 text-sm font-semibold rounded-xl transition-all ${
                          alertMode === mode 
                            ? 'bg-white dark:bg-[#1a1a1a] text-slate-900 dark:text-white shadow-sm' 
                            : 'text-slate-500 dark:text-neutral-400 hover:text-slate-700 dark:hover:text-neutral-300'
                        }`}
                      >
                        {mode}
                      </button>
                    ))}
                  </div>

                  <AnimatePresence mode="wait">
                    {alertMode === 'Academic' && (
                      <motion.div
                        initial={{ opacity: 0, height: 0 }}
                        animate={{ opacity: 1, height: 'auto' }}
                        exit={{ opacity: 0, height: 0 }}
                        className="space-y-3"
                      >
                        <label className="text-sm font-semibold text-slate-700 dark:text-neutral-300 px-1">Alert Type</label>
                        <div className="grid grid-cols-2 gap-3">
                          {['Wake up', 'Exam prep', 'Assignment', 'Lecture'].map((type) => (
                            <button
                              key={type}
                              onClick={() => setAcademicType(type)}
                              className={`py-3 px-4 rounded-2xl text-sm font-medium border transition-all ${
                                academicType === type
                                  ? 'bg-indigo-50 dark:bg-indigo-500/10 border-indigo-200 dark:border-indigo-500/20 text-indigo-700 dark:text-indigo-300'
                                  : 'bg-white dark:bg-white/5 border-slate-200 dark:border-white/10 text-slate-600 dark:text-neutral-400'
                              }`}
                            >
                              {type}
                            </button>
                          ))}
                        </div>
                      </motion.div>
                    )}
                  </AnimatePresence>

                  {/* Time Picker (iOS Style) */}
                  <div className="py-10 flex items-center justify-center gap-2 select-none relative">
                    {/* Highlight overlay */}
                    <div className="absolute top-1/2 left-1/2 -translate-x-1/2 -translate-y-1/2 w-full max-w-[200px] h-[72px] bg-slate-200/50 dark:bg-white/10 rounded-2xl -z-10 pointer-events-none" />
                    
                    {/* Hours */}
                    <div className="flex flex-col items-center gap-4 w-24">
                      <button 
                        onClick={() => handleTimeChange('hours', -1)}
                        className="text-4xl font-bold text-slate-300 dark:text-neutral-700 hover:text-slate-400 dark:hover:text-neutral-600 transition-colors"
                      >
                        {((alarmTime.hours - 1 + 24) % 24).toString().padStart(2, '0')}
                      </button>
                      <div className="text-6xl font-bold text-slate-900 dark:text-white tracking-tight h-[72px] flex items-center justify-center">
                        {alarmTime.hours.toString().padStart(2, '0')}
                      </div>
                      <button 
                        onClick={() => handleTimeChange('hours', 1)}
                        className="text-4xl font-bold text-slate-300 dark:text-neutral-700 hover:text-slate-400 dark:hover:text-neutral-600 transition-colors"
                      >
                        {((alarmTime.hours + 1) % 24).toString().padStart(2, '0')}
                      </button>
                    </div>

                    {/* Colon */}
                    <div className="text-5xl font-bold text-slate-900 dark:text-white h-[72px] flex items-center justify-center pb-2">:</div>

                    {/* Minutes */}
                    <div className="flex flex-col items-center gap-4 w-24">
                      <button 
                        onClick={() => handleTimeChange('minutes', -1)}
                        className="text-4xl font-bold text-slate-300 dark:text-neutral-700 hover:text-slate-400 dark:hover:text-neutral-600 transition-colors"
                      >
                        {((alarmTime.minutes - 1 + 60) % 60).toString().padStart(2, '0')}
                      </button>
                      <div className="text-6xl font-bold text-slate-900 dark:text-white tracking-tight h-[72px] flex items-center justify-center">
                        {alarmTime.minutes.toString().padStart(2, '0')}
                      </div>
                      <button 
                        onClick={() => handleTimeChange('minutes', 1)}
                        className="text-4xl font-bold text-slate-300 dark:text-neutral-700 hover:text-slate-400 dark:hover:text-neutral-600 transition-colors"
                      >
                        {((alarmTime.minutes + 1) % 60).toString().padStart(2, '0')}
                      </button>
                    </div>
                  </div>

                  {/* Set Button */}
                  <button className="w-full py-4 rounded-2xl bg-indigo-600 hover:bg-indigo-700 text-white font-bold text-lg shadow-lg shadow-indigo-500/30 transition-all active:scale-95 flex items-center justify-center gap-2">
                    <Bell className="w-5 h-5" />
                    Set Alarm
                  </button>
                </div>
              </motion.div>
            )}

            {activeScreen === 'profile' && (
              <motion.div 
                key="profile"
                initial={{ opacity: 0, x: 20 }}
                animate={{ opacity: 1, x: 0 }}
                exit={{ opacity: 0, x: 20 }}
                transition={{ duration: 0.3, ease: "easeInOut" }}
                className="absolute inset-0 flex flex-col bg-slate-50 dark:bg-[#050505] z-30"
              >
                {/* Cover Image */}
                <div className="h-56 relative shrink-0 overflow-hidden rounded-b-[2.5rem] shadow-sm group">
                  {/* Background Image */}
                  <img 
                    src={coverImage} 
                    alt="University Campus" 
                    className="absolute inset-0 w-full h-full object-cover transition-transform duration-700 group-hover:scale-105"
                    referrerPolicy="no-referrer"
                  />
                  {/* Gradient Overlays */}
                  <div className="absolute inset-0 bg-gradient-to-b from-black/60 via-transparent to-slate-50 dark:to-[#050505]" />
                  <div className="absolute inset-0 bg-indigo-900/20 mix-blend-overlay" />
                  
                  {/* Top Actions */}
                  <div className="absolute top-0 left-0 right-0 p-6 pt-10 flex justify-between items-start z-10">
                    <div className="px-3 py-1.5 rounded-full bg-black/30 backdrop-blur-md border border-white/10 text-white text-xs font-semibold flex items-center gap-1.5 shadow-lg">
                      <Award className="w-3.5 h-3.5 text-amber-400" />
                      Top 5% Student
                    </div>
                    <div className="flex gap-3">
                      <button className="p-2.5 rounded-full bg-black/30 backdrop-blur-md border border-white/10 text-white hover:bg-white/20 transition-all active:scale-95 shadow-lg">
                        <Share className="w-5 h-5" />
                      </button>
                      <button 
                        onClick={() => setIsSettingsOpen(true)}
                        className="p-2.5 rounded-full bg-black/30 backdrop-blur-md border border-white/10 text-white hover:bg-white/20 transition-all active:scale-95 shadow-lg"
                      >
                        <Settings className="w-5 h-5" />
                      </button>
                    </div>
                  </div>

                  {/* Edit Cover Button */}
                  <button 
                    onClick={() => setIsCoverModalOpen(true)}
                    className="absolute bottom-6 right-6 p-2.5 rounded-full bg-black/30 backdrop-blur-md border border-white/10 text-white hover:bg-white/20 transition-all active:scale-95 shadow-lg z-20 opacity-0 group-hover:opacity-100 translate-y-2 group-hover:translate-y-0"
                  >
                    <Camera className="w-5 h-5" />
                  </button>
                </div>

                <div className="flex-1 overflow-y-auto hide-scrollbar pb-32 px-6 -mt-24 relative z-10 space-y-8">
                  {/* 1. Identity Header */}
                  <div className="flex flex-col items-center text-center">
                    {/* Profile Avatar */}
                    <div className="relative mb-5 group">
                      <div className="w-36 h-36 rounded-full bg-slate-50 dark:bg-[#050505] p-2 shadow-2xl relative z-10 transition-transform duration-300 group-hover:scale-105">
                        <div className="w-full h-full rounded-full overflow-hidden border-2 border-slate-100 dark:border-white/10 relative">
                          <img src="https://picsum.photos/seed/student/300/300" alt="Profile" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                          <div className="absolute inset-0 bg-black/0 group-hover:bg-black/10 transition-colors duration-300" />
                        </div>
                      </div>
                      {/* Decorative Glow */}
                      <div className="absolute inset-0 rounded-full bg-indigo-500/20 blur-xl -z-10" />
                      
                      {/* Online Status */}
                      <div className="absolute bottom-3 right-3 w-8 h-8 rounded-full bg-emerald-500 border-[3px] border-slate-50 dark:border-[#050505] flex items-center justify-center shadow-md z-20" title="Online">
                        <div className="w-2.5 h-2.5 rounded-full bg-white animate-pulse" />
                      </div>
                    </div>
                    
                    {/* Name & Title */}
                    <div className="flex items-center gap-2 justify-center mb-1.5">
                      <h1 className="text-3xl font-extrabold text-slate-900 dark:text-white tracking-tight">Nurlan K.</h1>
                      <div className="bg-blue-500 text-white p-0.5 rounded-full shadow-sm">
                        <CheckCircle2 className="w-4 h-4" />
                      </div>
                    </div>
                    <p className="text-sm text-slate-500 dark:text-neutral-400 font-medium flex items-center justify-center gap-1.5">
                      @nurlan_k <span className="w-1 h-1 rounded-full bg-slate-300 dark:bg-neutral-600" /> KazNPU
                    </p>
                    
                    {/* Tags */}
                    <div className="mt-5 flex flex-wrap justify-center gap-2">
                      <span className="px-3.5 py-1.5 rounded-xl bg-indigo-50 dark:bg-indigo-500/10 text-indigo-700 dark:text-indigo-300 text-xs font-bold border border-indigo-100 dark:border-indigo-500/20 flex items-center gap-1.5 shadow-sm">
                        <Brain className="w-3.5 h-3.5" />
                        Software Engineering
                      </span>
                      <span className="px-3.5 py-1.5 rounded-xl bg-slate-100 dark:bg-white/5 text-slate-700 dark:text-neutral-300 text-xs font-bold border border-slate-200 dark:border-white/10 flex items-center gap-1.5 shadow-sm">
                        <GraduationCap className="w-3.5 h-3.5" />
                        2nd Year
                      </span>
                      <span className="px-3.5 py-1.5 rounded-xl bg-slate-100 dark:bg-white/5 text-slate-700 dark:text-neutral-300 text-xs font-bold border border-slate-200 dark:border-white/10 flex items-center gap-1.5 shadow-sm">
                        <Users className="w-3.5 h-3.5" />
                        SE-31
                      </span>
                    </div>
                    
                    {/* Bio */}
                    <div className="mt-6 relative px-4">
                      <div className="absolute -top-3 left-0 text-4xl text-slate-200 dark:text-white/5 font-serif">"</div>
                      <p className="text-sm text-slate-600 dark:text-neutral-400 max-w-[280px] leading-relaxed italic font-medium relative z-10">
                        Passionate about Frontend, AI, and building things. Always up for a hackathon!
                      </p>
                      <div className="absolute -bottom-4 right-0 text-4xl text-slate-200 dark:text-white/5 font-serif">"</div>
                    </div>
                  </div>

                  {/* 2. Social & Quick Actions */}
                  <div className="flex gap-3">
                    <button className="flex-1 py-3.5 rounded-2xl bg-slate-900 dark:bg-white text-white dark:text-slate-900 text-sm font-semibold transition-colors shadow-sm flex items-center justify-center gap-2">
                      <UserPlus className="w-4 h-4" />
                      Connect
                    </button>
                    <button className="flex-1 py-3.5 rounded-2xl bg-white dark:bg-white/5 text-slate-900 dark:text-white text-sm font-semibold border border-slate-200 dark:border-white/10 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors shadow-sm flex items-center justify-center gap-2">
                      <MessageSquare className="w-4 h-4" />
                      Message
                    </button>
                    <button className="w-14 h-[50px] rounded-2xl bg-white dark:bg-white/5 text-slate-900 dark:text-white border border-slate-200 dark:border-white/10 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors shadow-sm flex items-center justify-center shrink-0">
                      <QrCode className="w-5 h-5" />
                    </button>
                  </div>

                  {/* 3. Real-time Student Status (Signals) */}
                  <div className="space-y-3">
                    <div className="flex items-center justify-between px-1">
                      <h2 className="text-sm font-bold text-slate-900 dark:text-white">Current Status</h2>
                      <button className="text-xs font-semibold text-indigo-600 dark:text-indigo-400">Update</button>
                    </div>
                    <div className="p-4 rounded-[24px] bg-gradient-to-br from-indigo-50 to-purple-50 dark:from-indigo-500/10 dark:to-purple-500/10 border border-indigo-100 dark:border-indigo-500/20 shadow-sm relative overflow-hidden">
                      <div className="absolute top-0 right-0 w-32 h-32 bg-indigo-500/5 rounded-bl-full -mr-8 -mt-8" />
                      <div className="flex items-start justify-between relative z-10">
                        <div className="flex gap-3">
                          <div className="w-10 h-10 rounded-full bg-white dark:bg-white/10 flex items-center justify-center shrink-0 shadow-sm">
                            <BookOpen className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
                          </div>
                          <div>
                            <div className="flex items-center gap-2 mb-1">
                              <div className="w-2 h-2 rounded-full bg-emerald-500 animate-pulse" />
                              <span className="text-xs font-bold text-indigo-900 dark:text-indigo-300 uppercase tracking-wider">In Lecture</span>
                            </div>
                            <h3 className="text-base font-bold text-slate-900 dark:text-white">Databases</h3>
                            <p className="text-sm text-slate-600 dark:text-neutral-400 flex items-center gap-1.5 mt-0.5">
                              <MapPin className="w-3.5 h-3.5" /> Room B-204
                            </p>
                          </div>
                        </div>
                        <div className="text-right">
                          <div className="text-xl font-bold text-indigo-600 dark:text-indigo-400">27<span className="text-sm font-medium text-indigo-400 dark:text-indigo-500">m</span></div>
                          <p className="text-[10px] text-indigo-500/70 dark:text-indigo-400/70 uppercase tracking-wider font-bold mt-0.5">Left</p>
                        </div>
                      </div>
                    </div>
                    
                    {/* Broadcast Signals */}
                    <div className="flex gap-2 overflow-x-auto hide-scrollbar -mx-6 px-6 pb-1">
                      {[
                        { icon: Coffee, label: 'Coffee break', active: false },
                        { icon: Users, label: 'Looking for study group', active: true },
                        { icon: FileText, label: 'Sharing notes', active: false },
                      ].map((signal, i) => (
                        <button key={i} className={`shrink-0 px-4 py-2.5 rounded-xl text-sm font-medium border transition-colors flex items-center gap-2 ${signal.active ? 'bg-slate-900 dark:bg-white border-slate-900 dark:border-white text-white dark:text-slate-900 shadow-sm' : 'bg-white dark:bg-white/5 border-slate-200 dark:border-white/10 text-slate-600 dark:text-neutral-400 hover:bg-slate-50 dark:hover:bg-white/10'}`}>
                          <signal.icon className="w-4 h-4" />
                          {signal.label}
                        </button>
                      ))}
                    </div>
                  </div>

                  {/* 4. Academic Identity (Stats) */}
                  <div className="grid grid-cols-2 gap-3">
                    <div className="p-4 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm flex items-center gap-4">
                      <div className="w-12 h-12 rounded-full bg-emerald-50 dark:bg-emerald-500/10 flex items-center justify-center shrink-0">
                        <Award className="w-6 h-6 text-emerald-600 dark:text-emerald-400" />
                      </div>
                      <div>
                        <div className="text-xl font-bold text-slate-900 dark:text-white">3.8</div>
                        <div className="text-xs text-slate-500 dark:text-neutral-400 font-medium">Current GPA</div>
                      </div>
                    </div>
                    <div className="p-4 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm flex items-center gap-4">
                      <div className="w-12 h-12 rounded-full bg-blue-50 dark:bg-blue-500/10 flex items-center justify-center shrink-0">
                        <CheckCircle2 className="w-6 h-6 text-blue-600 dark:text-blue-400" />
                      </div>
                      <div>
                        <div className="text-xl font-bold text-slate-900 dark:text-white">92%</div>
                        <div className="text-xs text-slate-500 dark:text-neutral-400 font-medium">Attendance</div>
                      </div>
                    </div>
                  </div>

                  {/* 5. Content & Social Layer */}
                  <div className="space-y-4">
                    <div className="flex items-center justify-between px-1">
                      <h2 className="text-sm font-bold text-slate-900 dark:text-white">Recent Activity</h2>
                      <button className="text-xs font-semibold text-slate-500 hover:text-slate-900 dark:hover:text-white transition-colors">View All</button>
                    </div>
                    
                    <div className="space-y-3">
                      {/* Activity Item 1 */}
                      <div className="p-4 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm">
                        <div className="flex items-start gap-3">
                          <div className="w-10 h-10 rounded-full bg-indigo-50 dark:bg-indigo-500/10 flex items-center justify-center shrink-0 mt-1">
                            <FileText className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
                          </div>
                          <div className="flex-1">
                            <div className="flex justify-between items-start mb-1">
                              <h4 className="font-semibold text-slate-900 dark:text-white text-sm">Shared Notes: Databases</h4>
                              <span className="text-xs text-slate-400">2h ago</span>
                            </div>
                            <p className="text-sm text-slate-600 dark:text-neutral-400 mb-3">Compiled all the SQL queries and normalization rules we covered.</p>
                            <div className="flex items-center gap-4">
                              <button className="flex items-center gap-1.5 text-xs font-medium text-slate-500 hover:text-indigo-600 transition-colors">
                                <ThumbsUp className="w-4 h-4" /> 24
                              </button>
                              <button className="flex items-center gap-1.5 text-xs font-medium text-slate-500 hover:text-indigo-600 transition-colors">
                                <MessageSquare className="w-4 h-4" /> 5
                              </button>
                            </div>
                          </div>
                        </div>
                      </div>

                      {/* Activity Item 2 */}
                      <div className="p-4 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm">
                        <div className="flex items-start gap-3">
                          <div className="w-10 h-10 rounded-full bg-purple-50 dark:bg-purple-500/10 flex items-center justify-center shrink-0 mt-1">
                            <Users className="w-5 h-5 text-purple-600 dark:text-purple-400" />
                          </div>
                          <div className="flex-1">
                            <div className="flex justify-between items-start mb-1">
                              <h4 className="font-semibold text-slate-900 dark:text-white text-sm">Joined Study Group</h4>
                              <span className="text-xs text-slate-400">Yesterday</span>
                            </div>
                            <p className="text-sm text-slate-600 dark:text-neutral-400">Advanced Algorithms Prep Group</p>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>

                  {/* Student Services Section */}
                  <div className="pt-2 space-y-3">
                    <div className="flex items-center justify-between px-1">
                      <h2 className="text-sm font-bold text-slate-900 dark:text-white">Student Services</h2>
                    </div>
                    <div className="bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-[24px] overflow-hidden shadow-sm">
                      <button className="w-full flex items-center justify-between p-4 hover:bg-slate-50 dark:hover:bg-white/5 transition-colors">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-indigo-50 dark:bg-indigo-500/10 flex items-center justify-center">
                            <FileBadge className="w-5 h-5 text-indigo-600 dark:text-indigo-400" />
                          </div>
                          <div className="text-left">
                            <div className="font-medium text-slate-900 dark:text-white text-sm">Certificates & Documents</div>
                            <div className="text-xs text-slate-500 dark:text-neutral-400">Transcripts, study certificates</div>
                          </div>
                        </div>
                        <ChevronRight className="w-5 h-5 text-slate-400" />
                      </button>
                      <div className="h-px bg-slate-100 dark:bg-white/5 mx-4" />
                      <button className="w-full flex items-center justify-between p-4 hover:bg-slate-50 dark:hover:bg-white/5 transition-colors">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-emerald-50 dark:bg-emerald-500/10 flex items-center justify-center">
                            <CreditCard className="w-5 h-5 text-emerald-600 dark:text-emerald-400" />
                          </div>
                          <div className="text-left">
                            <div className="font-medium text-slate-900 dark:text-white text-sm">Finance & Payments</div>
                            <div className="text-xs text-slate-500 dark:text-neutral-400">Tuition, dormitory fees</div>
                          </div>
                        </div>
                        <ChevronRight className="w-5 h-5 text-slate-400" />
                      </button>
                      <div className="h-px bg-slate-100 dark:bg-white/5 mx-4" />
                      <button className="w-full flex items-center justify-between p-4 hover:bg-slate-50 dark:hover:bg-white/5 transition-colors">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-rose-50 dark:bg-rose-500/10 flex items-center justify-center">
                            <Building className="w-5 h-5 text-rose-600 dark:text-rose-400" />
                          </div>
                          <div className="text-left">
                            <div className="font-medium text-slate-900 dark:text-white text-sm">Housing & Dormitory</div>
                            <div className="text-xs text-slate-500 dark:text-neutral-400">Requests, rules, status</div>
                          </div>
                        </div>
                        <ChevronRight className="w-5 h-5 text-slate-400" />
                      </button>
                    </div>
                  </div>

                  {/* 6. Settings / Privacy */}
                  <div className="pt-2 space-y-3">
                    <h2 className="text-sm font-bold text-slate-900 dark:text-white px-1">Settings</h2>
                    <div className="bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-[24px] overflow-hidden shadow-sm">
                      <button className="w-full flex items-center justify-between p-4 hover:bg-slate-50 dark:hover:bg-white/5 transition-colors">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-slate-100 dark:bg-white/10 flex items-center justify-center">
                            <Shield className="w-5 h-5 text-slate-600 dark:text-neutral-300" />
                          </div>
                          <div className="text-left">
                            <div className="font-medium text-slate-900 dark:text-white text-sm">Privacy & Security</div>
                          </div>
                        </div>
                        <ChevronRight className="w-5 h-5 text-slate-400" />
                      </button>
                      <div className="h-px bg-slate-100 dark:bg-white/5 mx-4" />
                      <button onClick={toggleTheme} className="w-full flex items-center justify-between p-4 hover:bg-slate-50 dark:hover:bg-white/5 transition-colors">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-slate-100 dark:bg-white/10 flex items-center justify-center">
                            {isDarkMode ? (
                              <Moon className="w-5 h-5 text-slate-600 dark:text-neutral-300" />
                            ) : (
                              <Sun className="w-5 h-5 text-slate-600 dark:text-neutral-300" />
                            )}
                          </div>
                          <span className="font-medium text-slate-900 dark:text-white text-sm">Dark Mode</span>
                        </div>
                        <div className={`w-12 h-6 rounded-full transition-colors ${isDarkMode ? 'bg-indigo-600' : 'bg-slate-200 dark:bg-white/10'} relative`}>
                          <div className={`absolute top-1 w-4 h-4 rounded-full bg-white transition-all ${isDarkMode ? 'left-7' : 'left-1'}`} />
                        </div>
                      </button>
                    </div>
                  </div>

                  <button className="w-full flex items-center justify-center gap-2 p-4 rounded-[24px] bg-rose-50 dark:bg-rose-500/10 text-rose-600 dark:text-rose-400 font-semibold hover:bg-rose-100 dark:hover:bg-rose-500/20 transition-colors border border-rose-100 dark:border-rose-500/20 shadow-sm mt-4">
                    <LogOut className="w-5 h-5" />
                    <span>Log Out</span>
                  </button>
                </div>
              </motion.div>
            )}

            {activeScreen === 'messages' && (
              <motion.div 
                key="messages"
                initial={{ opacity: 0, y: 20 }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: 20 }}
                transition={{ duration: 0.3, ease: "easeInOut" }}
                className="absolute inset-0 flex flex-col bg-slate-50 dark:bg-[#050505] z-40"
              >
                {/* Messages Header */}
              <header className="flex items-center justify-between pt-12 pb-4 px-6 border-b border-slate-200 dark:border-white/10">
                <button onClick={() => setActiveScreen('home')} className="p-2.5 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 hover:bg-slate-50 dark:hover:bg-white/10 transition-colors shadow-sm">
                  <ArrowLeft className="w-5 h-5 text-slate-600 dark:text-neutral-300" />
                </button>
                <h1 className="text-lg font-semibold text-slate-900 dark:text-white">Messages</h1>
                <div className="w-10"></div> {/* Spacer for centering */}
              </header>
              
              {/* Messages List */}
              <div className="flex-1 overflow-y-auto hide-scrollbar p-6 space-y-4">
                {/* Message Item */}
                <div className="flex items-center gap-4 p-4 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm transition-colors cursor-pointer hover:bg-slate-50 dark:hover:bg-white/10">
                  <div className="w-12 h-12 rounded-full overflow-hidden shrink-0 border border-slate-200 dark:border-white/10">
                    <img src="https://picsum.photos/seed/nurali/100/100" alt="Nurali" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-baseline mb-1">
                      <h3 className="text-sm font-semibold text-slate-900 dark:text-white truncate">Nurali Askar</h3>
                      <span className="text-xs text-slate-400 dark:text-neutral-500 shrink-0">10:42 AM</span>
                    </div>
                    <p className="text-sm text-slate-500 dark:text-neutral-400 truncate">Hey, are we still meeting for the project?</p>
                  </div>
                </div>
                
                {/* Message Item 2 */}
                <div className="flex items-center gap-4 p-4 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm transition-colors cursor-pointer hover:bg-slate-50 dark:hover:bg-white/10">
                  <div className="w-12 h-12 rounded-full overflow-hidden shrink-0 border border-slate-200 dark:border-white/10">
                    <img src="https://picsum.photos/seed/aruzhan/100/100" alt="Aruzhan" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-baseline mb-1">
                      <h3 className="text-sm font-semibold text-slate-900 dark:text-white truncate">Aruzhan</h3>
                      <span className="text-xs text-slate-400 dark:text-neutral-500 shrink-0">Yesterday</span>
                    </div>
                    <p className="text-sm text-slate-500 dark:text-neutral-400 truncate">Thanks for the notes!</p>
                  </div>
                </div>
                
                {/* Message Item 3 */}
                <div className="flex items-center gap-4 p-4 rounded-2xl bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm transition-colors cursor-pointer hover:bg-slate-50 dark:hover:bg-white/10">
                  <div className="w-12 h-12 rounded-full bg-indigo-100 dark:bg-indigo-500/20 flex items-center justify-center shrink-0 border border-indigo-200 dark:border-indigo-500/30">
                    <User className="w-6 h-6 text-indigo-600 dark:text-indigo-400" />
                  </div>
                  <div className="flex-1 min-w-0">
                    <div className="flex justify-between items-baseline mb-1">
                      <h3 className="text-sm font-semibold text-slate-900 dark:text-white truncate">University Admin</h3>
                      <span className="text-xs text-slate-400 dark:text-neutral-500 shrink-0">Mon</span>
                    </div>
                    <p className="text-sm text-slate-500 dark:text-neutral-400 truncate">Your schedule has been updated.</p>
                  </div>
                </div>
              </div>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Bottom Navigation */}
          {activeScreen !== 'messages' && activeScreen !== 'alarm' && (
            <div className="absolute bottom-6 left-6 right-6 bg-white/40 dark:bg-[#0a0a0a]/60 backdrop-blur-xl border border-white/50 dark:border-white/10 rounded-[24px] py-4 px-6 shadow-[0_8px_32px_rgba(0,0,0,0.08)] dark:shadow-[0_20px_40px_rgba(0,0,0,0.7)] z-50 transition-colors duration-500">
              <div className="flex items-center justify-between">
                <button onClick={() => setActiveScreen('home')} className="flex flex-col items-center gap-1 group relative">
                  {activeScreen === 'home' ? (
                    <div className="p-2 rounded-xl bg-gradient-to-br from-slate-800 via-[#0a0a0a] to-indigo-950 dark:from-white/20 dark:via-white/15 dark:to-white/10 border border-slate-700/50 dark:border-white/20 text-white shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_4px_15px_rgba(0,0,0,0.25)] dark:shadow-[0_0_15px_rgba(255,255,255,0.1)] transition-colors duration-500">
                      <Home className="w-6 h-6" />
                    </div>
                  ) : (
                    <div className="p-2 rounded-xl text-slate-400 dark:text-neutral-500 hover:text-slate-900 dark:group-hover:text-neutral-300 transition-colors duration-500">
                      <Home className="w-6 h-6" />
                    </div>
                  )}
                </button>
                <button onClick={() => setActiveScreen('schedule')} className="flex flex-col items-center gap-1 group relative">
                  {activeScreen === 'schedule' ? (
                    <div className="p-2 rounded-xl bg-gradient-to-br from-slate-800 via-[#0a0a0a] to-indigo-950 dark:from-white/20 dark:via-white/15 dark:to-white/10 border border-slate-700/50 dark:border-white/20 text-white shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_4px_15px_rgba(0,0,0,0.25)] dark:shadow-[0_0_15px_rgba(255,255,255,0.1)] transition-colors duration-500">
                      <Calendar className="w-6 h-6" />
                    </div>
                  ) : (
                    <div className="p-2 rounded-xl text-slate-400 dark:text-neutral-500 hover:text-slate-900 dark:group-hover:text-neutral-300 transition-colors duration-500">
                      <Calendar className="w-6 h-6" />
                    </div>
                  )}
                </button>
                <button onClick={() => setActiveScreen('studies')} className="flex flex-col items-center gap-1 group relative">
                  {activeScreen === 'studies' ? (
                    <div className="p-2 rounded-xl bg-gradient-to-br from-slate-800 via-[#0a0a0a] to-indigo-950 dark:from-white/20 dark:via-white/15 dark:to-white/10 border border-slate-700/50 dark:border-white/20 text-white shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_4px_15px_rgba(0,0,0,0.25)] dark:shadow-[0_0_15px_rgba(255,255,255,0.1)] transition-colors duration-500">
                      <BookOpen className="w-6 h-6" />
                    </div>
                  ) : (
                    <div className="p-2 rounded-xl text-slate-400 dark:text-neutral-500 hover:text-slate-900 dark:group-hover:text-neutral-300 transition-colors duration-500">
                      <BookOpen className="w-6 h-6" />
                    </div>
                  )}
                </button>
                <button onClick={() => setActiveScreen('services')} className="flex flex-col items-center gap-1 group relative">
                  {activeScreen === 'services' ? (
                    <div className="p-2 rounded-xl bg-gradient-to-br from-slate-800 via-[#0a0a0a] to-indigo-950 dark:from-white/20 dark:via-white/15 dark:to-white/10 border border-slate-700/50 dark:border-white/20 text-white shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_4px_15px_rgba(0,0,0,0.25)] dark:shadow-[0_0_15px_rgba(255,255,255,0.1)] transition-colors duration-500">
                      <Compass className="w-6 h-6" />
                    </div>
                  ) : (
                    <div className="p-2 rounded-xl text-slate-400 dark:text-neutral-500 hover:text-slate-900 dark:group-hover:text-neutral-300 transition-colors duration-500">
                      <Compass className="w-6 h-6" />
                    </div>
                  )}
                </button>
                <button onClick={() => setActiveScreen('profile')} className="flex flex-col items-center gap-1 group relative">
                  {activeScreen === 'profile' ? (
                    <div className="p-2 rounded-xl bg-gradient-to-br from-slate-800 via-[#0a0a0a] to-indigo-950 dark:from-white/20 dark:via-white/15 dark:to-white/10 border border-slate-700/50 dark:border-white/20 text-white shadow-[inset_0_1px_1px_rgba(255,255,255,0.15),0_4px_15px_rgba(0,0,0,0.25)] dark:shadow-[0_0_15px_rgba(255,255,255,0.1)] transition-colors duration-500">
                      <User className="w-6 h-6" />
                    </div>
                  ) : (
                    <div className="p-2 rounded-xl text-slate-400 dark:text-neutral-500 hover:text-slate-900 dark:group-hover:text-neutral-300 transition-colors duration-500">
                      <User className="w-6 h-6" />
                    </div>
                  )}
                </button>
              </div>
            </div>
          )}

          {/* Quick Alert Bottom Sheet */}
          <AnimatePresence>
            {isAlertSheetOpen && (
              <motion.div 
                initial={{ opacity: 0 }}
                animate={{ opacity: 1 }}
                exit={{ opacity: 0 }}
                className="absolute inset-0 bg-black/40 backdrop-blur-sm z-50 flex items-end justify-center"
                onClick={() => setIsAlertSheetOpen(false)}
              >
                <motion.div 
                  initial={{ y: "100%" }}
                  animate={{ y: 0 }}
                  exit={{ y: "100%" }}
                  transition={{ type: "spring", damping: 25, stiffness: 200 }}
                  onClick={(e) => e.stopPropagation()}
                  className="w-full max-w-md bg-white dark:bg-[#0a0a0a] rounded-t-[32px] overflow-hidden shadow-2xl border-t border-slate-200 dark:border-white/10"
                >
                  <div className="p-6 pb-8">
                    <div className="w-12 h-1.5 bg-slate-200 dark:bg-white/20 rounded-full mx-auto mb-6" />
                    
                    <div className="flex items-center gap-4 mb-6">
                      <div className="w-12 h-12 rounded-2xl bg-indigo-50 dark:bg-indigo-500/10 flex items-center justify-center text-indigo-600 dark:text-indigo-400">
                        <Bell className="w-6 h-6" />
                      </div>
                      <div>
                        <h3 className="text-lg font-bold text-slate-900 dark:text-white">Quick Alert</h3>
                        <p className="text-sm text-slate-500 dark:text-neutral-400">
                          {lessons.find(l => l.id === alertTargetId)?.title}
                        </p>
                      </div>
                    </div>

                    <div className="space-y-2 mb-6">
                      <h4 className="text-xs font-bold text-slate-400 dark:text-neutral-500 uppercase tracking-wider mb-3">Smart Suggestions</h4>
                      
                      {[
                        { label: '5 min before', icon: Clock },
                        { label: '10 min before', icon: Clock },
                        { label: '20 min before', icon: Clock },
                        { label: '30 min before', icon: Clock },
                        { label: '1 hour before', icon: Clock },
                        { label: 'Leave on time', icon: MapPin },
                        { label: 'Wake up before class', icon: Sun }
                      ].map((preset, idx) => (
                        <button 
                          key={idx}
                          onClick={() => {
                            setLessons(prev => prev.map(l => l.id === alertTargetId ? { ...l, alert: preset.label } : l));
                            setIsAlertSheetOpen(false);
                          }}
                          className="w-full flex items-center justify-between p-4 rounded-2xl bg-slate-50 dark:bg-white/5 hover:bg-slate-100 dark:hover:bg-white/10 transition-colors text-left group"
                        >
                          <div className="flex items-center gap-3">
                            <preset.icon className="w-5 h-5 text-slate-400 dark:text-neutral-500 group-hover:text-indigo-500 transition-colors" />
                            <span className="font-semibold text-slate-700 dark:text-neutral-200">{preset.label}</span>
                          </div>
                          <ChevronRight className="w-5 h-5 text-slate-300 dark:text-neutral-600 group-hover:text-indigo-500 transition-colors" />
                        </button>
                      ))}
                    </div>

                    <button className="w-full py-4 rounded-2xl border-2 border-dashed border-slate-200 dark:border-white/10 text-slate-500 dark:text-neutral-400 font-semibold hover:border-indigo-500 hover:text-indigo-500 dark:hover:border-indigo-500 dark:hover:text-indigo-400 transition-colors mb-3">
                      Custom Time
                    </button>

                    {lessons.find(l => l.id === alertTargetId)?.alert && (
                      <button 
                        onClick={() => {
                          if (alertTargetId) handleRemoveAlert(alertTargetId);
                          setIsAlertSheetOpen(false);
                        }}
                        className="w-full py-4 rounded-2xl bg-rose-50 dark:bg-rose-500/10 text-rose-600 dark:text-rose-400 font-semibold hover:bg-rose-100 dark:hover:bg-rose-500/20 transition-colors"
                      >
                        Remove Alert
                      </button>
                    )}
                  </div>
                </motion.div>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Settings Modal */}
          <AnimatePresence>
            {isSettingsOpen && (
              <motion.div
                initial={{ opacity: 0, y: '100%' }}
                animate={{ opacity: 1, y: 0 }}
                exit={{ opacity: 0, y: '100%' }}
                transition={{ type: 'spring', damping: 25, stiffness: 200 }}
                className="absolute inset-0 z-50 flex flex-col bg-slate-50 dark:bg-[#050505]"
              >
                {/* Header */}
                <div className="flex items-center justify-between px-6 py-4 bg-white dark:bg-[#0a0a0a] border-b border-slate-200 dark:border-white/10">
                  <div className="flex items-center gap-4">
                    <button 
                      onClick={() => setIsSettingsOpen(false)}
                      className="p-2 -ml-2 rounded-full hover:bg-slate-100 dark:hover:bg-white/10 text-slate-600 dark:text-neutral-300 transition-colors"
                    >
                      <ArrowLeft className="w-6 h-6" />
                    </button>
                    <h2 className="text-xl font-bold text-slate-900 dark:text-white">Settings</h2>
                  </div>
                </div>

                {/* Content */}
                <div className="flex-1 overflow-y-auto p-6 space-y-6 hide-scrollbar">
                  
                  {/* Profile Card */}
                  <div className="bg-white dark:bg-white/5 rounded-[24px] p-4 flex items-center gap-4 border border-slate-200 dark:border-white/10 shadow-sm">
                    <div className="w-16 h-16 rounded-full overflow-hidden">
                      <img src="https://picsum.photos/seed/student/200/200" alt="Profile" className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                    </div>
                    <div className="flex-1">
                      <h3 className="font-bold text-slate-900 dark:text-white text-lg">Nurlan K.</h3>
                      <p className="text-sm text-slate-500 dark:text-neutral-400">Software Engineering</p>
                    </div>
                    <button className="p-2 rounded-full bg-slate-100 dark:bg-white/10 text-indigo-600 dark:text-indigo-400">
                      <Edit2 className="w-5 h-5" />
                    </button>
                  </div>

                  {/* Preferences */}
                  <div className="space-y-2">
                    <h4 className="text-xs font-bold text-slate-400 dark:text-neutral-500 uppercase tracking-wider ml-2">Preferences</h4>
                    <div className="bg-white dark:bg-white/5 rounded-[24px] border border-slate-200 dark:border-white/10 overflow-hidden shadow-sm">
                      
                      {/* Dark Mode Toggle */}
                      <div className="flex items-center justify-between p-4 border-b border-slate-100 dark:border-white/5">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-indigo-50 dark:bg-indigo-500/20 flex items-center justify-center text-indigo-600 dark:text-indigo-400">
                            {isDarkMode ? <Moon className="w-5 h-5" /> : <Sun className="w-5 h-5" />}
                          </div>
                          <span className="font-medium text-slate-900 dark:text-white">Dark Mode</span>
                        </div>
                        <button 
                          onClick={toggleTheme}
                          className={`w-12 h-6 rounded-full relative transition-colors duration-300 ${isDarkMode ? 'bg-indigo-600' : 'bg-slate-300 dark:bg-slate-700'}`}
                        >
                          <div className={`absolute top-1 w-4 h-4 rounded-full bg-white transition-transform duration-300 ${isDarkMode ? 'left-7' : 'left-1'}`} />
                        </button>
                      </div>

                      {/* Language */}
                      <button className="w-full flex items-center justify-between p-4 border-b border-slate-100 dark:border-white/5 hover:bg-slate-50 dark:hover:bg-white/5 transition-colors">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-emerald-50 dark:bg-emerald-500/20 flex items-center justify-center text-emerald-600 dark:text-emerald-400">
                            <Globe className="w-5 h-5" />
                          </div>
                          <span className="font-medium text-slate-900 dark:text-white">Language</span>
                        </div>
                        <div className="flex items-center gap-2 text-slate-500 dark:text-neutral-400">
                          <span className="text-sm">English</span>
                          <ChevronRight className="w-4 h-4" />
                        </div>
                      </button>

                      {/* Notifications */}
                      <button className="w-full flex items-center justify-between p-4 hover:bg-slate-50 dark:hover:bg-white/5 transition-colors">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-rose-50 dark:bg-rose-500/20 flex items-center justify-center text-rose-600 dark:text-rose-400">
                            <Bell className="w-5 h-5" />
                          </div>
                          <span className="font-medium text-slate-900 dark:text-white">Notifications</span>
                        </div>
                        <ChevronRight className="w-4 h-4 text-slate-400" />
                      </button>
                    </div>
                  </div>

                  {/* Security & Privacy */}
                  <div className="space-y-2">
                    <h4 className="text-xs font-bold text-slate-400 dark:text-neutral-500 uppercase tracking-wider ml-2">Security</h4>
                    <div className="bg-white dark:bg-white/5 rounded-[24px] border border-slate-200 dark:border-white/10 overflow-hidden shadow-sm">
                      <button className="w-full flex items-center justify-between p-4 border-b border-slate-100 dark:border-white/5 hover:bg-slate-50 dark:hover:bg-white/5 transition-colors">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-amber-50 dark:bg-amber-500/20 flex items-center justify-center text-amber-600 dark:text-amber-400">
                            <Shield className="w-5 h-5" />
                          </div>
                          <span className="font-medium text-slate-900 dark:text-white">Password & Security</span>
                        </div>
                        <ChevronRight className="w-4 h-4 text-slate-400" />
                      </button>
                      <button className="w-full flex items-center justify-between p-4 hover:bg-slate-50 dark:hover:bg-white/5 transition-colors">
                        <div className="flex items-center gap-3">
                          <div className="w-10 h-10 rounded-full bg-blue-50 dark:bg-blue-500/20 flex items-center justify-center text-blue-600 dark:text-blue-400">
                            <Lock className="w-5 h-5" />
                          </div>
                          <span className="font-medium text-slate-900 dark:text-white">Privacy Settings</span>
                        </div>
                        <ChevronRight className="w-4 h-4 text-slate-400" />
                      </button>
                    </div>
                  </div>

                  {/* Logout */}
                  <div className="pt-4 pb-8">
                    <button className="w-full flex items-center justify-center gap-2 p-4 rounded-[20px] bg-rose-50 dark:bg-rose-500/10 text-rose-600 dark:text-rose-400 font-bold hover:bg-rose-100 dark:hover:bg-rose-500/20 transition-colors">
                      <LogOut className="w-5 h-5" />
                      <span>Log Out</span>
                    </button>
                  </div>

                </div>
              </motion.div>
            )}
          </AnimatePresence>

          {/* Edit Cover Modal */}
          <AnimatePresence>
            {isCoverModalOpen && (
              <>
                <motion.div
                  initial={{ opacity: 0 }}
                  animate={{ opacity: 1 }}
                  exit={{ opacity: 0 }}
                  onClick={() => setIsCoverModalOpen(false)}
                  className="absolute inset-0 bg-black/60 z-[60] backdrop-blur-sm"
                />
                <motion.div
                  initial={{ opacity: 0, y: '100%' }}
                  animate={{ opacity: 1, y: 0 }}
                  exit={{ opacity: 0, y: '100%' }}
                  transition={{ type: 'spring', damping: 25, stiffness: 200 }}
                  className="absolute bottom-0 left-0 right-0 z-[70] bg-white dark:bg-[#0a0a0a] rounded-t-[2rem] overflow-hidden flex flex-col max-h-[85vh] shadow-2xl"
                >
                  <div className="p-6 pb-4 border-b border-slate-100 dark:border-white/5 flex justify-between items-center bg-white/80 dark:bg-[#0a0a0a]/80 backdrop-blur-md sticky top-0 z-10">
                    <h3 className="text-xl font-bold text-slate-900 dark:text-white">Edit Cover</h3>
                    <button onClick={() => setIsCoverModalOpen(false)} className="p-2 rounded-full bg-slate-100 dark:bg-white/5 text-slate-500 dark:text-neutral-400 hover:bg-slate-200 dark:hover:bg-white/10 transition-colors">
                      <X className="w-5 h-5" />
                    </button>
                  </div>
                  <div className="p-6 overflow-y-auto hide-scrollbar">
                    <label className="w-full py-6 rounded-3xl border-2 border-dashed border-slate-300 dark:border-white/20 flex flex-col items-center justify-center gap-3 text-slate-500 dark:text-neutral-400 hover:bg-slate-50 dark:hover:bg-white/5 hover:border-indigo-500 dark:hover:border-indigo-500 transition-all mb-8 group cursor-pointer">
                      <input 
                        type="file" 
                        accept="image/*" 
                        className="hidden" 
                        onChange={handleImageUpload}
                      />
                      <div className="w-12 h-12 rounded-full bg-slate-100 dark:bg-white/5 flex items-center justify-center group-hover:bg-indigo-50 dark:group-hover:bg-indigo-500/20 group-hover:text-indigo-500 transition-colors">
                        <Upload className="w-6 h-6" />
                      </div>
                      <div className="text-center">
                        <span className="font-semibold text-slate-700 dark:text-neutral-300 block">Upload from device</span>
                        <span className="text-xs mt-1 block">JPG, PNG or GIF (max. 5MB)</span>
                      </div>
                    </label>
                    
                    <h4 className="text-sm font-bold text-slate-900 dark:text-white mb-4 uppercase tracking-wider">Choose from templates</h4>
                    <div className="grid grid-cols-2 gap-4">
                      {coverTemplates.map((template, idx) => (
                        <button 
                          key={idx}
                          onClick={() => {
                            setCoverImage(template);
                            setIsCoverModalOpen(false);
                          }}
                          className={`relative aspect-[4/3] rounded-2xl overflow-hidden border-[3px] transition-all duration-300 ${coverImage === template ? 'border-indigo-500 scale-[0.98] shadow-md' : 'border-transparent hover:scale-[0.98] shadow-sm'}`}
                        >
                          <img src={template} alt={`Template ${idx + 1}`} className="w-full h-full object-cover" referrerPolicy="no-referrer" />
                          {coverImage === template && (
                            <div className="absolute inset-0 bg-indigo-500/20 flex items-center justify-center backdrop-blur-[2px]">
                              <div className="bg-indigo-500 text-white p-1.5 rounded-full shadow-lg scale-110">
                                <CheckCircle2 className="w-6 h-6" />
                              </div>
                            </div>
                          )}
                        </button>
                      ))}
                    </div>
                  </div>
                </motion.div>
              </>
            )}
          </AnimatePresence>
            </motion.div>
          )}

        </div>
      </div>
    </div>
  );
}
