import React, { useState } from 'react';
import { motion, AnimatePresence } from 'motion/react';
import { 
  Search, FileBadge, CreditCard, Building, HelpCircle, 
  FileText, ChevronLeft, CheckCircle2, AlertCircle, Clock,
  Download, Plus, Send
} from 'lucide-react';

type ServiceView = 'main' | 'documents' | 'payments' | 'housing' | 'support' | 'all-requests';

const recentRequestsData = [
  { id: 1, title: 'Enrollment Certificate', date: 'Oct 12', status: 'Ready', icon: FileText, type: 'document', desc: 'Requested for visa application.' },
  { id: 2, title: 'Dormitory Repair', date: 'Oct 10', status: 'In Progress', icon: Building, type: 'housing', desc: 'Leaking pipe in bathroom.' },
];

const servicesList = [
  { id: 'documents', icon: FileBadge, title: "Documents", subtitle: "Certificates & references", color: "indigo" },
  { id: 'payments', icon: CreditCard, title: "Payments", subtitle: "Tuition & dormitory", color: "emerald" },
  { id: 'housing', icon: Building, title: "Housing", subtitle: "Dormitory requests", color: "amber" },
  { id: 'support', icon: HelpCircle, title: "Support", subtitle: "IT & Academic help", color: "rose" },
];

export const ServicesScreen: React.FC = () => {
  const [activeView, setActiveView] = useState<ServiceView>('main');
  const [searchQuery, setSearchQuery] = useState('');
  const [requests, setRequests] = useState(recentRequestsData);
  const [showSuccessModal, setShowSuccessModal] = useState(false);
  const [successMessage, setSuccessMessage] = useState('');
  const [selectedRequest, setSelectedRequest] = useState<any>(null);

  // Form states
  const [housingIssueType, setHousingIssueType] = useState('Plumbing');
  const [housingDesc, setHousingDesc] = useState('');
  const [supportSubject, setSupportSubject] = useState('');
  const [supportMessage, setSupportMessage] = useState('');

  const handleSuccess = (message: string, newRequest?: any) => {
    if (newRequest) {
      setRequests(prev => [newRequest, ...prev]);
    }
    setSuccessMessage(message);
    setShowSuccessModal(true);
    setTimeout(() => {
      setShowSuccessModal(false);
      setActiveView('main');
    }, 2000);
  };

  const renderMain = () => (
    <motion.div 
      key="main"
      initial={{ opacity: 0, x: -20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: -20 }}
      className="flex-1 overflow-y-auto hide-scrollbar pb-32 pt-12 px-6 space-y-8"
    >
      <header className="flex flex-col gap-4">
        <div className="flex items-center justify-between">
          <h1 className="text-2xl font-bold text-slate-900 dark:text-white tracking-tight">Services</h1>
        </div>
        <div className="relative">
          <Search className="absolute left-4 top-1/2 -translate-y-1/2 w-5 h-5 text-slate-400" />
          <input 
            type="text" 
            placeholder="Search services..." 
            value={searchQuery}
            onChange={(e) => setSearchQuery(e.target.value)}
            className="w-full bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 rounded-2xl py-3.5 pl-12 pr-4 text-slate-900 dark:text-white placeholder:text-slate-500 focus:outline-none focus:border-indigo-500/50 transition-all shadow-sm"
          />
        </div>
      </header>

      <div className="grid grid-cols-2 gap-4">
        {servicesList
          .filter(s => s.title.toLowerCase().includes(searchQuery.toLowerCase()) || s.subtitle.toLowerCase().includes(searchQuery.toLowerCase()))
          .map(service => (
            <ServiceCard 
              key={service.id}
              icon={service.icon} 
              title={service.title} 
              subtitle={service.subtitle} 
              color={service.color} 
              onClick={() => setActiveView(service.id as ServiceView)} 
            />
        ))}
        {searchQuery && servicesList.filter(s => s.title.toLowerCase().includes(searchQuery.toLowerCase()) || s.subtitle.toLowerCase().includes(searchQuery.toLowerCase())).length === 0 && (
          <div className="col-span-2 text-center py-8 text-slate-500 dark:text-neutral-400">
            No services found matching "{searchQuery}"
          </div>
        )}
      </div>

      <section className="space-y-4">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-semibold text-slate-900 dark:text-white">Recent Requests</h2>
          <button onClick={() => setActiveView('all-requests')} className="text-sm font-medium text-indigo-600 dark:text-indigo-400">View All</button>
        </div>
        <div className="space-y-3">
          {requests.slice(0, 3).map((req) => (
            <div 
              key={req.id} 
              onClick={() => setSelectedRequest(req)}
              className="p-4 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 flex items-center justify-between shadow-sm cursor-pointer hover:bg-slate-50 dark:hover:bg-white/10 transition-colors"
            >
              <div className="flex items-center gap-4">
                <div className="w-10 h-10 rounded-full bg-slate-100 dark:bg-black/20 flex items-center justify-center text-slate-500 dark:text-neutral-400">
                  <req.icon className="w-5 h-5" />
                </div>
                <div>
                  <h4 className="font-medium text-slate-900 dark:text-white">{req.title}</h4>
                  <p className="text-xs text-slate-500 dark:text-neutral-400">Requested on {req.date}</p>
                </div>
              </div>
              <div className={`px-3 py-1 rounded-full text-xs font-semibold ${
                req.status === 'Ready' 
                  ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400'
                  : req.status === 'Pending' || req.status === 'Processing' || req.status === 'Open'
                  ? 'bg-blue-50 dark:bg-blue-500/10 text-blue-600 dark:text-blue-400'
                  : 'bg-amber-50 dark:bg-amber-500/10 text-amber-600 dark:text-amber-400'
              }`}>
                {req.status}
              </div>
            </div>
          ))}
        </div>
      </section>
    </motion.div>
  );

  const renderDocuments = () => (
    <motion.div 
      key="documents"
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: 20 }}
      className="flex-1 flex flex-col bg-slate-50 dark:bg-[#050505] absolute inset-0 z-40"
    >
      <div className="pt-12 pb-6 px-6 bg-white/80 dark:bg-[#050505]/80 backdrop-blur-xl border-b border-slate-200 dark:border-white/10 sticky top-0 z-10 flex items-center gap-4">
        <button onClick={() => setActiveView('main')} className="p-2 -ml-2 rounded-full hover:bg-slate-100 dark:hover:bg-white/10 transition-colors">
          <ChevronLeft className="w-6 h-6 text-slate-900 dark:text-white" />
        </button>
        <h2 className="text-xl font-bold text-slate-900 dark:text-white">Documents</h2>
      </div>
      <div className="flex-1 overflow-y-auto p-6 space-y-6 pb-32">
        <div className="space-y-4">
          <h3 className="text-sm font-bold text-slate-400 uppercase tracking-wider">Available to request</h3>
          {[
            { title: 'Enrollment Certificate', desc: 'Proof of student status' },
            { title: 'Official Transcript', desc: 'Academic record with grades' },
            { title: 'Military Deferment', desc: 'For military service exemption' },
          ].map((doc, i) => (
            <div key={i} className="p-4 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 flex items-center justify-between shadow-sm">
              <div>
                <h4 className="font-medium text-slate-900 dark:text-white">{doc.title}</h4>
                <p className="text-xs text-slate-500 dark:text-neutral-400 mt-0.5">{doc.desc}</p>
              </div>
              <button 
                onClick={() => handleSuccess(`${doc.title} requested successfully`, {
                  id: Date.now(),
                  title: doc.title,
                  date: 'Just now',
                  status: 'Pending',
                  icon: FileText,
                  type: 'document',
                  desc: 'Requested via Services app.'
                })}
                className="w-10 h-10 rounded-full bg-indigo-50 dark:bg-indigo-500/10 flex items-center justify-center text-indigo-600 dark:text-indigo-400 hover:bg-indigo-100 dark:hover:bg-indigo-500/20 transition-colors"
              >
                <Plus className="w-5 h-5" />
              </button>
            </div>
          ))}
        </div>
      </div>
    </motion.div>
  );

  const renderPayments = () => (
    <motion.div 
      key="payments"
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: 20 }}
      className="flex-1 flex flex-col bg-slate-50 dark:bg-[#050505] absolute inset-0 z-40"
    >
      <div className="pt-12 pb-6 px-6 bg-white/80 dark:bg-[#050505]/80 backdrop-blur-xl border-b border-slate-200 dark:border-white/10 sticky top-0 z-10 flex items-center gap-4">
        <button onClick={() => setActiveView('main')} className="p-2 -ml-2 rounded-full hover:bg-slate-100 dark:hover:bg-white/10 transition-colors">
          <ChevronLeft className="w-6 h-6 text-slate-900 dark:text-white" />
        </button>
        <h2 className="text-xl font-bold text-slate-900 dark:text-white">Payments</h2>
      </div>
      <div className="flex-1 overflow-y-auto p-6 space-y-6 pb-32">
        <div className="p-6 rounded-[32px] bg-gradient-to-br from-emerald-500 to-teal-600 text-white shadow-lg shadow-emerald-500/20 relative overflow-hidden">
          <div className="absolute top-0 right-0 w-32 h-32 bg-white/10 rounded-full blur-2xl -mr-10 -mt-10" />
          <h3 className="text-emerald-50 font-medium mb-1 relative z-10">Current Balance</h3>
          <div className="text-4xl font-bold mb-6 relative z-10">0 ₸</div>
          <div className="flex items-center gap-2 text-sm font-medium bg-white/20 w-fit px-3 py-1.5 rounded-full backdrop-blur-md relative z-10">
            <CheckCircle2 className="w-4 h-4" />
            All fees paid
          </div>
        </div>

        <div className="space-y-4">
          <h3 className="text-sm font-bold text-slate-400 uppercase tracking-wider">Upcoming Fees</h3>
          <div className="p-5 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm">
            <div className="flex justify-between items-start mb-4">
              <div>
                <h4 className="font-semibold text-slate-900 dark:text-white">Spring Semester 2026</h4>
                <p className="text-sm text-slate-500 dark:text-neutral-400 mt-0.5">Tuition Fee</p>
              </div>
              <span className="font-bold text-slate-900 dark:text-white">450,000 ₸</span>
            </div>
            <div className="flex items-center gap-2 text-sm text-amber-600 dark:text-amber-400 mb-4 bg-amber-50 dark:bg-amber-500/10 p-2 rounded-xl">
              <Clock className="w-4 h-4" />
              Due in 45 days (May 10, 2026)
            </div>
            <button 
              onClick={() => handleSuccess("Payment initiated", {
                id: Date.now(),
                title: 'Tuition Fee Payment',
                date: 'Just now',
                status: 'Processing',
                icon: CreditCard,
                type: 'payment',
                desc: 'Payment of 450,000 ₸ for Spring Semester 2026.'
              })}
              className="w-full py-3 rounded-xl bg-slate-900 dark:bg-white text-white dark:text-black font-semibold hover:bg-slate-800 dark:hover:bg-slate-200 transition-colors"
            >
              Pay Now
            </button>
          </div>
        </div>
      </div>
    </motion.div>
  );

  const renderHousing = () => (
    <motion.div 
      key="housing"
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: 20 }}
      className="flex-1 flex flex-col bg-slate-50 dark:bg-[#050505] absolute inset-0 z-40"
    >
      <div className="pt-12 pb-6 px-6 bg-white/80 dark:bg-[#050505]/80 backdrop-blur-xl border-b border-slate-200 dark:border-white/10 sticky top-0 z-10 flex items-center gap-4">
        <button onClick={() => setActiveView('main')} className="p-2 -ml-2 rounded-full hover:bg-slate-100 dark:hover:bg-white/10 transition-colors">
          <ChevronLeft className="w-6 h-6 text-slate-900 dark:text-white" />
        </button>
        <h2 className="text-xl font-bold text-slate-900 dark:text-white">Housing</h2>
      </div>
      <div className="flex-1 overflow-y-auto p-6 space-y-6 pb-32">
        <div className="p-5 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm flex items-center gap-4">
          <div className="w-14 h-14 rounded-2xl bg-amber-50 dark:bg-amber-500/10 flex items-center justify-center text-amber-600 dark:text-amber-400">
            <Building className="w-7 h-7" />
          </div>
          <div>
            <h3 className="font-bold text-slate-900 dark:text-white text-lg">Dormitory #3</h3>
            <p className="text-sm text-slate-500 dark:text-neutral-400">Room 412 • Floor 4</p>
          </div>
        </div>

        <div className="space-y-4">
          <h3 className="text-sm font-bold text-slate-400 uppercase tracking-wider">Maintenance Request</h3>
          <div className="p-5 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm space-y-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-neutral-300 mb-1.5">Issue Type</label>
              <select 
                value={housingIssueType}
                onChange={(e) => setHousingIssueType(e.target.value)}
                className="w-full bg-slate-50 dark:bg-black/20 border border-slate-200 dark:border-white/10 rounded-xl py-3 px-4 text-slate-900 dark:text-white focus:outline-none focus:border-indigo-500/50 transition-all appearance-none"
              >
                <option>Plumbing</option>
                <option>Electrical</option>
                <option>Furniture</option>
                <option>Other</option>
              </select>
            </div>
            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-neutral-300 mb-1.5">Description</label>
              <textarea 
                rows={3}
                value={housingDesc}
                onChange={(e) => setHousingDesc(e.target.value)}
                placeholder="Describe the issue..."
                className="w-full bg-slate-50 dark:bg-black/20 border border-slate-200 dark:border-white/10 rounded-xl py-3 px-4 text-slate-900 dark:text-white placeholder:text-slate-500 focus:outline-none focus:border-indigo-500/50 transition-all resize-none"
              />
            </div>
            <button 
              onClick={() => {
                if (!housingDesc.trim()) return;
                handleSuccess("Maintenance request submitted", {
                  id: Date.now(),
                  title: `Maintenance: ${housingIssueType}`,
                  date: 'Just now',
                  status: 'Pending',
                  icon: Building,
                  type: 'housing',
                  desc: `Dormitory #3, Room 412. ${housingDesc}`
                });
                setHousingDesc('');
                setHousingIssueType('Plumbing');
              }}
              disabled={!housingDesc.trim()}
              className="w-full py-3 rounded-xl bg-indigo-600 text-white font-semibold hover:bg-indigo-700 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2"
            >
              <Send className="w-4 h-4" />
              Submit Request
            </button>
          </div>
        </div>
      </div>
    </motion.div>
  );

  const renderSupport = () => (
    <motion.div 
      key="support"
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: 20 }}
      className="flex-1 flex flex-col bg-slate-50 dark:bg-[#050505] absolute inset-0 z-40"
    >
      <div className="pt-12 pb-6 px-6 bg-white/80 dark:bg-[#050505]/80 backdrop-blur-xl border-b border-slate-200 dark:border-white/10 sticky top-0 z-10 flex items-center gap-4">
        <button onClick={() => setActiveView('main')} className="p-2 -ml-2 rounded-full hover:bg-slate-100 dark:hover:bg-white/10 transition-colors">
          <ChevronLeft className="w-6 h-6 text-slate-900 dark:text-white" />
        </button>
        <h2 className="text-xl font-bold text-slate-900 dark:text-white">Support</h2>
      </div>
      <div className="flex-1 overflow-y-auto p-6 space-y-6 pb-32">
        <div className="grid grid-cols-2 gap-4">
          <div 
            onClick={() => {
              setSupportSubject('IT Helpdesk Request');
              document.getElementById('support-message')?.focus();
            }}
            className="p-4 rounded-[24px] bg-indigo-50 dark:bg-indigo-500/10 border border-indigo-100 dark:border-indigo-500/20 text-center cursor-pointer hover:bg-indigo-100 dark:hover:bg-indigo-500/20 transition-colors"
          >
            <div className="w-12 h-12 mx-auto rounded-full bg-white dark:bg-indigo-500/20 flex items-center justify-center text-indigo-600 dark:text-indigo-400 mb-3 shadow-sm">
              <HelpCircle className="w-6 h-6" />
            </div>
            <h3 className="font-semibold text-indigo-900 dark:text-indigo-100">IT Helpdesk</h3>
            <p className="text-xs text-indigo-600/70 dark:text-indigo-300/70 mt-1">Tech issues</p>
          </div>
          <div 
            onClick={() => {
              setSupportSubject('Academic Advisor Contact');
              document.getElementById('support-message')?.focus();
            }}
            className="p-4 rounded-[24px] bg-rose-50 dark:bg-rose-500/10 border border-rose-100 dark:border-rose-500/20 text-center cursor-pointer hover:bg-rose-100 dark:hover:bg-rose-500/20 transition-colors"
          >
            <div className="w-12 h-12 mx-auto rounded-full bg-white dark:bg-rose-500/20 flex items-center justify-center text-rose-600 dark:text-rose-400 mb-3 shadow-sm">
              <AlertCircle className="w-6 h-6" />
            </div>
            <h3 className="font-semibold text-rose-900 dark:text-rose-100">Academic</h3>
            <p className="text-xs text-rose-600/70 dark:text-rose-300/70 mt-1">Advisor contact</p>
          </div>
        </div>

        <div className="space-y-4">
          <h3 className="text-sm font-bold text-slate-400 uppercase tracking-wider">New Ticket</h3>
          <div className="p-5 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 shadow-sm space-y-4">
            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-neutral-300 mb-1.5">Subject</label>
              <input 
                type="text"
                value={supportSubject}
                onChange={(e) => setSupportSubject(e.target.value)}
                placeholder="Brief summary..."
                className="w-full bg-slate-50 dark:bg-black/20 border border-slate-200 dark:border-white/10 rounded-xl py-3 px-4 text-slate-900 dark:text-white placeholder:text-slate-500 focus:outline-none focus:border-indigo-500/50 transition-all"
              />
            </div>
            <div>
              <label className="block text-sm font-medium text-slate-700 dark:text-neutral-300 mb-1.5">Message</label>
              <textarea 
                id="support-message"
                rows={4}
                value={supportMessage}
                onChange={(e) => setSupportMessage(e.target.value)}
                placeholder="How can we help you?"
                className="w-full bg-slate-50 dark:bg-black/20 border border-slate-200 dark:border-white/10 rounded-xl py-3 px-4 text-slate-900 dark:text-white placeholder:text-slate-500 focus:outline-none focus:border-indigo-500/50 transition-all resize-none"
              />
            </div>
            <button 
              onClick={() => {
                if (!supportSubject.trim() || !supportMessage.trim()) return;
                handleSuccess("Support ticket created", {
                  id: Date.now(),
                  title: `Support: ${supportSubject}`,
                  date: 'Just now',
                  status: 'Open',
                  icon: HelpCircle,
                  type: 'support',
                  desc: supportMessage
                });
                setSupportSubject('');
                setSupportMessage('');
              }}
              disabled={!supportSubject.trim() || !supportMessage.trim()}
              className="w-full py-3 rounded-xl bg-slate-900 dark:bg-white text-white dark:text-black font-semibold hover:bg-slate-800 dark:hover:bg-slate-200 disabled:opacity-50 disabled:cursor-not-allowed transition-colors flex items-center justify-center gap-2"
            >
              <Send className="w-4 h-4" />
              Send Message
            </button>
          </div>
        </div>
      </div>
    </motion.div>
  );

  const renderAllRequests = () => (
    <motion.div 
      key="all-requests"
      initial={{ opacity: 0, x: 20 }}
      animate={{ opacity: 1, x: 0 }}
      exit={{ opacity: 0, x: 20 }}
      className="flex-1 flex flex-col bg-slate-50 dark:bg-[#050505] absolute inset-0 z-40"
    >
      <div className="pt-12 pb-6 px-6 bg-white/80 dark:bg-[#050505]/80 backdrop-blur-xl border-b border-slate-200 dark:border-white/10 sticky top-0 z-10 flex items-center gap-4">
        <button onClick={() => setActiveView('main')} className="p-2 -ml-2 rounded-full hover:bg-slate-100 dark:hover:bg-white/10 transition-colors">
          <ChevronLeft className="w-6 h-6 text-slate-900 dark:text-white" />
        </button>
        <h2 className="text-xl font-bold text-slate-900 dark:text-white">All Requests</h2>
      </div>
      <div className="flex-1 overflow-y-auto p-6 space-y-3 pb-32">
        {requests.map((req) => (
          <div 
            key={req.id} 
            onClick={() => setSelectedRequest(req)}
            className="p-4 rounded-[24px] bg-white dark:bg-white/5 border border-slate-200 dark:border-white/10 flex items-center justify-between shadow-sm cursor-pointer hover:bg-slate-50 dark:hover:bg-white/10 transition-colors"
          >
            <div className="flex items-center gap-4">
              <div className="w-10 h-10 rounded-full bg-slate-100 dark:bg-black/20 flex items-center justify-center text-slate-500 dark:text-neutral-400">
                <req.icon className="w-5 h-5" />
              </div>
              <div>
                <h4 className="font-medium text-slate-900 dark:text-white">{req.title}</h4>
                <p className="text-xs text-slate-500 dark:text-neutral-400">Requested on {req.date}</p>
              </div>
            </div>
            <div className={`px-3 py-1 rounded-full text-xs font-semibold ${
              req.status === 'Ready' 
                ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400'
                : req.status === 'Pending' || req.status === 'Processing' || req.status === 'Open'
                ? 'bg-blue-50 dark:bg-blue-500/10 text-blue-600 dark:text-blue-400'
                : 'bg-amber-50 dark:bg-amber-500/10 text-amber-600 dark:text-amber-400'
            }`}>
              {req.status}
            </div>
          </div>
        ))}
      </div>
    </motion.div>
  );

  return (
    <div className="absolute inset-0 flex flex-col bg-slate-50 dark:bg-[#050505] z-30">
      <AnimatePresence mode="wait">
        {activeView === 'main' && renderMain()}
        {activeView === 'documents' && renderDocuments()}
        {activeView === 'payments' && renderPayments()}
        {activeView === 'housing' && renderHousing()}
        {activeView === 'support' && renderSupport()}
        {activeView === 'all-requests' && renderAllRequests()}
      </AnimatePresence>

      {/* Request Details Modal */}
      <AnimatePresence>
        {selectedRequest && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 z-50 flex items-end sm:items-center justify-center bg-black/40 backdrop-blur-sm sm:p-6"
            onClick={() => setSelectedRequest(null)}
          >
            <motion.div
              initial={{ y: '100%' }}
              animate={{ y: 0 }}
              exit={{ y: '100%' }}
              transition={{ type: 'spring', damping: 25, stiffness: 200 }}
              onClick={(e) => e.stopPropagation()}
              className="bg-white dark:bg-[#111] w-full sm:max-w-md rounded-t-[32px] sm:rounded-[32px] p-6 pb-12 sm:pb-6 shadow-2xl flex flex-col"
            >
              <div className="w-12 h-1.5 bg-slate-200 dark:bg-white/20 rounded-full mx-auto mb-6 sm:hidden" />
              
              <div className="flex items-center gap-4 mb-6">
                <div className="w-14 h-14 rounded-2xl bg-slate-100 dark:bg-white/5 flex items-center justify-center text-slate-600 dark:text-neutral-300">
                  <selectedRequest.icon className="w-7 h-7" />
                </div>
                <div>
                  <h3 className="text-xl font-bold text-slate-900 dark:text-white">{selectedRequest.title}</h3>
                  <p className="text-sm text-slate-500 dark:text-neutral-400">ID: REQ-{selectedRequest.id.toString().padStart(5, '0')}</p>
                </div>
              </div>

              <div className="space-y-4 mb-8">
                <div className="flex justify-between items-center py-3 border-b border-slate-100 dark:border-white/5">
                  <span className="text-slate-500 dark:text-neutral-400">Status</span>
                  <span className={`px-3 py-1 rounded-full text-xs font-semibold ${
                    selectedRequest.status === 'Ready' 
                      ? 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400'
                      : selectedRequest.status === 'Pending' || selectedRequest.status === 'Processing' || selectedRequest.status === 'Open'
                      ? 'bg-blue-50 dark:bg-blue-500/10 text-blue-600 dark:text-blue-400'
                      : 'bg-amber-50 dark:bg-amber-500/10 text-amber-600 dark:text-amber-400'
                  }`}>
                    {selectedRequest.status}
                  </span>
                </div>
                <div className="flex justify-between items-center py-3 border-b border-slate-100 dark:border-white/5">
                  <span className="text-slate-500 dark:text-neutral-400">Date</span>
                  <span className="font-medium text-slate-900 dark:text-white">{selectedRequest.date}</span>
                </div>
                <div className="py-3">
                  <span className="block text-slate-500 dark:text-neutral-400 mb-2">Description</span>
                  <p className="text-slate-900 dark:text-white text-sm leading-relaxed">
                    {selectedRequest.desc}
                  </p>
                </div>
              </div>

              <button 
                onClick={() => setSelectedRequest(null)}
                className="w-full py-3.5 rounded-xl bg-slate-100 dark:bg-white/10 text-slate-900 dark:text-white font-semibold hover:bg-slate-200 dark:hover:bg-white/20 transition-colors"
              >
                Close
              </button>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>

      {/* Success Modal Overlay */}
      <AnimatePresence>
        {showSuccessModal && (
          <motion.div
            initial={{ opacity: 0 }}
            animate={{ opacity: 1 }}
            exit={{ opacity: 0 }}
            className="absolute inset-0 z-50 flex items-center justify-center bg-black/40 backdrop-blur-sm px-6"
          >
            <motion.div
              initial={{ scale: 0.9, opacity: 0 }}
              animate={{ scale: 1, opacity: 1 }}
              exit={{ scale: 0.9, opacity: 0 }}
              className="bg-white dark:bg-[#111] p-6 rounded-3xl shadow-2xl flex flex-col items-center text-center max-w-[280px] w-full"
            >
              <div className="w-16 h-16 rounded-full bg-emerald-100 dark:bg-emerald-500/20 flex items-center justify-center text-emerald-600 dark:text-emerald-400 mb-4">
                <CheckCircle2 className="w-8 h-8" />
              </div>
              <h3 className="text-lg font-bold text-slate-900 dark:text-white mb-2">Success</h3>
              <p className="text-sm text-slate-500 dark:text-neutral-400">{successMessage}</p>
            </motion.div>
          </motion.div>
        )}
      </AnimatePresence>
    </div>
  );
};

// Helper component for Service Cards
const ServiceCard = ({ icon: Icon, title, subtitle, color, onClick }: any) => {
  const colorMap: Record<string, string> = {
    indigo: 'bg-indigo-50 dark:bg-indigo-500/10 text-indigo-600 dark:text-indigo-400',
    emerald: 'bg-emerald-50 dark:bg-emerald-500/10 text-emerald-600 dark:text-emerald-400',
    amber: 'bg-amber-50 dark:bg-amber-500/10 text-amber-600 dark:text-amber-400',
    rose: 'bg-rose-50 dark:bg-rose-500/10 text-rose-600 dark:text-rose-400',
  };

  return (
    <div 
      onClick={onClick}
      className="p-5 rounded-[28px] bg-white dark:bg-transparent dark:bg-gradient-to-br dark:from-white/[0.08] dark:to-white/[0.02] border border-slate-200 dark:border-white/10 backdrop-blur-md shadow-sm hover:shadow-md transition-shadow cursor-pointer group flex flex-col items-center text-center gap-3"
    >
      <div className={`w-14 h-14 rounded-full flex items-center justify-center group-hover:scale-110 transition-transform ${colorMap[color]}`}>
        <Icon className="w-7 h-7" />
      </div>
      <div>
        <h3 className="font-semibold text-slate-900 dark:text-white">{title}</h3>
        <p className="text-[11px] text-slate-500 dark:text-neutral-400 mt-1">{subtitle}</p>
      </div>
    </div>
  );
};
